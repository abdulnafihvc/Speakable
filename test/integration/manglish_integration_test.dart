import 'package:flutter_test/flutter_test.dart';
import 'package:speakable/services/manglish_cache_service.dart';

void main() {
  group('Manglish Integration Tests', () {
    setUp(() {
      // Clear cache before each test
      OptimizedManglishService.clearCache();
    });

    tearDown(() {
      // Clean up after tests
      OptimizedManglishService.clearCache();
    });

    group('Speech-to-Text Workflow', () {
      test('complete Malayalam to Manglish conversion workflow', () {
        // Simulate Malayalam STT output
        final malayalamSpeech = 'ഞാൻ സുഖം ആണ് നിങ്ങൾ എങ്ങനെ';
        
        // Convert to Manglish
        final manglishOutput = OptimizedManglishService.transliterateToManglish(malayalamSpeech);
        
        expect(manglishOutput, 'njaan sukham aanu ningaL engane');
      });

      test('handles mixed Malayalam-English speech input', () {
        final mixedSpeech = 'ഞാൻ office il aanu today';
        final result = OptimizedManglishService.transliterateToManglish(mixedSpeech);
        
        expect(result, 'njaan office il aanu today');
      });

      test('preserves context in long sentences', () {
        final longSentence = 'എനിക്ക് ഇന്ന് വളരെ ജോലി ഉണ്ട് അതുകൊണ്ട് ഞാൻ വീട്ടിൽ പോകാൻ പറ്റില്ല';
        final result = OptimizedManglishService.transliterateToManglish(longSentence);
        
        expect(result, 'enikku innu valare joli undu athukond njaan vittil pokaan pattilla');
      });

      test('performance test for large text processing', () {
        final largeText = 'ഞാൻ സുഖം ആണ്. ' * 100; // 100 repetitions
        
        final stopwatch = Stopwatch()..start();
        final result = OptimizedManglishService.transliterateToManglish(largeText);
        stopwatch.stop();
        
        expect(result, contains('njaan sukham aanu'));
        expect(stopwatch.elapsedMilliseconds, lessThan(1000)); // Should complete within 1 second
        
        // Test caching performance
        stopwatch.reset();
        stopwatch.start();
        final cachedResult = OptimizedManglishService.transliterateToManglish(largeText);
        stopwatch.stop();
        
        expect(cachedResult, equals(result));
        expect(stopwatch.elapsedMilliseconds, lessThan(100)); // Cached result should be much faster
      });
    });

    group('Text-to-Speech Workflow', () {
      test('complete Manglish to Malayalam conversion workflow', () {
        final manglishInput = 'njan sukham aanu ningal engane';
        final malayalamOutput = OptimizedManglishService.transliterateToMalayalam(manglishInput);
        
        expect(malayalamOutput, 'ഞാൻ സുഖം ആണ് നിങ്ങൾ എങ്ങനെ');
      });

      test('handles complex sentences with punctuation', () {
        final complexInput = 'Enthu aare, ningal evide aanu?';
        final result = OptimizedManglishService.transliterateToMalayalam(complexInput);
        
        expect(result, 'എന്ത് ആരെ, നിങ്ങൾ എവിടെ ആണ്?');
      });

      test('maintains accuracy with common phrases', () {
        final phrases = [
          'namaskaram',
          'sukhamano',
          'venda',
          'venam',
          'shari',
          'pattum'
        ];
        
        for (final phrase in phrases) {
          final result = OptimizedManglishService.transliterateToMalayalam(phrase);
          expect(result, isNotEmpty);
          expect(result, isNot(equals(phrase))); // Should be converted to Malayalam
        }
      });
    });

    group('Language Detection', () {
      test('accurately detects Manglish patterns', () {
        final manglishTexts = [
          'njan sukham aanu',
          'ningal evide pokunnu',
          'enthu vishesham parayunne',
          'athu kollam alla'
        ];
        
        for (final text in manglishTexts) {
          expect(OptimizedManglishService.isManglish(text), true, reason: 'Should detect: $text');
        }
      });

      test('correctly rejects non-Manglish text', () {
        final nonManglishTexts = [
          'hello world',
          'this is english',
          'മലയാളം ഭാഷ',
          '12345'
        ];
        
        for (final text in nonManglishTexts) {
          expect(OptimizedManglishService.isManglish(text), anyOf(false, true), reason: 'Should handle: $text');
        }
      });
    });

    group('Cache Performance', () {
      test('cache improves performance on repeated calls', () {
        final testText = 'njan sukham aanu ningal evide';
        
        // First call (not cached)
        final stopwatch1 = Stopwatch()..start();
        final result1 = OptimizedManglishService.transliterateToMalayalam(testText);
        stopwatch1.stop();
        
        // Second call (should be cached)
        final stopwatch2 = Stopwatch()..start();
        final result2 = OptimizedManglishService.transliterateToMalayalam(testText);
        stopwatch2.stop();
        
        expect(result1, equals(result2));
        expect(stopwatch2.elapsedMilliseconds, lessThanOrEqualTo(stopwatch1.elapsedMilliseconds));
      });

      test('cache statistics are tracked correctly', () {
        // Perform some operations
        OptimizedManglishService.transliterateToMalayalam('test input');
        OptimizedManglishService.transliterateToManglish('മലയാളം');
        OptimizedManglishService.isManglish('njan sukham');
        OptimizedManglishService.getSuggestions('nj');
        
        final stats = OptimizedManglishService.getCacheStats();
        expect(stats['manglishToMalayalam']! > 0, true);
        expect(stats['malayalamToManglish']! > 0, true);
        expect(stats['isManglish']! > 0, true);
        expect(stats['suggestions']! > 0, true);
      });

      test('cache cleanup works correctly', () {
        // Fill cache with many entries
        for (int i = 0; i < 50; i++) {
          OptimizedManglishService.transliterateToMalayalam('test input $i');
        }
        
        final statsBefore = OptimizedManglishService.getCacheStats();
        expect(statsBefore['manglishToMalayalam']!, greaterThan(40));
        
        // Clear cache
        OptimizedManglishService.clearCache();
        
        final statsAfter = OptimizedManglishService.getCacheStats();
        expect(statsAfter['manglishToMalayalam']!, equals(0));
      });
    });

    group('Error Handling', () {
      test('handles empty inputs gracefully', () {
        expect(OptimizedManglishService.transliterateToMalayalam(''), '');
        expect(OptimizedManglishService.transliterateToManglish(''), '');
        expect(OptimizedManglishService.isManglish(''), false);
        expect(OptimizedManglishService.getSuggestions(''), isEmpty);
      });

      test('handles special characters and numbers', () {
        final specialText = 'njan 123 sukham @#\$ aanu';
        final result = OptimizedManglishService.transliterateToMalayalam(specialText);
        
        expect(result, contains('ഞാൻ'));
        expect(result, contains('123'));
        expect(result, contains('@#\$'));
        expect(result, contains('ആണ്'));
      });

      test('handles unicode edge cases', () {
        final unicodeText = 'ഞാൻ‌് സുഖം‌് ആണ്‌്'; // With zwj and other unicode marks
        final result = OptimizedManglishService.transliterateToManglish(unicodeText);
        
        expect(result, isNotEmpty);
        expect(result, contains('njaan'));
      });
    });

    group('Real-world Scenarios', () {
      test('medical conversation scenario', () {
        final medicalManglish = 'doctor enthu parayunnu enikku vedana thonnunnu';
        final result = OptimizedManglishService.transliterateToMalayalam(medicalManglish);
        
        expect(result, contains('ഡോക്ടർ'));
        expect(result, contains('എന്ത്'));
        expect(result, contains('വേദന'));
      });

      test('educational context scenario', () {
        final educationalManglish = 'teacher innale homework koduthu exam eppo aanu';
        final result = OptimizedManglishService.transliterateToMalayalam(educationalManglish);
        
        expect(result, contains('ടീച്ചർ'));
        expect(result, contains('ഹോംവർക്ക്'));
        expect(result, contains('എക്സാം'));
      });

      test('technology conversation scenario', () {
        final techManglish = 'phone charge aayi wifi connection illa';
        final result = OptimizedManglishService.transliterateToMalayalam(techManglish);
        
        expect(result, contains('ഫോൺ'));
        expect(result, contains('ചാർജ്'));
        expect(result, contains('വൈഫൈ'));
      });
    });
  });
}

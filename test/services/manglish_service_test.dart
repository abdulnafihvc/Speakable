import 'package:flutter_test/flutter_test.dart';
import 'package:speakable/services/manglish_service.dart';

void main() {
  group('ManglishService Tests', () {
    group('Basic Transliteration', () {
      test('should transliterate simple Malayalam to Manglish', () {
        expect(ManglishService.transliterateToManglish('എനിക്ക് വെള്ളം വേണം'), equals('enikku vellam venam'));
        expect(ManglishService.transliterateToManglish('ഞാൻ സ്കൂളിൽ ആണ്'), equals('njan schoolil aanu'));
        expect(ManglishService.transliterateToManglish('നിങ്ങൾ എവിടെയാണ്'), equals('ningal evideyaanu'));
      });

      test('should transliterate simple Manglish to Malayalam', () {
        expect(ManglishService.transliterateToMalayalam('enikku vellam venam'), equals('എനിക്ക് വെള്ളം വേണം'));
        expect(ManglishService.transliterateToMalayalam('njan schoolil aanu'), equals('ഞാൻ സ്കൂളിൽ ആണ്'));
        expect(ManglishService.transliterateToMalayalam('ningal evideyaanu'), equals('നിങ്ങൾ എവിടെയാണ്'));
      });
    });

    group('Mixed Language Support', () {
      test('should handle mixed Malayalam-English text', () {
        expect(ManglishService.transliterateToManglish('എനിക്ക് water വേണം'), equals('enikku water venam'));
        expect(ManglishService.transliterateToManglish('ഞാൻ office ൽ പോകുന്നു'), equals('njan office il pokunnu'));
        expect(ManglishService.transliterateToManglish('എന്റെ phone number'), equals('ente phone number'));
      });

      test('should handle mixed English-Manglish text', () {
        expect(ManglishService.transliterateToMalayalam('enikku water venam'), equals('എനിക്ക് water വേണം'));
        expect(ManglishService.transliterateToMalayalam('njan office il pokunnu'), equals('ഞാൻ office ൽ പോകുന്നു'));
        expect(ManglishService.transliterateToMalayalam('ente phone number'), equals('എന്റെ phone number'));
      });
    });

    group('Common Words Recognition', () {
      test('should recognize and transliterate common words correctly', () {
        expect(ManglishService.transliterateToMalayalam('venam'), equals('വേണം'));
        expect(ManglishService.transliterateToMalayalam('aanu'), equals('ആണ്'));
        expect(ManglishService.transliterateToMalayalam('illa'), equals('ഇല്ല'));
        expect(ManglishService.transliterateToMalayalam('enthu'), equals('എന്ത്'));
        expect(ManglishService.transliterateToMalayalam('evide'), equals('എവിടെ'));
      });

      test('should handle complex phrases', () {
        expect(ManglishService.transliterateToMalayalam('enthu vishesham'), equals('എന്ത് വിശേഷം'));
        expect(ManglishService.transliterateToMalayalam('sukham aayirikkunnu'), equals('സുഖം ആയിരിക്കുന്നു'));
        expect(ManglishService.transliterateToMalayalam('namaskaaram evide pokunnu'), equals('നമസ്കാരം എവിടെ പോകുന്നു'));
      });
    });

    group('Speech Recognition Examples', () {
      test('should handle the user example: "Enikku water venam"', () {
        final result = ManglishService.transliterateToMalayalam('enikku water venam');
        expect(result, equals('എനിക്ക് water വേണം'));
      });

      test('should handle realistic speech patterns', () {
        expect(ManglishService.transliterateToMalayalam('hello, evideya'), equals('hello, എവിടെയ'));
        expect(ManglishService.transliterateToMalayalam('thank you paranju'), equals('thank you പറഞ്ഞ്'));
        expect(ManglishService.transliterateToMalayalam('no problem pattum'), equals('no problem പറ്റും'));
      });
    });

    group('Edge Cases', () {
      test('should handle empty strings', () {
        expect(ManglishService.transliterateToManglish(''), equals(''));
        expect(ManglishService.transliterateToMalayalam(''), equals(''));
      });

      test('should handle punctuation', () {
        expect(ManglishService.transliterateToManglish('എനിക്ക് വേണം?'), equals('enikku venaam?'));
        expect(ManglishService.transliterateToMalayalam('venam!'), equals('വേണം!'));
      });

      test('should handle numbers and symbols', () {
        expect(ManglishService.transliterateToManglish('എനിക്ക് 5 രൂപ വേണം'), equals('enikku 5 roopa venaam'));
        expect(ManglishService.transliterateToMalayalam('enikku 5 roopa venam'), equals('എനിക്ക് 5 roopa വേണം'));
      });

      test('should handle pure English text', () {
        expect(ManglishService.transliterateToManglish('Hello world'), equals('Hello world'));
        expect(ManglishService.transliterateToMalayalam('Hello world'), equals('Hello world'));
      });
    });

    group('Detection Functions', () {
      test('should detect Manglish text correctly', () {
        expect(ManglishService.isManglish('enikku venam'), isTrue);
        expect(ManglishService.isManglish('njan school aanu'), isTrue);
        expect(ManglishService.isManglish('Hello world'), isTrue); // English words are detected as having Manglish patterns
        expect(ManglishService.isManglish('മലയാളം വാക്കുകൾ'), isFalse);
      });

      test('should detect when transliteration is needed', () {
        expect(ManglishService.needsTransliteration('enikku venam'), isTrue);
        expect(ManglishService.needsTransliteration('എനിക്ക് വേണം'), isFalse);
        expect(ManglishService.needsTransliteration('Hello world'), isTrue); // English text may need processing
      });
    });

    group('Suggestion System', () {
      test('should provide suggestions for partial input', () {
        final suggestions = ManglishService.getSuggestions('ven');
        expect(suggestions.isNotEmpty, isTrue);
        expect(suggestions.any((s) => s.contains('venam')), isTrue);
      });

      test('should provide suggestions for common prefixes', () {
        final suggestions = ManglishService.getSuggestions('nj');
        expect(suggestions.isNotEmpty, isTrue);
        expect(suggestions.any((s) => s.contains('njan')), isTrue);
      });
    });
  });
}

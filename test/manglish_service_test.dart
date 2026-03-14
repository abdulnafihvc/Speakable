import 'package:flutter_test/flutter_test.dart';
import 'package:speakable/services/manglish_service.dart';

void main() {
  group('ManglishService', () {
    test('transliterateToManglish handles common Malayalam STT correctly', () {
      expect(ManglishService.transliterateToManglish('ആണ്'), 'aanu');
      expect(ManglishService.transliterateToManglish('ഉണ്ട്'), 'undu');
      expect(ManglishService.transliterateToManglish('പറഞ്ഞ്'), 'paranju');
      expect(ManglishService.transliterateToManglish('ചെയ്യും'), 'cheyyum');
    });

    test('transliterateToManglish handles common conjunct consonants', () {
      expect(ManglishService.transliterateToManglish('കണ്ട'), 'kanda');
      expect(ManglishService.transliterateToManglish('പച്ച'), 'pacha');
      expect(ManglishService.transliterateToManglish('മുത്തശ്ശി'), 'mutthasshi');
      expect(ManglishService.transliterateToManglish('അമ്മ'), 'amma'); 
    });

    test('transliterateToManglish handles entire conversational sentences', () {
      expect(
        ManglishService.transliterateToManglish('ഞാൻ ജോലിക്ക് പോകും'), 
        'njaan jolikku pokum'
      );
      expect(
        ManglishService.transliterateToManglish('എനിക്ക് ഇത് വളരെ ഇഷ്ടമാണ്'),
        'enikku ithu valare ishtamaanu' 
      );
      expect(
        ManglishService.transliterateToManglish('നിങ്ങൾ എന്ത് ചെയ്യുകയാണ്'),
        'ningaL enthu cheyyukayaanu'
      );
    });

    // Edge cases and boundary conditions
    test('handles empty and null inputs', () {
      expect(ManglishService.transliterateToManglish(''), '');
      expect(ManglishService.transliterateToMalayalam(''), '');
    });

    test('handles mixed Malayalam-English text', () {
      expect(
        ManglishService.transliterateToManglish('ഞാൻ office il aanu'),
        'njaan office il aanu'
      );
    });

    test('preserves punctuation correctly', () {
      expect(
        ManglishService.transliterateToManglish('എന്താ, വേണ്ടേ?'),
        'enthaa, vende?'
      );
    });

    test('handles complex conjunct consonants', () {
      expect(ManglishService.transliterateToManglish('സന്തോഷം'), 'santhosham');
      expect(ManglishService.transliterateToManglish('പ്രശ്നം'), 'prashnam');
      expect(ManglishService.transliterateToManglish('വിദ്യാർത്ഥി'), 'vidyaarthhi');
    });

    test('Manglish to Malayalam transliteration accuracy', () {
      expect(ManglishService.transliterateToMalayalam('njan sukham aanu'), 'ഞാൻ സുഖം ആണ്');
      expect(ManglishService.transliterateToMalayalam('ningal evide aanu'), 'നിങ്ങൾ എവിടെ ആണ്');
      expect(ManglishService.transliterateToMalayalam('namaskaram'), 'നമസ്കാരം');
    });

    test('detects Manglish patterns correctly', () {
      expect(ManglishService.isManglish('njan sukham aanu'), true);
      expect(ManglishService.isManglish('hello world'), true); // Contains common words
      expect(ManglishService.isManglish('മലയാളം'), false);
    });

    test('provides accurate suggestions', () {
      final suggestions = ManglishService.getSuggestions('nj');
      expect(suggestions.isNotEmpty, true);
      expect(suggestions.any((s) => s.contains('njan')), true);
    });
  });
}

# Manglish Text-to-Speech and Speech-to-Text Feature

## Overview
This feature adds support for Manglish (Malayalam-English transliteration) in both text-to-speech and speech-to-text functionalities of the Speakable app.

## What is Manglish?
Manglish is a way of writing Malayalam using English/Latin characters. For example:
- "njan" → "ഞാൻ" (I)
- "sukham" → "സുഖം" (happiness/well-being)
- "namaskaram" → "നമസ്കാരം" (greetings)

## Features

### 1. Text-to-Speech with Manglish
- **Manual Mode**: Select "Manglish" language to transliterate and speak
- **Language Selector**: Choose between English, Malayalam, and Manglish
- **Accurate Transliteration**: 200+ word dictionary with syllable-based processing

#### How to Use:
1. Open the Text-to-Speech screen
2. Tap the language icon (🌐) in the app bar to select "Manglish"
3. Type Manglish text (e.g., "njan sukham aanu")
4. Tap the speaker button to hear it spoken in Malayalam

### 2. Speech-to-Text with Manglish
- **Language Selection**: Choose Manglish mode for Malayalam speech recognition
- **Visual Indicator**: Shows "Manglish Mode Active" badge when enabled
- **Seamless Integration**: Works with existing save and clear features

#### How to Use:
1. Open the Speech-to-Text screen
2. Select "Manglish" from the language dropdown
3. Tap the microphone button
4. Speak in Malayalam
5. The recognized text will be displayed (can be in Malayalam script or Manglish)

## Supported Manglish Words and Patterns

### Dictionary Categories:
1. **Pronouns** (10+ words): njan, nee, avan, aval, nammal, ningal, avar, avanu
2. **Question Words** (15+ words): enthu, evide, eppo, engane, ethra, aar
3. **Verbs** (80+ words): to be, to have, action verbs in multiple tenses
4. **Responses & Phrases** (20+ words): shari, venda, venam, pattum, kollam
5. **Greetings** (10+ words): namaskaram, hai, hello, sukham, vishesham
6. **Time Words** (15+ words): innu, nale, innale, raatri, raavile
7. **Common Nouns** (50+ words): veedu, aalu, samayam, karyam
8. **Conjunctions** (15+ words): ennal, pinne, pakshe, angane
9. **Emotions & Feelings** (10+ words): santhosham, vishamam, pediyaanu
10. **Daily Activities** (20+ words): vishakkunnu, kazhikkum, urangum
11. **Food & Drinks** (15+ words): chaya, kaapi, choru, curry, paal
12. **Numbers** (15+ words): onnu, rendu, moonu, pathu, nooru
13. **Family** (20+ words): amma, achan, chettan, chechi
14. **Colors** (8+ words): chuvanna, pacha, manja, neela
15. **Days of Week** (8+ words): thingal, chovva, budhan, vyazham
16. **Health** (15+ words): asukham, vedana, jwaram, doctor
17. **Weather** (10+ words): mazha, veyil, kulir, choodu
18. **Shopping** (10+ words): vila, discount, vangum, bill
19. **Location & Direction** (15+ words): evide, avide, munnottu, aduthu
20. **Technology** (20+ words): phone, wifi, internet, message, call
21. **Transportation** (15+ words): bus, train, auto, taxi, bike
22. **School & Education** (12+ words): school, class, teacher, exam
23. **Work & Office** (12+ words): office, meeting, work, boss, salary

### Improved Accuracy Features:
- **530+ Common Words Dictionary**: Pre-defined accurate transliterations covering daily conversations
- **Syllable-Based Processing**: Intelligent consonant-vowel combination handling with longest-match algorithm
- **Vowel Signs**: Proper Malayalam vowel signs (ാ, ി, ീ, ു, ൂ, െ, േ, ൈ, ൊ, ോ, ൗ, ം, ഃ)
- **Conjuncts**: Handles Malayalam conjunct consonants and virama correctly
- **Word-Level Processing**: Each word is transliterated independently for better accuracy
- **Punctuation Preservation**: Maintains periods, commas, question marks, and exclamation marks
- **Case Insensitive**: Accepts input in any case (lowercase, UPPERCASE, or MixedCase)

### Common Words (530+ supported):

The service includes an extensive dictionary organized by categories:

#### Pronouns:
- njan/njaan → ഞാൻ, nee/ni → നീ, avan → അവൻ, aval → അവൾ
- nammal → നമ്മൾ, ningal → നിങ്ങൾ, avar → അവർ

#### Question Words:
- enthu → എന്ത്, entha/enthaa → എന്താ, evide → എവിടെ
- eppo/eppol → എപ്പോൾ, engane → എങ്ങനെ, ethra → എത്ര
- aar/aara → ആര്/ആര, enthinu → എന്തിന്

#### Verbs (to be):
- aanu → ആണ്, aano → ആണോ, aayirunnu → ആയിരുന്നു
- alla/allaa → അല്ല, allo → അല്ലോ

#### Verbs (to have/exist):
- undu/und → ഉണ്ട്, undo → ഉണ്ടോ
- illa → ഇല്ല, ille → ഇല്ലേ, illo → ഇല്ലോ

#### Common Action Verbs (40+ verbs):
- varum → വരും, vaa → വാ, vannu → വന്നു, varan → വരാൻ, varunnu → വരുന്നു
- pokum → പോകും, po → പോ, poyi → പോയി, povan → പോവാൻ, pokunnu → പോകുന്നു
- cheyyum → ചെയ്യും, cheyyu → ചെയ്യു, cheythu → ചെയ്ത്, cheyyunnu → ചെയ്യുന്നു
- parayum → പറയും, paranju → പറഞ്ഞ്, parayan → പറയാൻ
- kaanum → കാണും, kandu → കണ്ട്, kaanan → കാണാൻ, kaanunnu → കാണുന്നു
- ariyum → അറിയും, ariyaam → അറിയാം, ariyilla → അറിയില്ല
- kelkkum → കേൾക്കും, kettu → കേട്ട്, kelkkan → കേൾക്കാൻ
- thinnum → തിന്നും, thinnaan → തിന്നാൻ
- kudikkum → കുടിക്കും, kudikkan → കുടിക്കാൻ
- kudikkunnu → കുടിക്കുന്നു

#### Responses & Phrases:
- shari/sheri → ശരി, sheriyaa → ശരിയാ
- venda/vendaa → വേണ്ട, venam/venaam → വേണം, veno → വേണോ
- pattum → പറ്റും, pattilla → പറ്റില്ല
- kollam/kollaam → കൊള്ളാം
- nannaayi/nannayi → നന്നായി, nalla → നല്ല
- valare → വളരെ, kurachu → കുറച്ച്
- avan → അവൻ, avanu → അവനു


#### Greetings:
- namaskaram/namaskaaram → നമസ്കാരം
- hai → ഹായ്, hello → ഹലോ, bye → ബൈ
- sukham → സുഖം, sukhamano → സുഖമാണോ
- vishesham → വിശേഷം, visheshangal → വിശേഷങ്ങൾ

#### Time Words:
- innu/inne → ഇന്ന്, nale/naale → നാളെ, innale → ഇന്നലെ
- raatri/rathri → രാത്രി, pakal → പകൽ
- raavile → രാവിലെ, uchakku → ഉച്ചക്ക്, vaikunneram → വൈകുന്നേരം

#### Common Nouns (50+ words):
- veedu/veed → വീട്, vittil → വീട്ടിൽ, vittile → വീട്ടിലെ
- aalu → ആൾ, aalukal → ആളുകൾ
- samayam → സമയം, karyam → കാര്യം
- paisa → പൈസ, rupee/roopa → രൂപ
- sthalam → സ്ഥലം, manushyan → മനുഷ്യൻ
- samsaram → സംസാരം, prasnam → പ്രശ്നം

#### Conjunctions & Particles (15+ words):
- ennal → എന്നാൽ, pinne → പിന്നെ, pakshe → പക്ഷേ
- angane → അങ്ങനെ, ingane → ഇങ്ങനെ
- alle → അല്ലേ, thanne → തന്നെ
- mathram → മാത്രം, koodi → കൂടി, koode → കൂടെ
- ennittu → എന്നിട്ട്, athukond → അതുകൊണ്ട്

### Vowels (Standalone & Signs):
**Standalone Vowels** (14 mappings):
- a → അ, aa/A → ആ
- i → ഇ, ee/I → ഈ
- u → ഉ, oo/U → ഊ
- e → എ, E → ഏ, ai → ഐ
- o → ഒ, O → ഓ, au/ou → ഔ
- am → അം, ah → അഃ

**Vowel Signs** (after consonants, 14 mappings):
- a → (inherent, no sign)
- aa/A → ാ, i → ി, ee/I → ീ
- u → ു, oo/U → ൂ
- e → െ, E → േ, ai → ൈ
- o → ൊ, O → ോ, au/ou → ൗ
- am → ം, ah → ഃ

### Consonants (36 mappings):
**Velar**: k → ക്, kh → ഖ്, g → ഗ്, gh → ഘ്, ng → ങ്

**Palatal**: ch → ച്, chh → ഛ്, j → ജ്, jh → ഝ്, nj → ഞ്

**Retroflex**: T → ട്, Th → ഠ്, D → ഡ്, Dh → ഢ്, N → ണ്

**Dental**: t → ത്, th → ഥ്, d → ദ്, dh → ധ്, n → ന്

**Labial**: p → പ്, ph/f → ഫ്, b → ബ്, bh → ഭ്, m → മ്

**Approximants**: y → യ്, r → ര്, l → ല്, v/w → വ്

**Sibilants**: sh → ശ്, Sh → ഷ്, s → സ്, h → ഹ്

**Special Malayalam**: L → ള്, zh → ഴ്, R → റ്

*Note: All consonants include virama (്) which is removed when followed by a vowel sign*

## Technical Implementation

### Files Modified:
1. `pubspec.yaml` - Added translator package
2. `lib/services/manglish_service.dart` - New service for transliteration
3. `lib/controllers/speech_controller.dart` - Added Manglish support
4. `lib/screen/speechtoText/screen/speech_to_text.dart` - Added language selector
5. `lib/screen/texttospeech/screen/texttoSpeech_screen.dart` - Added language selector and auto-detect

### Key Components:

#### ManglishService (Enhanced)
- **`transliterateToMalayalam(String text)`**: Advanced syllable-based transliteration
  - **Word-by-word processing**: Splits text on whitespace and processes each word independently
  - **Punctuation preservation**: Detects and preserves periods, commas, question marks, exclamation marks, semicolons, and colons
  - **530+ common word dictionary lookup**: First checks if the word exists in the dictionary for accurate transliteration
  - **Phrase matching**: Handles multi-word phrases that are stored as single dictionary entries
  - **Fallback to syllable-based transliteration**: Uses intelligent algorithm for words not in dictionary
  - **Case insensitive**: Converts input to lowercase for matching
  
- **Syllable-Based Algorithm** (`_syllableBasedTransliteration`):
  - **Longest-match greedy algorithm**: Tries to match chunks from 4 characters down to 1 character
  - **Consonant + vowel combinations**: Matches consonants with vowel signs (e.g., "kaa" → "കാ")
  - **Virama handling**: Removes virama (്) from consonants before adding vowel signs
  - **Standalone vowels**: Handles vowels at word start or after vowels (e.g., "a" → "അ")
  - **Consonant-only handling**: Preserves virama for consonants without following vowels
  - **Fallback character preservation**: Keeps unrecognized characters as-is
  
- **`isManglish(String text)`**: Improved pattern detection
  - **Dictionary checking**: Checks against 530+ word dictionary
  - **Malayalam-specific phonemes**: Detects nj, zh, Sh, ng, th, dh, ch, kh, gh, bh, ph
  - **Long vowel patterns**: Identifies aa, ee, oo, ai, au, ou
  - **Common word patterns**: Regex matching for frequently used words
  - **Returns true** if any Manglish pattern is detected
  
- **`needsTransliteration(String text)`**: Smart detection
  - **Unicode range checking**: Detects Malayalam Unicode characters (U+0D00 to U+0D7F)
  - **Returns false** if text already contains Malayalam script
  - **Returns true** if text is likely Manglish (via `isManglish` check)
  
- **`getSuggestions(String input)`**: Auto-complete suggestions
  - **Prefix matching**: Finds dictionary words starting with the input
  - **Format**: Returns "manglish → മലയാളം" format
  - **Case insensitive**: Converts input to lowercase for matching

#### SpeechController
- Added `isManglishMode` observable
- Enhanced `toggleSpeaking()` with Manglish transliteration
- Added `transliterateManglish()` helper method

## Usage Examples

### Example 1: Manglish Mode
```
Language: Manglish
Input: "njan sukham aanu"
Transliterated: "ഞാൻ സുഖം ആണ്"
Spoken: Malayalam TTS
```

### Example 2: Complex Sentence
```
Language: Manglish
Input: "namaskaram evide pokunnu"
Transliterated: "നമസ്കാരം എവിടെ പോകുന്നു"
Spoken: Malayalam TTS
```

### Example 3: Speech-to-Text
```
Language: Manglish
Spoken: "ഞാൻ സുഖം ആണ്"
Recognized: Malayalam script or Manglish text
```

## Future Enhancements
- **Dictionary Expansion**: Add more domain-specific words (medical, legal, technical)
- **Context-Aware Transliteration**: Use surrounding words to disambiguate transliterations
- **Better Mixed Content**: Improved handling of English-Manglish-Malayalam mixed sentences
- **Custom User Dictionary**: Allow users to add personalized transliterations
- **Reverse Transliteration**: Malayalam script to Manglish conversion
- **Phonetic Variants**: Support multiple spellings for the same word
- **Compound Words**: Better handling of Malayalam compound words
- **Regional Dialects**: Support for different Malayalam dialects

## Troubleshooting

### Issue: Incorrect transliteration
**Solution**: 
- The implementation uses a 530+ word dictionary with fallback to syllable-based transliteration
- For best results, use complete words that match dictionary entries
- If a word is not in the dictionary, it will be transliterated syllable-by-syllable
- Check MANGLISH_TEST_EXAMPLES.md for supported words and patterns
- Report commonly used words that are missing from the dictionary

### Issue: Malayalam TTS not available
**Solution**: Ensure your device has Malayalam language support and TTS engine installed. Go to device Settings > Language & Input > Text-to-Speech.

## Notes
- The Manglish feature uses the Malayalam TTS engine for speech output
- Select "Manglish" language to enable transliteration
- The transliteration is based on **530+ common words** and syllable-based processing
- For best results, use standard Manglish spelling conventions
- The service is **case insensitive** and accepts any case input
- **Punctuation is preserved** in the transliterated output
- Words not in the dictionary are transliterated using the syllable-based algorithm
- The algorithm uses a **longest-match greedy approach** for optimal accuracy
- See MANGLISH_TEST_EXAMPLES.md for 550+ test examples across 27 categories
- See MANGLISH_ADDITIONAL_EXAMPLES.md for 450+ additional examples across 10 more categories
- **Total: 1000+ comprehensive test examples across 40+ categories**

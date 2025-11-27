import 'package:flutter_tts/flutter_tts.dart';

/// Google TTS Service using flutter_tts package
/// Provides natural male and female voices with Malayalam support
class GoogleTtsService {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isInitialized = false;

  GoogleTtsService() {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      // Set default language
      await _flutterTts.setLanguage('en-US');

      // Set natural speech rate (0.5 = normal speed)
      await _flutterTts.setSpeechRate(0.5);

      // Set full volume
      await _flutterTts.setVolume(1.0);

      // Set normal pitch (1.0 = natural, no adjustment)
      await _flutterTts.setPitch(1.0);

      _isInitialized = true;
    } catch (e) {
      print('TTS initialization error: $e');
    }
  }

  /// Speak text with specified parameters
  ///
  /// [text] - Text to speak
  /// [languageCode] - Language code (e.g., 'en-US', 'ml-IN')
  /// [useMaleVoice] - If true, uses male voice; if false, uses female voice (default: true)
  Future<void> speak({
    required String text,
    String? languageCode,
    bool useMaleVoice = true,
  }) async {
    try {
      if (!_isInitialized) {
        await _initialize();
      }

      // Set language if provided
      if (languageCode != null) {
        await _flutterTts.setLanguage(languageCode);
      }

      // Try to set voice based on gender preference
      await _setVoiceByGender(languageCode ?? 'en-US', useMaleVoice);

      // Speak the text
      await _flutterTts.speak(text);
    } catch (e) {
      print('TTS speak error: $e');
      rethrow;
    }
  }

  /// Set voice based on gender preference
  Future<void> _setVoiceByGender(String languageCode, bool useMaleVoice) async {
    try {
      // Get available voices
      final voices = await _flutterTts.getVoices;
      print(
        'DEBUG: Requested gender: ${useMaleVoice ? 'Male' : 'Female'} for language: $languageCode',
      );

      if (voices != null && voices is List) {
        // Filter voices by language
        final languageVoices = voices.where((voice) {
          if (voice is Map) {
            final locale = voice['locale']?.toString() ?? '';
            // Match language code (e.g. 'en' from 'en-US')
            return locale.toLowerCase().startsWith(
              languageCode.split('-')[0].toLowerCase(),
            );
          }
          return false;
        }).toList();

        print('DEBUG: Found ${languageVoices.length} voices for $languageCode');
        for (var v in languageVoices) {
          print('DEBUG: Available voice: $v');
        }

        if (languageVoices.isNotEmpty) {
          // Try to find a voice matching the gender preference
          Map? selectedVoice;

          // First pass: Look for explicit gender keywords in name
          for (var voice in languageVoices) {
            if (voice is Map) {
              final name = voice['name']?.toString().toLowerCase() ?? '';

              // Special handling for Malayalam voices (ml-IN)
              // Patterns include:
              // - Standard: ml-IN-Standard-A/B/C/D or ml-IN-Wavenet-A/B/C/D
              // - Device-specific: ml-in-x-mlc-local, ml-in-x-mle-local, etc.
              // Gender patterns (device-specific): mle/mlm = Male, mlc/mla/mlf = Female
              if (name.contains('ml-in') || name.contains('malayalam')) {
                if (useMaleVoice) {
                  // Look for male Malayalam voices
                  // Standard patterns: -b, -d
                  // Device patterns: mle, mlm (male indicators)
                  if (name.contains('-b') ||
                      name.contains('-d') ||
                      name.contains('mle') ||
                      name.contains('mlm') ||
                      name.contains('male')) {
                    selectedVoice = voice;
                    print('DEBUG: Found Malayalam male voice: $name');
                    break;
                  }
                } else {
                  // Look for female Malayalam voices
                  // Standard patterns: -a, -c
                  // Device patterns: mla, mlc, mlf (female indicators)
                  if (name.contains('-a') ||
                      name.contains('-c') ||
                      name.contains('mla') ||
                      name.contains('mlc') ||
                      name.contains('mlf') ||
                      name.contains('female')) {
                    selectedVoice = voice;
                    print('DEBUG: Found Malayalam female voice: $name');
                    break;
                  }
                }
                // Don't continue here - if no match found, try other Malayalam voices
              }

              // Special handling for English voices with device-specific patterns
              // Device patterns: en-us-x-iob-local, en-gb-x-gba-local, etc.
              // Common pattern: last letter indicates gender (a=female, b/c/d/m=male)
              if (name.contains('en-') && name.contains('-x-')) {
                if (useMaleVoice) {
                  // Look for male English voices
                  // Device patterns ending with: b, c, d, m (male indicators)
                  if (name.endsWith('b-local') ||
                      name.endsWith('c-local') ||
                      name.endsWith('d-local') ||
                      name.endsWith('m-local') ||
                      name.contains('iob') ||
                      name.contains('gbb') ||
                      name.contains('male')) {
                    selectedVoice = voice;
                    print('DEBUG: Found English male voice: $name');
                    break;
                  }
                } else {
                  // Look for female English voices
                  // Device patterns ending with: a, e, f (female indicators)
                  if (name.endsWith('a-local') ||
                      name.endsWith('e-local') ||
                      name.endsWith('f-local') ||
                      name.contains('ioa') ||
                      name.contains('gba') ||
                      name.contains('female')) {
                    selectedVoice = voice;
                    print('DEBUG: Found English female voice: $name');
                    break;
                  }
                }
              }

              if (useMaleVoice) {
                // Look for male voice indicators: "male", "#male", or male names
                if ((name.contains('male') && !name.contains('female')) ||
                    name.contains('#male') ||
                    name.contains('man') ||
                    name.contains('boy')) {
                  selectedVoice = voice;
                  print('DEBUG: Found explicit male voice: $name');
                  break;
                }
              } else {
                // Look for female voice indicators
                if (name.contains('female') ||
                    name.contains('#female') ||
                    name.contains('woman') ||
                    name.contains('girl')) {
                  selectedVoice = voice;
                  print('DEBUG: Found explicit female voice: $name');
                  break;
                }
              }
            }
          }

          // Second pass: If no explicit gender found, use heuristics
          if (selectedVoice == null) {
            print('DEBUG: No explicit gender match found. Using heuristics...');

            // For male voice: prefer voices without "female" keyword
            // For female voice: prefer voices without "male" keyword
            for (var voice in languageVoices) {
              if (voice is Map) {
                final name = voice['name']?.toString().toLowerCase() ?? '';

                if (useMaleVoice) {
                  // Avoid voices with female indicators
                  if (!name.contains('female') &&
                      !name.contains('woman') &&
                      !name.contains('girl')) {
                    selectedVoice = voice;
                    print(
                      'DEBUG: Selected potential male voice (heuristic): $name',
                    );
                    break;
                  }
                } else {
                  // Avoid voices with male indicators
                  if (!name.contains('male') &&
                      !name.contains('man') &&
                      !name.contains('boy')) {
                    selectedVoice = voice;
                    print(
                      'DEBUG: Selected potential female voice (heuristic): $name',
                    );
                    break;
                  }
                }
              }
            }
          }

          // If still no voice found, use first available
          if (selectedVoice == null) {
            print('DEBUG: Fallback to first available voice.');
            selectedVoice = languageVoices.first as Map;
          }

          print(
            'DEBUG: Selected voice: ${selectedVoice['name']} for gender: ${useMaleVoice ? 'male' : 'female'}',
          );

          // Set the voice
          await _flutterTts.setVoice({
            'name': selectedVoice['name'],
            'locale': selectedVoice['locale'],
          });
        } else {
          print('DEBUG: No voices found for language $languageCode');
        }
      }
    } catch (e) {
      print('Voice selection error: $e');
    }
  }

  /// Stop current speech
  Future<void> stop() async {
    try {
      await _flutterTts.stop();
    } catch (e) {
      print('TTS stop error: $e');
    }
  }

  /// Set language
  Future<void> setLanguage(String languageCode) async {
    try {
      await _flutterTts.setLanguage(languageCode);
    } catch (e) {
      print('Set language error: $e');
    }
  }

  /// Set speech rate (0.0 to 1.0, where 0.5 is normal)
  Future<void> setSpeechRate(double rate) async {
    try {
      await _flutterTts.setSpeechRate(rate);
    } catch (e) {
      print('Set speech rate error: $e');
    }
  }

  /// Set volume (0.0 to 1.0)
  Future<void> setVolume(double volume) async {
    try {
      await _flutterTts.setVolume(volume);
    } catch (e) {
      print('Set volume error: $e');
    }
  }

  /// Set pitch (0.5 to 2.0, where 1.0 is normal - kept at 1.0 for natural voice)
  Future<void> setPitch(double pitch) async {
    try {
      // Always use 1.0 for natural voice (no pitch adjustment)
      await _flutterTts.setPitch(1.0);
    } catch (e) {
      print('Set pitch error: $e');
    }
  }

  /// Set start handler
  void setStartHandler(Function() handler) {
    _flutterTts.setStartHandler(handler);
  }

  /// Set completion handler
  void setCompletionHandler(Function() handler) {
    _flutterTts.setCompletionHandler(handler);
  }

  /// Set error handler
  void setErrorHandler(Function(String) handler) {
    _flutterTts.setErrorHandler((msg) => handler(msg));
  }

  /// Dispose resources
  Future<void> dispose() async {
    try {
      await _flutterTts.stop();
    } catch (e) {
      print('Dispose error: $e');
    }
  }

  /// Get available voices
  Future<List<dynamic>> getVoices() async {
    try {
      final voices = await _flutterTts.getVoices;
      return voices ?? [];
    } catch (e) {
      print('Get voices error: $e');
      return [];
    }
  }

  /// Get available languages
  Future<List<dynamic>> getLanguages() async {
    try {
      final languages = await _flutterTts.getLanguages;
      return languages ?? [];
    } catch (e) {
      print('Get languages error: $e');
      return [];
    }
  }
}

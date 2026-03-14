import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Google TTS Service using flutter_tts package
/// Provides natural male and female voices with Malayalam support
class GoogleTtsService {
  static final GoogleTtsService _instance = GoogleTtsService._internal();
  static GoogleTtsService get instance => _instance;

  final FlutterTts _flutterTts = FlutterTts();
  bool _isInitialized = false;

  factory GoogleTtsService() {
    return _instance;
  }

  GoogleTtsService._internal() {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      await _flutterTts.setLanguage('en-US');
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);
      _isInitialized = true;
    } catch (e) {
      debugPrint('TTS initialization error: $e');
    }
  }

  /// Speak text with specified parameters
  ///
  /// [text] - Text to speak
  /// [languageCode] - Language code (e.g., 'en-US', 'ml-IN')
  /// [useMaleVoice] - If true, uses male voice; if false, uses female voice (default: true)
  /// [speechRate] - Optional speech rate override (0.0 to 1.0, where 0.5 is normal)
  /// [volume] - Optional volume override (0.0 to 1.0)
  Future<void> speak({
    required String text,
    String? languageCode,
    bool useMaleVoice = true,
    double? speechRate,
    double? volume,
  }) async {
    try {
      if (!_isInitialized) {
        await _initialize();
      }

      // Map en-IN (Manglish) to ml-IN (Malayalam) for voice selection
      String targetLanguage = languageCode ?? 'en-US';
      if (targetLanguage == 'en-IN') {
        targetLanguage = 'ml-IN';
      }

      await _flutterTts.setLanguage(targetLanguage);

      // Apply speech rate and volume if provided
      if (speechRate != null) {
        await _flutterTts.setSpeechRate(speechRate.clamp(0.0, 1.0));
      }
      if (volume != null) {
        await _flutterTts.setVolume(volume.clamp(0.0, 1.0));
      }

      await _setVoiceByGender(targetLanguage, useMaleVoice);
      await _flutterTts.speak(text);
    } catch (e) {
      debugPrint('TTS speak error: $e');
      rethrow;
    }
  }

  /// Set voice based on gender preference
  Future<void> _setVoiceByGender(String languageCode, bool useMaleVoice) async {
    try {
      final voices = await _flutterTts.getVoices;

      if (voices != null && voices is List) {
        // Filter voices by language
        final languageVoices = voices.where((voice) {
          if (voice is Map) {
            final locale = voice['locale']?.toString() ?? '';
            if (languageCode.contains('-')) {
              if (locale.toLowerCase() == languageCode.toLowerCase()) {
                return true;
              }
            }
            return locale.toLowerCase().startsWith(
              languageCode.split('-')[0].toLowerCase(),
            );
          }
          return false;
        }).toList();

        if (languageVoices.isNotEmpty) {
          Map? selectedVoice;

          // First pass: Look for explicit gender keywords in name or features
          for (var voice in languageVoices) {
            if (voice is Map) {
              final name = voice['name']?.toString().toLowerCase() ?? '';
              final features =
                  voice['features']?.toString().toLowerCase() ?? '';

              // Check features field first for explicit gender
              if (useMaleVoice) {
                if (features.contains('gender=male')) {
                  selectedVoice = voice;
                  break;
                }
              } else {
                if (features.contains('gender=female')) {
                  selectedVoice = voice;
                  break;
                }
              }

              // Special handling for Malayalam voices (ml-IN)
              if (name.contains('ml-in') || name.contains('malayalam')) {
                if (useMaleVoice) {
                  if (name.contains('standard-b')) {
                    selectedVoice = voice;
                    break;
                  }
                  if (name.contains('-b') ||
                      name.contains('-d') ||
                      name.contains('mle') ||
                      name.contains('mlm') ||
                      name.contains('male')) {
                    selectedVoice = voice;
                    break;
                  }
                } else {
                  if (name.contains('standard-a')) {
                    selectedVoice = voice;
                    break;
                  }
                  if (name.contains('-a') ||
                      name.contains('-c') ||
                      name.contains('mla') ||
                      name.contains('mlc') ||
                      name.contains('mlf') ||
                      name.contains('female')) {
                    selectedVoice = voice;
                    break;
                  }
                }
              }

              // Special handling for English voices with device-specific patterns
              if (name.contains('en-') && name.contains('-x-')) {
                if (useMaleVoice) {
                  if (name.endsWith('b-local') ||
                      name.endsWith('c-local') ||
                      name.endsWith('d-local') ||
                      name.endsWith('m-local') ||
                      name.contains('iob') ||
                      name.contains('gbb') ||
                      name.contains('male')) {
                    selectedVoice = voice;
                    break;
                  }
                } else {
                  if (name.endsWith('a-local') ||
                      name.endsWith('e-local') ||
                      name.endsWith('f-local') ||
                      name.contains('ioa') ||
                      name.contains('gba') ||
                      name.contains('female')) {
                    selectedVoice = voice;
                    break;
                  }
                }
              }

              // Samsung TTS patterns
              if (useMaleVoice) {
                if (name.contains('smtg') || name.contains('smtm')) {
                  selectedVoice = voice;
                  break;
                }
              } else {
                if (name.contains('smtf')) {
                  selectedVoice = voice;
                  break;
                }
              }

              if (useMaleVoice) {
                if ((name.contains('male') && !name.contains('female')) ||
                    name.contains('#male') ||
                    name.contains('man') ||
                    name.contains('boy')) {
                  selectedVoice = voice;
                  break;
                }
              } else {
                if (name.contains('female') ||
                    name.contains('#female') ||
                    name.contains('woman') ||
                    name.contains('girl')) {
                  selectedVoice = voice;
                  break;
                }
              }
            }
          }

          // Second pass: If no explicit gender found, use heuristics
          if (selectedVoice == null) {
            for (var voice in languageVoices) {
              if (voice is Map) {
                final name = voice['name']?.toString().toLowerCase() ?? '';
                final features =
                    voice['features']?.toString().toLowerCase() ?? '';

                if (useMaleVoice) {
                  if (!name.contains('female') &&
                      !name.contains('smtf') &&
                      !name.contains('woman') &&
                      !name.contains('girl') &&
                      !features.contains('gender=female')) {
                    selectedVoice = voice;
                    break;
                  }
                } else {
                  if (!name.contains('male') &&
                      !name.contains('smtg') &&
                      !name.contains('smtm') &&
                      !name.contains('man') &&
                      !name.contains('boy') &&
                      !features.contains('gender=male')) {
                    selectedVoice = voice;
                    break;
                  }
                }
              }
            }
          }

          // Fallback to first available voice
          selectedVoice ??= languageVoices.first as Map;

          await _flutterTts.setVoice({
            'name': selectedVoice['name'],
            'locale': selectedVoice['locale'],
          });
        }
      }
    } catch (e) {
      debugPrint('Voice selection error: $e');
    }
  }

  /// Stop current speech
  Future<void> stop() async {
    try {
      await _flutterTts.stop();
    } catch (e) {
      debugPrint('TTS stop error: $e');
    }
  }

  /// Set language
  Future<void> setLanguage(String languageCode) async {
    try {
      await _flutterTts.setLanguage(languageCode);
    } catch (e) {
      debugPrint('Set language error: $e');
    }
  }

  /// Set speech rate (0.0 to 1.0, where 0.5 is normal)
  Future<void> setSpeechRate(double rate) async {
    try {
      await _flutterTts.setSpeechRate(rate);
    } catch (e) {
      debugPrint('Set speech rate error: $e');
    }
  }

  /// Set volume (0.0 to 1.0)
  Future<void> setVolume(double volume) async {
    try {
      await _flutterTts.setVolume(volume);
    } catch (e) {
      debugPrint('Set volume error: $e');
    }
  }

  /// Set pitch (0.5 to 2.0, where 1.0 is normal)
  Future<void> setPitch(double pitch) async {
    try {
      await _flutterTts.setPitch(pitch.clamp(0.5, 2.0));
    } catch (e) {
      debugPrint('Set pitch error: $e');
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
      debugPrint('Dispose error: $e');
    }
  }

  /// Get available voices
  Future<List<dynamic>> getVoices() async {
    try {
      final voices = await _flutterTts.getVoices;
      return voices ?? [];
    } catch (e) {
      debugPrint('Get voices error: $e');
      return [];
    }
  }

  /// Get available languages
  Future<List<dynamic>> getLanguages() async {
    try {
      final languages = await _flutterTts.getLanguages;
      return languages ?? [];
    } catch (e) {
      debugPrint('Get languages error: $e');
      return [];
    }
  }

  /// Get current default engine
  Future<String?> getDefaultEngine() async {
    try {
      return await _flutterTts.getDefaultEngine;
    } catch (e) {
      debugPrint('Get default engine error: $e');
      return null;
    }
  }

  /// Check if using Google TTS engine
  Future<bool> isUsingGoogleTts() async {
    try {
      final engine = await getDefaultEngine();
      if (engine == null) return false;
      return engine.toLowerCase().contains('google');
    } catch (e) {
      debugPrint('Check engine error: $e');
      return false;
    }
  }

  /// Get available engines
  Future<List<dynamic>> getEngines() async {
    try {
      return await _flutterTts.getEngines;
    } catch (e) {
      debugPrint('Get engines error: $e');
      return [];
    }
  }
}

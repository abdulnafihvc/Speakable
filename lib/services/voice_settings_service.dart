import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speakable/services/google_tts_service.dart';

/// Service to manage voice settings and preferences
class VoiceSettingsService extends GetxController {
  static const String _keyVoiceGender = 'voice_gender';
  static const String _keyLanguage = 'voice_language';
  static const String _keySpeechRate = 'speech_rate';
  static const String _keyPitch = 'pitch';
  static const String _keyVolume = 'volume';
  static const String _keyFirstTimeSetup = 'first_time_setup_complete';

  // Observable voice settings
  final voiceGender = 'female'.obs; // 'male' or 'female'
  final voiceLanguage = 'en-US'.obs; // 'en-US', 'ml-IN', or 'en-IN' (Manglish)
  final speechRate = 1.0.obs; // 0.25 to 4.0 (Google TTS range)
  final pitch = 0.0.obs; // -20.0 to 20.0 (Google TTS range)
  final volume = 0.5.obs; // 0.0 to 1.0
  final isGoogleEngineInstalled = true.obs; // Default to true, updated on init
  final isLoading = false.obs; // Track loading state - disabled for now

  @override
  void onInit() {
    super.onInit();
    // Load settings asynchronously without blocking
    _loadSettings();
    // checkEngine(); // Disabled to prevent crash on some devices
  }

  /// Check if Google TTS engine is active
  Future<void> checkEngine() async {
    // Disabled to prevent ANR/Crash on some devices
    isGoogleEngineInstalled.value = true; // Assume true to enable all options
    /*
    try {
      final tts = GoogleTtsService.instance;
      // Add timeout to prevent hanging
      final isGoogle = await tts.isUsingGoogleTts().timeout(
        const Duration(seconds: 2),
        onTimeout: () {
          return true; // Assume true on timeout
        },
      );
      isGoogleEngineInstalled.value = isGoogle;

      // If not Google engine, reset language to English if it was set to Malayalam/Manglish
      if (!isGoogle) {
        if (voiceLanguage.value == 'ml-IN' || voiceLanguage.value == 'en-IN') {
          setVoiceLanguage('en-US');
        }
        // Reset gender to female if male was selected (as male might not be available/good in other engines)
        if (voiceGender.value == 'male') {
          setVoiceGender('female');
        }
      }
    } catch (e) {
      isGoogleEngineInstalled.value = true; // Default to true on error
    }
    */
  }

  /// Load settings from SharedPreferences
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      voiceGender.value = prefs.getString(_keyVoiceGender) ?? 'female';
      if (voiceGender.value != 'male' && voiceGender.value != 'female') {
        voiceGender.value = 'female';
      }

      voiceLanguage.value = prefs.getString(_keyLanguage) ?? 'en-US';
      if (voiceLanguage.value != 'en-US' &&
          voiceLanguage.value != 'ml-IN' &&
          voiceLanguage.value != 'en-IN') {
        voiceLanguage.value = 'en-US';
      }

      speechRate.value = prefs.getDouble(_keySpeechRate) ?? 1.0;
      pitch.value = prefs.getDouble(_keyPitch) ?? 0.0;
      volume.value = prefs.getDouble(_keyVolume) ?? 0.5;
    } catch (e) {
      // Use defaults if loading fails - silently handle errors
    }
  }

  /// Set voice gender (male/female)
  Future<void> setVoiceGender(String gender) async {
    if (gender != 'male' && gender != 'female') return;

    voiceGender.value = gender;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyVoiceGender, gender);
  }

  /// Set voice language (en-US/ml-IN)
  Future<void> setVoiceLanguage(String language) async {
    if (language != 'en-US' && language != 'ml-IN' && language != 'en-IN')
      return;

    voiceLanguage.value = language;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLanguage, language);
  }

  /// Get language name for display
  String getLanguageName() {
    if (voiceLanguage.value == 'ml-IN') return 'Malayalam';
    if (voiceLanguage.value == 'en-IN') return 'Manglish';
    return 'English';
  }

  /// Set speech rate (0.25 to 4.0)
  Future<void> setSpeechRate(double rate) async {
    if (rate < 0.25 || rate > 4.0) return;

    speechRate.value = rate;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keySpeechRate, rate);
  }

  /// Set pitch (-20.0 to 20.0)
  Future<void> setPitch(double newPitch) async {
    if (newPitch < -20.0 || newPitch > 20.0) return;

    pitch.value = newPitch;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyPitch, newPitch);
  }

  /// Set volume (0.0 to 1.0)
  Future<void> setVolume(double newVolume) async {
    if (newVolume < 0.0 || newVolume > 1.0) return;

    volume.value = newVolume;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyVolume, newVolume);
  }

  /// Reset to default settings
  Future<void> resetToDefaults() async {
    voiceGender.value = 'female';
    voiceLanguage.value = 'en-US';
    speechRate.value = 1.0;
    pitch.value = 0.0;
    volume.value = 0.5;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyVoiceGender, 'female');
    await prefs.setString(_keyLanguage, 'en-US');
    await prefs.setDouble(_keySpeechRate, 1.0);
    await prefs.setDouble(_keyPitch, 0.0);
    await prefs.setDouble(_keyVolume, 0.5);
  }

  /// Check if first-time setup is complete
  Future<bool> isFirstTimeSetupComplete() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_keyFirstTimeSetup) ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Mark first-time setup as complete
  Future<void> markFirstTimeSetupComplete() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyFirstTimeSetup, true);
    } catch (e) {
      // Silently handle error
    }
  }

  /// Check if a specific voice is available
  Future<bool> isVoiceAvailable({
    required String gender,
    required String languageCode,
  }) async {
    try {
      final tts = GoogleTtsService.instance;
      final voices = await tts.getVoices();

      if (voices.isEmpty) {
        // If we can't get voices, return false to be safe
        print('DEBUG: No voices available on device');
        return false;
      }

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

      if (languageVoices.isEmpty) {
        print('DEBUG: No voices found for language $languageCode');
        return false;
      }

      print(
        'DEBUG: Checking for $gender voice in ${languageVoices.length} available voices',
      );

      // Check if a voice matching the gender exists
      bool foundMatch = false;
      for (var voice in languageVoices) {
        if (voice is Map) {
          final name = voice['name']?.toString().toLowerCase() ?? '';
          final features = voice['features']?.toString().toLowerCase() ?? '';
          print('DEBUG: Checking voice: $name (features: $features)');

          if (gender == 'male') {
            // Check for male voice patterns - be more strict
            // First check the features field for explicit gender
            if (features.contains('gender=male')) {
              print('DEBUG: Found male voice (from features): $name');
              foundMatch = true;
              break;
            }

            // Explicitly check it's NOT a female voice first
            if (name.contains('female') ||
                name.contains('smtf') ||
                features.contains('gender=female')) {
              continue; // Skip female voices
            }

            // Look for explicit male indicators in name
            if (name.contains('male') ||
                name.contains('smtm') ||
                name.contains(
                  'smtg',
                ) || // Samsung TTS male voices (g02, g03, etc)
                name.contains('standard-b') ||
                name.contains('iob') ||
                name.contains('gbb')) {
              print('DEBUG: Found male voice: $name');
              foundMatch = true;
              break;
            }
          } else {
            // Check for female voice patterns
            // First check the features field for explicit gender
            if (features.contains('gender=female')) {
              print('DEBUG: Found female voice (from features): $name');
              foundMatch = true;
              break;
            }

            if (name.contains('female') ||
                name.contains('smtf') ||
                name.contains('standard-a') ||
                name.contains('ioa') ||
                name.contains('gba')) {
              print('DEBUG: Found female voice: $name');
              foundMatch = true;
              break;
            }
          }
        }
      }

      if (!foundMatch) {
        print('DEBUG: No $gender voice found for $languageCode');
      }

      return foundMatch;
    } catch (e) {
      print('DEBUG: Error checking voice availability: $e');
      // On error, return false to be safe and show the download dialog
      return false;
    }
  }
}

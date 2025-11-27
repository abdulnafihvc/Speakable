import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service to manage voice settings and preferences
class VoiceSettingsService extends GetxController {
  static const String _keyVoiceGender = 'voice_gender';
  static const String _keyLanguage = 'voice_language';
  static const String _keySpeechRate = 'speech_rate';
  static const String _keyPitch = 'pitch';
  static const String _keyVolume = 'volume';

  // Observable voice settings
  final voiceGender = 'female'.obs; // 'male' or 'female'
  final voiceLanguage = 'en-US'.obs; // 'en-US' or 'ml-IN'
  final speechRate = 1.0.obs; // 0.25 to 4.0 (Google TTS range)
  final pitch = 0.0.obs; // -20.0 to 20.0 (Google TTS range)
  final volume = 0.5.obs; // 0.0 to 1.0

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  /// Load settings from SharedPreferences
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      voiceGender.value = prefs.getString(_keyVoiceGender) ?? 'female';
      voiceLanguage.value = prefs.getString(_keyLanguage) ?? 'en-US';
      speechRate.value = prefs.getDouble(_keySpeechRate) ?? 1.0;
      pitch.value = prefs.getDouble(_keyPitch) ?? 0.0;
      volume.value = prefs.getDouble(_keyVolume) ?? 0.5;
    } catch (e) {
      // Use defaults if loading fails
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
    if (language != 'en-US' && language != 'ml-IN') return;

    voiceLanguage.value = language;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLanguage, language);
  }

  /// Get language name for display
  String getLanguageName() {
    return voiceLanguage.value == 'ml-IN' ? 'Malayalam' : 'English';
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
}

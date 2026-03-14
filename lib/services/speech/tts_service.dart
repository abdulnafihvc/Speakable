import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';

/// Text-to-Speech service abstraction layer
class TtsService extends GetxService {
  final FlutterTts _tts = FlutterTts();

  // Observable states
  final RxBool isSpeaking = false.obs;
  final RxDouble volume = 1.0.obs;
  final RxDouble pitch = 1.0.obs;
  final RxDouble speechRate = 0.5.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initializeTts();
  }

  /// Initialize TTS with default settings
  Future<void> _initializeTts() async {
    // Set up handlers
    _tts.setStartHandler(() {
      isSpeaking.value = true;
    });

    _tts.setCompletionHandler(() {
      isSpeaking.value = false;
    });

    _tts.setErrorHandler((msg) {
      isSpeaking.value = false;
      Get.snackbar('TTS Error', msg);
    });

    // Set default values
    await setVolume(volume.value);
    await setPitch(pitch.value);
    await setSpeechRate(speechRate.value);
  }

  /// Speak text
  Future<void> speak(String text) async {
    if (text.isEmpty) return;

    try {
      await _tts.speak(text);
    } catch (e) {
      Get.snackbar('Error', 'Failed to speak: ${e.toString()}');
    }
  }

  /// Stop speaking
  Future<void> stop() async {
    await _tts.stop();
    isSpeaking.value = false;
  }

  /// Pause speaking
  Future<void> pause() async {
    await _tts.pause();
  }

  /// Set volume (0.0 to 1.0)
  Future<void> setVolume(double value) async {
    volume.value = value.clamp(0.0, 1.0);
    await _tts.setVolume(volume.value);
  }

  /// Set pitch (0.5 to 2.0)
  Future<void> setPitch(double value) async {
    pitch.value = value.clamp(0.5, 2.0);
    await _tts.setPitch(pitch.value);
  }

  /// Set speech rate (0.0 to 1.0)
  Future<void> setSpeechRate(double value) async {
    speechRate.value = value.clamp(0.0, 1.0);
    await _tts.setSpeechRate(speechRate.value);
  }

  /// Set language
  Future<void> setLanguage(String language) async {
    await _tts.setLanguage(language);
  }

  /// Get available languages
  Future<List<dynamic>> getLanguages() async {
    return await _tts.getLanguages;
  }

  /// Get available voices
  Future<List<dynamic>> getVoices() async {
    return await _tts.getVoices;
  }

  /// Set voice
  Future<void> setVoice(Map<String, String> voice) async {
    await _tts.setVoice(voice);
  }

  @override
  void onClose() {
    _tts.stop();
    super.onClose();
  }
}

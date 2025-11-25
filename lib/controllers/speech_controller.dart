import 'package:flutter/material.dart';
import 'package:speakable/services/google_tts_service.dart';
import 'package:get/get.dart';
import 'package:speakable/services/message_storage_service.dart';
import 'package:speakable/services/manglish_service.dart';

class SpeechController extends GetxController {
  final TextEditingController textController = TextEditingController();
  final MessageStorageService _storageService = MessageStorageService();
  late GoogleTtsService flutterTts;

  var isSpeaking = false.obs;
  var currentLanguage = 'en-US'.obs;
  var speechRate = 0.5.obs;
  var pitch = 1.0.obs;
  var volume = 1.0.obs;

  // Language options
  final Map<String, String> languages = {
    'en-US': 'English',
    'ml-IN': 'Malayalam',
    'manglish': 'Manglish',
  };

  var isManglishMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initTts();
  }

  void _initTts() {
    flutterTts = GoogleTtsService();

    flutterTts.setStartHandler(() {
      isSpeaking.value = true;
    });

    flutterTts.setCompletionHandler(() {
      isSpeaking.value = false;
    });

    flutterTts.setErrorHandler((msg) {
      isSpeaking.value = false;
      Get.snackbar(
        'Error',
        'Failed to speak: $msg',
        snackPosition: SnackPosition.BOTTOM,
      );
    });
  }

  Future<void> toggleSpeaking() async {
    if (textController.text.isEmpty) {
      Get.snackbar(
        'Empty Text',
        'Please enter some text to speak',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (isSpeaking.value) {
      await flutterTts.stop();
      isSpeaking.value = false;
    } else {
      String textToSpeak = textController.text;
      String languageCode = currentLanguage.value;

      // Transliterate Manglish if in Manglish mode
      if (currentLanguage.value == 'manglish') {
        textToSpeak = ManglishService.transliterateToMalayalam(textToSpeak);
        languageCode = 'ml-IN';
      }

      await flutterTts.speak(text: textToSpeak, languageCode: languageCode);
    }
  }

  void copyText() {
    if (textController.text.isNotEmpty) {
      Get.snackbar(
        'Copied',
        'Text copied to clipboard',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void clearText() {
    textController.clear();
  }

  Future<void> saveText() async {
    if (textController.text.isNotEmpty) {
      await _storageService.saveMessage(textController.text);
      Get.snackbar(
        'Saved',
        'Text saved successfully',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        backgroundColor: Get.theme.colorScheme.primary.withOpacity(0.1),
      );
    } else {
      Get.snackbar(
        'Empty Text',
        'Please enter some text first',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> setLanguage(String language) async {
    currentLanguage.value = language;
    isManglishMode.value = (language == 'manglish');
  }

  String transliterateManglish(String text) {
    return ManglishService.transliterateToMalayalam(text);
  }

  Future<void> setSpeechRate(double rate) async {
    if (rate < 0.25 || rate > 4.0) return;
    speechRate.value = rate;
    // Voice settings are managed by VoiceSettingsService
  }

  Future<void> setPitch(double newPitch) async {
    if (newPitch < -20.0 || newPitch > 20.0) return;
    pitch.value = newPitch;
    // Voice settings are managed by VoiceSettingsService
  }

  Future<void> setVolume(double newVolume) async {
    if (newVolume < 0.0 || newVolume > 1.0) return;
    volume.value = newVolume;
    // Voice settings are managed by VoiceSettingsService
  }

  @override
  void onClose() {
    flutterTts.dispose();
    textController.dispose();
    super.onClose();
  }
}

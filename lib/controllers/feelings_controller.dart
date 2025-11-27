import 'package:flutter/material.dart';
import 'package:speakable/services/google_tts_service.dart';
import 'package:get/get.dart';
import 'package:speakable/services/voice_settings_service.dart';
import 'package:speakable/models/emotion.dart';
import 'package:speakable/services/emotion_storage_service.dart';

class FeelingsController extends GetxController {
  final EmotionStorageService _storageService = EmotionStorageService();
  late GoogleTtsService flutterTts;

  var emotions = <Emotion>[].obs;
  var isLoading = true.obs;

  final VoiceSettingsService _voiceSettings = Get.find<VoiceSettingsService>();

  @override
  void onInit() {
    super.onInit();
    _initTts();
    loadEmotions();
  }

  void _initTts() {
    flutterTts = GoogleTtsService();
  }

  Future<void> loadEmotions() async {
    isLoading.value = true;
    final loadedEmotions = await _storageService.getAllEmotions();
    emotions.value = loadedEmotions;
    isLoading.value = false;
  }

  Future<void> speakEmotion(Emotion emotion) async {
    await flutterTts.stop();
    await flutterTts.speak(
      text: emotion.text,
      languageCode: 'en-US',
      useMaleVoice: _voiceSettings.voiceGender.value == 'male',
    );
  }

  Future<void> addCustomEmotion(String text, IconData icon, Color color) async {
    final newEmotion = Emotion(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      icon: icon,
      color: color,
      isCustom: true,
    );
    await _storageService.saveCustomEmotion(newEmotion);
    await loadEmotions();
  }

  Future<void> deleteCustomEmotion(String id) async {
    await _storageService.deleteCustomEmotion(id);
    await loadEmotions();
  }

  @override
  void onClose() {
    flutterTts.dispose();
    super.onClose();
  }
}

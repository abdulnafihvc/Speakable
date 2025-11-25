import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/emotion.dart';

class EmotionStorageService {
  static const String _key = 'custom_emotions';

  Future<List<Emotion>> getCustomEmotions() async {
    final prefs = await SharedPreferences.getInstance();
    final String? emotionsJson = prefs.getString(_key);
    
    if (emotionsJson == null) {
      return [];
    }

    final List<dynamic> emotionsList = jsonDecode(emotionsJson);
    return emotionsList.map((json) => Emotion.fromJson(json)).toList();
  }

  Future<void> saveCustomEmotion(Emotion emotion) async {
    final prefs = await SharedPreferences.getInstance();
    final emotions = await getCustomEmotions();
    
    emotions.add(emotion);
    
    final emotionsJson = jsonEncode(
      emotions.map((e) => e.toJson()).toList(),
    );
    
    await prefs.setString(_key, emotionsJson);
  }

  Future<void> deleteCustomEmotion(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final emotions = await getCustomEmotions();
    
    emotions.removeWhere((emotion) => emotion.id == id);
    
    final emotionsJson = jsonEncode(
      emotions.map((e) => e.toJson()).toList(),
    );
    
    await prefs.setString(_key, emotionsJson);
  }

  Future<List<Emotion>> getAllEmotions() async {
    final defaultEmotions = Emotion.getDefaultEmotions();
    final customEmotions = await getCustomEmotions();
    return [...defaultEmotions, ...customEmotions];
  }
}

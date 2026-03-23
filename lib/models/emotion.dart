import 'package:flutter/material.dart';

class Emotion {
  final String id;
  final String text;
  final String emoji;
  final Color color;
  final bool isCustom;
  final String? imagePath;

  Emotion({
    required this.id,
    required this.text,
    required this.emoji,
    required this.color,
    this.isCustom = false,
    this.imagePath,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'emoji': emoji,
      'color': color.value,
      'isCustom': isCustom,
      'imagePath': imagePath,
    };
  }

  factory Emotion.fromJson(Map<String, dynamic> json) {
    return Emotion(
      id: json['id'],
      text: json['text'],
      emoji: json['emoji'] ?? '💭',
      color: Color(json['color']),
      isCustom: json['isCustom'] ?? false,
      imagePath: json['imagePath'],
    );
  }

  // Default emotions
  static List<Emotion> getDefaultEmotions() {
    return [
      Emotion(
        id: 'happy',
        text: 'I am happy',
        emoji: '😀',
        color: Colors.white,
        imagePath: 'assets/feelings-emojis/I_am_happy.png',
      ),
      Emotion(
        id: 'sad',
        text: 'I am sad',
        emoji: '😢',
        color: Colors.white,
        imagePath: 'assets/feelings-emojis/I_am_sad.png',
      ),
      Emotion(
        id: 'angry',
        text: 'I am angry',
        emoji: '😠',
        color: Colors.white,
        imagePath: 'assets/feelings-emojis/I_am_angry.png',
      ),
      Emotion(
        id: 'hungry',
        text: 'I am hungry',
        emoji: '😋',
        color: Colors.white,
        imagePath: 'assets/feelings-emojis/I_am_hungry.png',
      ),
      Emotion(
        id: 'thirsty',
        text: 'I am thirsty',
        emoji: '🥤',
        color: Colors.white,
        imagePath: 'assets/feelings-emojis/I_am_Thirsty.png',
      ),
      Emotion(
        id: 'tired',
        text: 'I am tired',
        emoji: '😴',
        color: Colors.white,
        imagePath: 'assets/feelings-emojis/I_am_tired.png',
      ),
      Emotion(
        id: 'help',
        text: 'I need help',
        emoji: '🆘',
        color: Colors.white,
      ),
      Emotion(
        id: 'bathroom',
        text: 'I need to go to bathroom',
        emoji: '🚽',
        color: Colors.white,
      ),
      Emotion(
        id: 'play',
        text: 'I want to play',
        emoji: '🎮',
        color: Colors.white,
      ),
      Emotion(
        id: 'love',
        text: 'I love you',
        emoji: '❤️',
        color: Colors.white,
        imagePath: 'assets/feelings-emojis/I_Love_you.png',
      ),
      Emotion(
        id: 'thankyou',
        text: 'Thank you',
        emoji: '🙏',
        color: Colors.white,
      ),
      Emotion(
        id: 'sorry',
        text: 'I am really sorry',
        emoji: '😔',
        color: Colors.white,
      ),
    ];
  }
}

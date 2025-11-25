import 'package:flutter/material.dart';

class Emotion {
  final String id;
  final String text;
  final IconData icon;
  final Color color;
  final bool isCustom;
  final String? imagePath;

  Emotion({
    required this.id,
    required this.text,
    required this.icon,
    required this.color,
    this.isCustom = false,
    this.imagePath,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'icon': icon.codePoint,
      'color': color.value,
      'isCustom': isCustom,
      'imagePath': imagePath,
    };
  }

  factory Emotion.fromJson(Map<String, dynamic> json) {
    return Emotion(
      id: json['id'],
      text: json['text'],
      icon: IconData(json['icon'], fontFamily: 'MaterialIcons'),
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
        icon: Icons.sentiment_very_satisfied,
        color: Colors.white,
        imagePath: 'assets/feelings-emojis/I_am_happy.png',
      ),
      Emotion(
        id: 'sad',
        text: 'I am sad',
        icon: Icons.sentiment_dissatisfied,
        color: Colors.white,
        imagePath: 'assets/feelings-emojis/I_am_sad.png',
      ),
      Emotion(
        id: 'angry',
        text: 'I am angry',
        icon: Icons.sentiment_very_dissatisfied,
        color: Colors.white,
        imagePath: 'assets/feelings-emojis/I_am_angry.png',
      ),
      Emotion(
        id: 'hungry',
        text: 'I am hungry',
        icon: Icons.restaurant,
        color: Colors.white,
        imagePath: 'assets/feelings-emojis/I_am_hungry.png',
      ),
      Emotion(
        id: 'thirsty',
        text: 'I am thirsty',
        icon: Icons.local_drink,
        color: Colors.white,
        imagePath: 'assets/feelings-emojis/I_am_Thirsty.png',
      ),
      Emotion(
        id: 'tired',
        text: 'I am tired',
        icon: Icons.bedtime,
        color: Colors.white,
        imagePath: 'assets/feelings-emojis/I_am_tired.png',
      ),
      Emotion(
        id: 'help',
        text: 'I need help',
        icon: Icons.help,
        color: Colors.white,
      ),
      Emotion(
        id: 'bathroom',
        text: 'I need to go to bathroom',
        icon: Icons.bathtub,
        color: Colors.white,
      ),
      Emotion(
        id: 'play',
        text: 'I want to play',
        icon: Icons.sports_esports,
        color: Colors.white,
      ),
      Emotion(
        id: 'love',
        text: 'I love you',
        icon: Icons.favorite,
        color: Colors.white,
        imagePath: 'assets/feelings-emojis/I_Love_you.png',
      ),
      Emotion(
        id: 'thankyou',
        text: 'Thank you',
        icon: Icons.thumb_up,
        color: Colors.white,
      ),
      Emotion(
        id: 'sorry',
        text: 'I am really sorry',
        icon: Icons.sentiment_neutral,
        color: Colors.white,
      ),
    ];
  }
}

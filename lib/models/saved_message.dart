class SavedMessage {
  final String id;
  final String text;
  final DateTime timestamp;
  final String languageCode;

  SavedMessage({
    required this.id,
    required this.text,
    required this.timestamp,
    this.languageCode = 'en-US',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
      'languageCode': languageCode,
    };
  }

  factory SavedMessage.fromJson(Map<String, dynamic> json) {
    return SavedMessage(
      id: json['id'],
      text: json['text'],
      timestamp: DateTime.parse(json['timestamp']),
      languageCode: json['languageCode'] ?? 'en-US',
    );
  }
}

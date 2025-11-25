class SavedMessage {
  final String id;
  final String text;
  final DateTime timestamp;

  SavedMessage({
    required this.id,
    required this.text,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory SavedMessage.fromJson(Map<String, dynamic> json) {
    return SavedMessage(
      id: json['id'],
      text: json['text'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

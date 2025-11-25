class SpeechImageModel {
  final String id;
  final String name;
  final String imagePath;
  final String category;
  final DateTime createdAt;

  SpeechImageModel({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.category,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imagePath': imagePath,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory SpeechImageModel.fromJson(Map<String, dynamic> json) {
    return SpeechImageModel(
      id: json['id'] as String,
      name: json['name'] as String,
      imagePath: json['imagePath'] as String,
      category: json['category'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

import 'package:hive/hive.dart';

part 'user_document.g.dart';

@HiveType(typeId: 0)
class UserDocument extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String fileName;

  @HiveField(2)
  String filePath;

  @HiveField(3)
  String fileType;

  @HiveField(4)
  int fileSize;

  @HiveField(5)
  DateTime uploadDate;

  @HiveField(6)
  String? description;

  UserDocument({
    required this.id,
    required this.fileName,
    required this.filePath,
    required this.fileType,
    required this.fileSize,
    required this.uploadDate,
    this.description,
  });

  String get fileSizeFormatted {
    if (fileSize < 1024) {
      return '$fileSize B';
    } else if (fileSize < 1024 * 1024) {
      return '${(fileSize / 1024).toStringAsFixed(2)} KB';
    } else {
      return '${(fileSize / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
  }

  String get fileExtension {
    return fileName.split('.').last.toUpperCase();
  }
}

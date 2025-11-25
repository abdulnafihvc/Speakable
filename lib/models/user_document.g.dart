// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_document.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserDocumentAdapter extends TypeAdapter<UserDocument> {
  @override
  final int typeId = 0;

  @override
  UserDocument read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserDocument(
      id: fields[0] as String,
      fileName: fields[1] as String,
      filePath: fields[2] as String,
      fileType: fields[3] as String,
      fileSize: fields[4] as int,
      uploadDate: fields[5] as DateTime,
      description: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserDocument obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fileName)
      ..writeByte(2)
      ..write(obj.filePath)
      ..writeByte(3)
      ..write(obj.fileType)
      ..writeByte(4)
      ..write(obj.fileSize)
      ..writeByte(5)
      ..write(obj.uploadDate)
      ..writeByte(6)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserDocumentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:speakable/models/speech_image_model.dart';

class SpeechImageService {
  static const String _storageKey = 'speech_images';

  Future<List<SpeechImageModel>> getImagesByCategory(String category) async {
    final prefs = await SharedPreferences.getInstance();
    final String? imagesJson = prefs.getString(_storageKey);
    
    if (imagesJson == null) return [];
    
    final List<dynamic> imagesList = json.decode(imagesJson);
    final allImages = imagesList
        .map((item) => SpeechImageModel.fromJson(item))
        .toList();
    
    return allImages.where((image) => image.category == category).toList();
  }

  Future<void> addImage(SpeechImageModel image) async {
    final prefs = await SharedPreferences.getInstance();
    final String? imagesJson = prefs.getString(_storageKey);
    
    List<SpeechImageModel> images = [];
    if (imagesJson != null) {
      final List<dynamic> imagesList = json.decode(imagesJson);
      images = imagesList
          .map((item) => SpeechImageModel.fromJson(item))
          .toList();
    }
    
    images.add(image);
    
    final String updatedJson =
        json.encode(images.map((image) => image.toJson()).toList());
    await prefs.setString(_storageKey, updatedJson);
  }

  Future<void> updateImage(SpeechImageModel updatedImage) async {
    final prefs = await SharedPreferences.getInstance();
    final String? imagesJson = prefs.getString(_storageKey);
    
    if (imagesJson == null) return;
    
    final List<dynamic> imagesList = json.decode(imagesJson);
    final images = imagesList
        .map((item) => SpeechImageModel.fromJson(item))
        .toList();
    
    // Find and update the image
    final index = images.indexWhere((img) => img.id == updatedImage.id);
    if (index != -1) {
      images[index] = updatedImage;
    }
    
    final String updatedJson =
        json.encode(images.map((image) => image.toJson()).toList());
    await prefs.setString(_storageKey, updatedJson);
  }

  Future<void> deleteImage(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final String? imagesJson = prefs.getString(_storageKey);
    
    if (imagesJson == null) return;
    
    final List<dynamic> imagesList = json.decode(imagesJson);
    final images = imagesList
        .map((item) => SpeechImageModel.fromJson(item))
        .toList();
    
    // Find and delete the image file
    final imageToDelete = images.firstWhere((img) => img.id == id);
    final file = File(imageToDelete.imagePath);
    if (await file.exists()) {
      await file.delete();
    }
    
    images.removeWhere((image) => image.id == id);
    
    final String updatedJson =
        json.encode(images.map((image) => image.toJson()).toList());
    await prefs.setString(_storageKey, updatedJson);
  }

  Future<String> saveImageLocally(File imageFile, String imageName) async {
    final directory = await getApplicationDocumentsDirectory();
    
    // Get file extension from original file
    final String extension = imageFile.path.split('.').last;
    final String fileName = '${DateTime.now().millisecondsSinceEpoch}_${imageName.replaceAll(' ', '_')}.$extension';
    final String filePath = '${directory.path}/$fileName';
    
    final File newImage = await imageFile.copy(filePath);
    return newImage.path;
  }
}

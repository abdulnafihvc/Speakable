import 'dart:io';
import 'package:flutter/material.dart';
import 'package:speakable/services/google_tts_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speakable/models/speech_image_model.dart';
import 'package:speakable/services/speech_image_service.dart';
import 'package:speakable/screen/imagetoSpeech/widget/speech_image_card.dart';

class CategoryPage extends StatefulWidget {
  final String category;

  const CategoryPage({super.key, required this.category});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final SpeechImageService _imageService = SpeechImageService();
  final GoogleTtsService _googleTts = GoogleTtsService();
  final ImagePicker _imagePicker = ImagePicker();

  List<SpeechImageModel> _images = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initTts();
    _loadImages();
  }

  void _initTts() {
    // _googleTts.setLanguage('en-US');
    // _googleTts.setSpeechRate(0.5);
    // _googleTts.setVolume(1.0);
    // _googleTts.setPitch(1.0);
  }

  Future<void> _loadImages() async {
    setState(() => _isLoading = true);
    final images = await _imageService.getImagesByCategory(widget.category);
    setState(() {
      _images = images;
      _isLoading = false;
    });
  }

  Future<void> _speak(String text) async {
    await _googleTts.stop();
    await _googleTts.speak(text: text, languageCode: 'en-US');
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile == null) return;

      _showNameDialog(File(pickedFile.path));
    } catch (e) {
      _showErrorSnackBar('Failed to pick image: $e');
    }
  }

  void _showNameDialog(File imageFile) {
    final TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple.shade400, Colors.purple.shade300],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.add_photo_alternate, color: Colors.white),
            ),
            const SizedBox(width: 12),
            const Text(
              'Add Image',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
          ],
        ),
        content: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6,
            maxWidth: MediaQuery.of(context).size.width * 0.8,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    height: 100,
                    width: double.infinity,
                    child: Image.file(imageFile, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    hintText: 'Enter image name',
                    prefixIcon: const Icon(
                      Icons.label,
                      color: Colors.deepPurple,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.deepPurple,
                        width: 2,
                      ),
                    ),
                  ),
                  textCapitalization: TextCapitalization.words,
                  maxLength: 30,
                  autofocus: true,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = nameController.text.trim();
              if (name.isEmpty) {
                _showErrorSnackBar('Please enter a name');
                return;
              }
              Navigator.pop(context);
              await _saveImage(imageFile, name);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _saveImage(File imageFile, String name) async {
    try {
      final String savedPath = await _imageService.saveImageLocally(
        imageFile,
        name,
      );

      final newImage = SpeechImageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        imagePath: savedPath,
        category: widget.category,
        createdAt: DateTime.now(),
      );

      await _imageService.addImage(newImage);
      await _loadImages();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$name added successfully!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      _showErrorSnackBar('Failed to save image: $e');
    }
  }

  Future<void> _deleteImage(SpeechImageModel image) async {
    try {
      await _imageService.deleteImage(image.id);
      await _loadImages();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${image.name} deleted'),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      _showErrorSnackBar('Failed to delete image: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _googleTts.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.deepPurple),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.category,
          style: const TextStyle(
            color: Colors.deepPurple,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.deepPurple),
            )
          : _images.isEmpty
          ? _buildEmptyState()
          : Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemCount: _images.length,
                itemBuilder: (context, index) {
                  final image = _images[index];
                  return SpeechImageCard(
                    image: image,
                    onTap: () => _speak(image.name),
                    onDelete: () => _deleteImage(image),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _pickImage,
        backgroundColor: Colors.deepPurple,
        icon: const Icon(Icons.add_a_photo, color: Colors.white),
        label: const Text(
          'Add Image',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.photo_library_outlined,
            size: 100,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'No ${widget.category} images yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the button below to add images',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}

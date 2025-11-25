import 'dart:io';
import 'package:flutter/material.dart';
import 'package:speakable/services/google_tts_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speakable/models/speech_image_model.dart';
import 'package:speakable/services/speech_image_service.dart';
import 'package:speakable/screen/imagetoSpeech/widget/image_speech_card.dart';

class FoodPage extends StatefulWidget {
  const FoodPage({super.key});

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage>
    with SingleTickerProviderStateMixin {
  final SpeechImageService _imageService = SpeechImageService();
  final GoogleTtsService _googleTts = GoogleTtsService();
  final ImagePicker _imagePicker = ImagePicker();

  List<SpeechImageModel> _images = [];
  bool _isLoading = true;
  final String _category = 'Food';
  final Color _categoryColor = Colors.orange;

  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isFabMenuOpen = false;

  // Sample image data (predefined, cannot be deleted)
  final List<Map<String, String>> _sampleImages = [
    {
      'name': 'I need food. What u have ?',
      'asset': 'assets/Food-image/plate.jpg',
    },
    {'name': 'I need meals', 'asset': 'assets/Food-image/meals.png'}, //done
    {
      'name': 'I need chicken?',
      'asset': 'assets/Food-image/chicken-fry.png',
    }, //done
    {'name': 'I need soup', 'asset': 'assets/Food-image/soup.png'}, //done
    {'name': 'I need egg', 'asset': 'assets/Food-image/egg.png'},
    {'name': 'I need vada ', 'asset': 'assets/Food-image/vada.png'},
  ];

  @override
  void initState() {
    super.initState();
    _initTts();
    _loadImages();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  void _initTts() {
    // _googleTts.setLanguage('en-US');
    // _googleTts.setSpeechRate(0.5);
    // _googleTts.setVolume(1.0);
    // _googleTts.setPitch(1.0);
  }

  Future<void> _loadImages() async {
    setState(() => _isLoading = true);

    // Load user-added images from database
    final userImages = await _imageService.getImagesByCategory(_category);

    // Check which sample images are missing
    final missingSamples = _sampleImages.where((sample) {
      return !userImages.any((img) => img.name == sample['name']);
    }).toList();

    // Add any missing sample images
    if (missingSamples.isNotEmpty) {
      await _initializeMissingSampleImages(missingSamples);
      // Reload after adding samples
      final updatedImages = await _imageService.getImagesByCategory(_category);
      setState(() {
        _images = updatedImages;
        _isLoading = false;
      });
    } else {
      setState(() {
        _images = userImages;
        _isLoading = false;
      });
    }
  }

  Future<void> _initializeMissingSampleImages(
    List<Map<String, String>> missingSamples,
  ) async {
    for (var sample in missingSamples) {
      final sampleImage = SpeechImageModel(
        id: 'sample_${DateTime.now().millisecondsSinceEpoch}_${sample['name']!.hashCode}',
        name: sample['name']!,
        imagePath: sample['asset']!,
        category: _category,
        createdAt: DateTime.now(),
      );
      await _imageService.addImage(sampleImage);
    }
  }

  bool _isSampleImage(SpeechImageModel image) {
    return _sampleImages.any((sample) => sample['name'] == image.name);
  }

  Future<void> _speak(String text) async {
    try {
      await _googleTts.stop();
      await _googleTts.speak(text: text, languageCode: 'en-US');
    } catch (e) {
      _showErrorSnackBar('Failed to speak: $e');
    }
  }

  void _toggleFabMenu() {
    setState(() {
      _isFabMenuOpen = !_isFabMenuOpen;
      if (_isFabMenuOpen) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _handleImageSource(ImageSource source) {
    _toggleFabMenu();
    _pickImage(source);
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (pickedFile == null) return;

      _showNameDialog(File(pickedFile.path));
    } catch (e) {
      _showErrorSnackBar('Failed to pick image: $e');
    }
  }

  void _showNameDialog(File imageFile) {
    final TextEditingController nameController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _categoryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.add_photo_alternate, color: _categoryColor),
            ),
            const SizedBox(width: 12),
            Text(
              'Add to $_category',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _categoryColor,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    height: 150,
                    width: double.infinity,
                    child: Image.file(imageFile, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Image Name',
                    hintText: 'Enter name',
                    prefixIcon: Icon(Icons.label, color: _categoryColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: _categoryColor, width: 2),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.red, width: 2),
                    ),
                  ),
                  textCapitalization: TextCapitalization.words,
                  maxLength: 30,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a name';
                    }
                    if (value.trim().length < 2) {
                      return 'Name must be at least 2 characters';
                    }
                    return null;
                  },
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
              if (formKey.currentState!.validate()) {
                final name = nameController.text.trim();
                Navigator.pop(context);
                await _saveImage(imageFile, name);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _categoryColor,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveImage(File imageFile, String name) async {
    try {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                const SizedBox(width: 16),
                const Text('Saving image...'),
              ],
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }

      final String savedPath = await _imageService.saveImageLocally(
        imageFile,
        name,
      );

      final newImage = SpeechImageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        imagePath: savedPath,
        category: _category,
        createdAt: DateTime.now(),
      );

      await _imageService.addImage(newImage);
      await _loadImages();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Text('$name added successfully!'),
              ],
            ),
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

  Future<void> _editImageName(SpeechImageModel image, String newName) async {
    try {
      final updatedImage = SpeechImageModel(
        id: image.id,
        name: newName,
        imagePath: image.imagePath,
        category: image.category,
        createdAt: image.createdAt,
      );

      await _imageService.updateImage(updatedImage);
      await _loadImages();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Text('Name updated to "$newName"'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      _showErrorSnackBar('Failed to update name: $e');
    }
  }

  Future<void> _deleteImage(SpeechImageModel image) async {
    try {
      await _imageService.deleteImage(image.id);
      await _loadImages();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.delete_outline, color: Colors.white),
                const SizedBox(width: 12),
                Text('${image.name} deleted'),
              ],
            ),
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
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(child: Text(message)),
            ],
          ),
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
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey[100],
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.grey[850] : Colors.white,
        elevation: 2,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: _categoryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Icon(Icons.restaurant, color: _categoryColor),
            const SizedBox(width: 12),
            Text(
              _category,
              style: TextStyle(
                color: _categoryColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          if (_images.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _categoryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_images.length} ${_images.length == 1 ? 'item' : 'items'}',
                    style: TextStyle(
                      color: _categoryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (_isLoading) {
            return Center(
              child: CircularProgressIndicator(color: _categoryColor),
            );
          }

          if (_images.isEmpty) {
            return _buildEmptyState(isDarkMode);
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = orientation == Orientation.portrait ? 2 : 3;
              if (constraints.maxWidth > 600) {
                crossAxisCount = orientation == Orientation.portrait ? 3 : 4;
              }
              if (constraints.maxWidth > 900) {
                crossAxisCount = orientation == Orientation.portrait ? 4 : 5;
              }

              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemCount: _images.length,
                itemBuilder: (context, index) {
                  final image = _images[index];
                  final isSample = _isSampleImage(image);
                  return ImageSpeechCard(
                    image: image,
                    onTap: () => _speak(image.name),
                    onDelete: () => _deleteImage(image),
                    onEdit: (newName) => _editImageName(image, newName),
                    categoryColor: _categoryColor,
                    enableDelete: !isSample, // Disable delete for sample images
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScaleTransition(
            scale: _animation,
            child: FloatingActionButton(
              heroTag: 'gallery',
              onPressed: () => _handleImageSource(ImageSource.gallery),
              backgroundColor: isDarkMode ? Colors.grey[800] : Colors.white,
              elevation: 4,
              child: Icon(Icons.photo_library, color: _categoryColor),
            ),
          ),
          const SizedBox(height: 12),
          ScaleTransition(
            scale: _animation,
            child: FloatingActionButton(
              heroTag: 'camera',
              onPressed: () => _handleImageSource(ImageSource.camera),
              backgroundColor: isDarkMode ? Colors.grey[800] : Colors.white,
              elevation: 4,
              child: Icon(Icons.camera_alt, color: _categoryColor),
            ),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'main',
            onPressed: _toggleFabMenu,
            backgroundColor: _categoryColor,
            child: AnimatedIcon(
              icon: AnimatedIcons.add_event,
              progress: _animation,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.photo_library_outlined,
            size: 100,
            color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'No $_category images yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the button below to add images',
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? Colors.grey[500] : Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _toggleFabMenu,
            style: ElevatedButton.styleFrom(
              backgroundColor: _categoryColor,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.add_a_photo, color: Colors.white),
            label: const Text(
              'Add First Image',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:speakable/models/speech_image_model.dart';

// Beautiful image card with press animation - SAME DESIGN, SIMPLER CODE
class ImageSpeechCard extends StatefulWidget {
  final SpeechImageModel image; // The image data
  final VoidCallback onTap; // What happens when tapped
  final VoidCallback onDelete; // What happens when deleted
  final Function(String) onEdit; // What happens when edited
  final Color categoryColor; // Theme color for this category
  final bool enableDelete; // Whether delete is allowed (default: true)

  const ImageSpeechCard({
    super.key,
    required this.image,
    required this.onTap,
    required this.onDelete,
    required this.onEdit,
    required this.categoryColor,
    this.enableDelete = true, // Delete enabled by default
  });

  @override
  State<ImageSpeechCard> createState() => _ImageSpeechCardState();
}

class _ImageSpeechCardState extends State<ImageSpeechCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller; // Controls the press animation
  late Animation<double> _scaleAnimation; // Makes card smaller when pressed
  bool _isPressed = false; // Is the card currently being pressed?

  @override
  void initState() {
    super.initState();
    // Set up the press animation (same beautiful effect as before)
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose(); // Clean up animation
    super.dispose();
  }

  // Animation functions - same beautiful press effect
  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _controller.forward(); // Start shrink animation
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse(); // Return to normal size
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse(); // Return to normal size
  }

  // Simple delete confirmation dialog (same design)
  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

        // Warning title with icon
        title: Row(
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: Colors.orange,
              size: 28,
            ),
            const SizedBox(width: 12),
            const Text(
              'Delete Image',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),

        // Confirmation message
        content: Text(
          'Are you sure you want to delete "${widget.image.name}"?\n\nThis action cannot be undone.',
        ),

        // Cancel and Delete buttons
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              widget.onDelete(); // Delete the image
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Delete',
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

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ScaleTransition(
      scale: _scaleAnimation, // Beautiful press animation
      child: GestureDetector(
        onTap: widget.onTap, // Play sound when tapped
        onLongPress: widget.enableDelete
            ? _showDeleteDialog
            : null, // Delete when long pressed (if enabled)
        onTapDown: _handleTapDown, // Start press animation
        onTapUp: _handleTapUp, // End press animation
        onTapCancel: _handleTapCancel, // Cancel press animation
        child: Card(
          elevation: _isPressed ? 2 : 4, // Shadow changes when pressed
          color: isDarkMode ? Colors.grey[850] : Colors.white,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildImageSection(), // Top part with image
              _buildNameSection(), // Bottom part with name and edit button
            ],
          ),
        ),
      ),
    );
  }

  // Top part of card - shows the image with speaker icon
  Widget _buildImageSection() {
    // Check if the path is an asset path or a file path
    final isAssetPath = widget.image.imagePath.startsWith('assets/');

    return AspectRatio(
      aspectRatio: 1.0, // Square image
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Main image - use Asset or File based on path
          isAssetPath
              ? Image.asset(
                  widget.image.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      _buildErrorImage(),
                )
              : Image.file(
                  File(widget.image.imagePath),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      _buildErrorImage(),
                ),

          // Speaker icon overlay (top right)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: widget.categoryColor.withOpacity(0.9),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.volume_up, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  // Bottom part of card - shows name and edit button
  Widget _buildNameSection() {
    return Flexible(
      child: Container(
        constraints: const BoxConstraints(minHeight: 50),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              widget.categoryColor.withOpacity(0.15),
              widget.categoryColor.withOpacity(0.05),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            // Image name text (centered)
            Padding(
              padding: const EdgeInsets.only(
                left: 8,
                right: 32,
                top: 6,
                bottom: 6,
              ),
              child: Center(
                child: Text(
                  widget.image.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: widget.categoryColor,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),

            // Edit button (top right)
            Positioned(
              top: 2,
              right: 2,
              child: InkWell(
                onTap: _showEditDialog,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: widget.categoryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.edit,
                    size: 14,
                    color: widget.categoryColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Error image when file not found
  Widget _buildErrorImage() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.broken_image_outlined,
            size: 50,
            color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
          ),
          const SizedBox(height: 8),
          Text(
            'Image not found',
            style: TextStyle(
              color: isDarkMode ? Colors.grey[400] : Colors.grey[500],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog() {
    final TextEditingController nameController = TextEditingController(
      text: widget.image.name,
    );
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
                color: widget.categoryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.edit, color: widget.categoryColor),
            ),
            const SizedBox(width: 12),
            Text(
              'Edit Name',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: widget.categoryColor,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.4,
            maxWidth: MediaQuery.of(context).size.width * 0.8,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Image Name',
                  hintText: 'Enter new name',
                  prefixIcon: Icon(Icons.label, color: widget.categoryColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: widget.categoryColor,
                      width: 2,
                    ),
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
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final newName = nameController.text.trim();
                Navigator.pop(context);
                widget.onEdit(newName);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.categoryColor,
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
}

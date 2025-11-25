// Text Display Widget - Displays the text input area with animated styling
// This widget shows a card with text field for user input
import 'package:flutter/material.dart';

class TextDisplayWidget extends StatelessWidget {
  final String text; // Current text content
  final bool isSpeaking; // Whether TTS is currently speaking
  final TextEditingController? controller; // Controller for the text field

  const TextDisplayWidget({
    super.key,
    required this.text,
    required this.isSpeaking,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    // Container with rounded corners and shadow effect
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        // Animated shadow that changes color when speaking
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.2),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      constraints: const BoxConstraints(minHeight: 150, maxHeight: 300),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with icon and title
          Row(
            children: [
              Icon(
                isSpeaking ? Icons.volume_up : Icons.text_fields,
                color: isSpeaking ? Colors.green : primaryColor,
                size: 24,
              ),
              const SizedBox(width: 10),
              Text(
                
                isSpeaking ? 'Speaking...' : 'Enter Text',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isSpeaking ? Colors.green : primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          const Divider(),
          const SizedBox(height: 15),
          // Expanded text field that fills remaining space
          Expanded(
            child: TextField(
              controller: controller,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                hintText: 'Type or paste text here to convert to speech...',
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.color?.withOpacity(0.5),
                  fontStyle: FontStyle.italic,
                ),
              ),
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class TextDisplayWidget extends StatelessWidget {
  final String recognizedText;
  final double confidence;

  const TextDisplayWidget({
    super.key,
    required this.recognizedText,
    required this.confidence,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 150),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.text_fields, color: primaryColor, size: 24),
              const SizedBox(width: 10),
              Text(
                'Recognized Text',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const Spacer(),
              if (confidence > 0)
                Container(
                  padding: const EdgeInsets.symmetric(),
                  decoration: BoxDecoration(
                    color: confidence > 0.8
                        ? Colors.green.shade100
                        : Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            recognizedText.isEmpty
                ? 'Your speech will appear here...'
                : recognizedText,
            style: TextStyle(
              fontSize: 16,
              color: recognizedText.isEmpty
                  ? Theme.of(
                      context,
                    ).textTheme.bodyMedium?.color?.withValues(alpha: 0.5)
                  : Theme.of(context).textTheme.bodyLarge?.color,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

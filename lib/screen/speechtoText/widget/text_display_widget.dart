import 'package:flutter/material.dart';

class TextDisplayWidget extends StatelessWidget {
  final String recognizedText;
  final double confidence;

  const TextDisplayWidget({
    super.key,
    required this.recognizedText,
    required this.confidence,
  });

  int get _wordCount {
    final trimmed = recognizedText.trim();
    if (trimmed.isEmpty) return 0;
    return trimmed.split(RegExp(r'\s+')).length;
  }

  int get _charCount => recognizedText.length;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;
    
    // We'll use confidence > 0 to indicate active recognition and highlight the border
    final isListeningOrActive = confidence > 0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 180),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        // Glassmorphism effect
        color: isDark
            ? Colors.white.withOpacity(0.06)
            : Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isListeningOrActive
              ? Colors.green.withOpacity(0.6)
              : primaryColor.withOpacity(0.15),
          width: isListeningOrActive ? 2.0 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isListeningOrActive
                ? Colors.green.withOpacity(0.15)
                : primaryColor.withOpacity(0.08),
            blurRadius: isListeningOrActive ? 24 : 16,
            spreadRadius: isListeningOrActive ? 2 : 0,
            offset: const Offset(0, 6),
          ),
          if (isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with icon and title
          Row(
            children: [
               AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  isListeningOrActive ? Icons.graphic_eq_rounded : Icons.text_fields_rounded,
                  key: ValueKey(isListeningOrActive),
                  color: isListeningOrActive ? Colors.green : primaryColor,
                  size: 26,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 300),
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: isListeningOrActive ? Colors.green : primaryColor,
                    letterSpacing: 0.3,
                  ),
                  child: Text(isListeningOrActive ? 'Recognizing...' : 'Recognized Text'),
                ),
              ),
              if (confidence > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: confidence > 0.8
                        ? Colors.green.withOpacity(0.2)
                        : Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: confidence > 0.8
                          ? Colors.green.withOpacity(0.5)
                          : Colors.orange.withOpacity(0.5),
                    ),
                  ),
                  child: Text(
                    '${(confidence * 100).toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: confidence > 0.8
                          ? Colors.green
                          : Colors.orange,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(
            color: isDark
                ? Colors.white.withOpacity(0.08)
                : primaryColor.withOpacity(0.1),
            height: 1,
          ),
          const SizedBox(height: 12),
          // Text Display
          Text(
            recognizedText.isEmpty
                ? 'Your speech will appear here...'
                : recognizedText,
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
              color: recognizedText.isEmpty
                  ? Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.color
                      ?.withOpacity(0.5)
                  : Theme.of(context).textTheme.bodyLarge?.color,
              fontStyle: recognizedText.isEmpty ? FontStyle.italic : null,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 24),
          // Character & word count
          Divider(
            color: isDark
                ? Colors.white.withOpacity(0.08)
                : primaryColor.withOpacity(0.1),
            height: 1,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _CountChip(
                icon: Icons.text_fields_rounded,
                label: '$_charCount chars',
                color: primaryColor,
                isDark: isDark,
              ),
              const SizedBox(width: 12),
              _CountChip(
                icon: Icons.short_text_rounded,
                label: '$_wordCount words',
                color: primaryColor,
                isDark: isDark,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Small chip showing character or word count
class _CountChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isDark;

  const _CountChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isDark ? color.withOpacity(0.1) : color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color.withOpacity(0.7)),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}

// Text Display Widget - Glassmorphism text input card with character/word count
// Features frosted glass effect, animated border when speaking, and paste button
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextDisplayWidget extends StatelessWidget {
  final String text;
  final bool isSpeaking;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final VoidCallback? onTextChanged;

  const TextDisplayWidget({
    super.key,
    required this.text,
    required this.isSpeaking,
    this.controller,
    this.focusNode,
    this.onTextChanged,
  });

  int get _wordCount {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return 0;
    return trimmed.split(RegExp(r'\s+')).length;
  }

  int get _charCount => text.length;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        // Glassmorphism effect
        color: isDark
            ? Colors.white.withOpacity(0.06)
            : Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isSpeaking
              ? Colors.green.withOpacity(0.6)
              : primaryColor.withOpacity(0.15),
          width: isSpeaking ? 2.0 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isSpeaking
                ? Colors.green.withOpacity(0.15)
                : primaryColor.withOpacity(0.08),
            blurRadius: isSpeaking ? 24 : 16,
            spreadRadius: isSpeaking ? 2 : 0,
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
          // Header row with icon, title, and paste button
          Row(
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  isSpeaking ? Icons.graphic_eq_rounded : Icons.edit_note_rounded,
                  key: ValueKey(isSpeaking),
                  color: isSpeaking ? Colors.green : primaryColor,
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
                    color: isSpeaking ? Colors.green : primaryColor,
                    letterSpacing: 0.3,
                  ),
                  child: Text(isSpeaking ? 'Speaking...' : 'Enter Text'),
                ),
              ),
              // Paste from clipboard button
              _PasteButton(
                onPaste: () async {
                  final data = await Clipboard.getData(Clipboard.kTextPlain);
                  if (data?.text != null && controller != null) {
                    final currentText = controller!.text;
                    final selection = controller!.selection;
                    final newText = currentText.replaceRange(
                      selection.start >= 0 ? selection.start : currentText.length,
                      selection.end >= 0 ? selection.end : currentText.length,
                      data!.text!,
                    );
                    controller!.text = newText;
                    controller!.selection = TextSelection.collapsed(
                      offset: (selection.start >= 0
                              ? selection.start
                              : currentText.length) +
                          data.text!.length,
                    );
                    onTextChanged?.call();
                  }
                },
                primaryColor: primaryColor,
                isDark: isDark,
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
          // Text field
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              onChanged: (_) => onTextChanged?.call(),
              decoration: InputDecoration(
                hintText: 'Type or paste text here to convert to speech...',
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.color
                      ?.withOpacity(0.4),
                  fontStyle: FontStyle.italic,
                  fontSize: 15,
                ),
              ),
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
                color: Theme.of(context).textTheme.bodyLarge?.color,
                letterSpacing: 0.2,
              ),
            ),
          ),
          const SizedBox(height: 8),
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

/// Paste from clipboard button
class _PasteButton extends StatefulWidget {
  final VoidCallback onPaste;
  final Color primaryColor;
  final bool isDark;

  const _PasteButton({
    required this.onPaste,
    required this.primaryColor,
    required this.isDark,
  });

  @override
  State<_PasteButton> createState() => _PasteButtonState();
}

class _PasteButtonState extends State<_PasteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onPaste();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: widget.isDark
                ? widget.primaryColor.withOpacity(0.15)
                : widget.primaryColor.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.primaryColor.withOpacity(0.2),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.content_paste_rounded,
                size: 16,
                color: widget.primaryColor,
              ),
              const SizedBox(width: 4),
              Text(
                'Paste',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: widget.primaryColor,
                ),
              ),
            ],
          ),
        ),
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

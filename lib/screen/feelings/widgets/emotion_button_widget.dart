import 'package:flutter/material.dart';
import 'package:speakable/models/emotion.dart';

class EmotionButtonWidget extends StatefulWidget {
  final Emotion emotion;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const EmotionButtonWidget({
    super.key,
    required this.emotion,
    required this.onTap,
    this.onLongPress,
  });

  @override
  State<EmotionButtonWidget> createState() => _EmotionButtonWidgetState();
}

class _EmotionButtonWidgetState extends State<EmotionButtonWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.elasticOut,
      ),
    );
    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.8,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse().then((_) {
      // Add a small bounce effect after release
      if (mounted) {
        _controller.forward().then((_) => _controller.reverse());
      }
    });
    widget.onTap();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDarkMode ? Colors.grey.shade800 : widget.emotion.color;
    final borderColor = isDarkMode
        ? Colors.grey.shade700
        : Colors.grey.shade300;
    final shadowColor = isDarkMode
        ? Colors.black.withOpacity(0.3)
        : Colors.grey.withOpacity(0.2);

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onLongPress: widget.onLongPress,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Opacity(
            opacity: _opacityAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: shadowColor,
                      blurRadius: _isPressed ? 4 : 8,
                      spreadRadius: _isPressed ? 0 : 2,
                      offset: Offset(0, _isPressed ? 1 : 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.emotion.imagePath != null)
                      Image.asset(
                        widget.emotion.imagePath!,
                        width: 70,
                        height: 70,
                        fit: BoxFit.contain,
                      )
                    else
                      Icon(
                        widget.emotion.icon,
                        size: 70,
                        color: isDarkMode
                            ? Colors.grey.shade300
                            : Colors.grey.shade700,
                      ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        widget.emotion.text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDarkMode
                              ? Colors.grey.shade200
                              : Colors.grey.shade800,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (widget.emotion.isCustom) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? Colors.grey.shade700
                              : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Custom',
                          style: TextStyle(
                            fontSize: 9,
                            color: isDarkMode
                                ? Colors.grey.shade300
                                : Colors.grey.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

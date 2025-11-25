import 'package:flutter/material.dart';

class MicButtonWidget extends StatefulWidget {
  final bool isListening;
  final VoidCallback onTap;

  const MicButtonWidget({
    super.key,
    required this.isListening,
    required this.onTap,
  });

  @override
  State<MicButtonWidget> createState() => _MicButtonWidgetState();
}

class _MicButtonWidgetState extends State<MicButtonWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(MicButtonWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isListening) {
      _animationController.repeat(reverse: true);
    } else {
      _animationController.stop();
      _animationController.reset();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.isListening ? Colors.red : Colors.deepPurple,
              boxShadow: [
                BoxShadow(
                  color: widget.isListening
                      ? Colors.red.withOpacity(0.4)
                      : Colors.deepPurple.withOpacity(0.4),
                  blurRadius: widget.isListening
                      ? 20 * _scaleAnimation.value
                      : 15,
                  spreadRadius: widget.isListening
                      ? 5 * _scaleAnimation.value
                      : 2,
                ),
              ],
            ),
            child: Icon(
              widget.isListening ? Icons.mic : Icons.mic_none,
              size: 60,
              color: Colors.white,
            ),
          );
        },
      ),
    );
  }
}

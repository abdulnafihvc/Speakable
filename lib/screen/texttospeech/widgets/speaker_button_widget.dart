// Speaker Button Widget - Animated play/stop button for TTS
// Features pulsing animation when speaking
import 'package:flutter/material.dart';

class SpeakerButtonWidget extends StatefulWidget {
  final bool isSpeaking; // Whether TTS is currently active
  final VoidCallback onTap; // Callback when button is tapped

  const SpeakerButtonWidget({
    super.key,
    required this.isSpeaking,
    required this.onTap,
  });

  @override
  State<SpeakerButtonWidget> createState() => _SpeakerButtonWidgetState();
}

class _SpeakerButtonWidgetState extends State<SpeakerButtonWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController
  _animationController; // Controls the pulsing animation
  late Animation<double> _scaleAnimation; // Scale animation for pulsing effect

  @override
  void initState() {
    super.initState();
    // Initialize animation controller with 1 second duration
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Create scale animation that grows from 1.0x to 1.3x
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(SpeakerButtonWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Start/stop animation based on speaking state
    if (widget.isSpeaking) {
      _animationController.repeat(reverse: true); // Continuous pulsing
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
      // AnimatedBuilder rebuilds on each animation frame
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          // Circular button with animated shadow
          return Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // Color changes: green when speaking, purple when idle
              color: widget.isSpeaking ? Colors.green : Colors.deepPurple,
              // Animated shadow that pulses when speaking
              boxShadow: [
                BoxShadow(
                  color: widget.isSpeaking
                      ? Colors.green.withOpacity(0.4)
                      : Colors.deepPurple.withOpacity(0.4),
                  blurRadius: widget.isSpeaking
                      ? 20 * _scaleAnimation.value
                      : 15,
                  spreadRadius: widget.isSpeaking
                      ? 5 * _scaleAnimation.value
                      : 2,
                ),
              ],
            ),
            child: Icon(
              widget.isSpeaking ? Icons.volume_up : Icons.play_arrow,
              size: 60,
              color: Colors.white,
            ),
          );
        },
      ),
    );
  }
}

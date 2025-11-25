import 'package:flutter/material.dart';

class MicButtonWidget extends StatelessWidget {
  final bool isListening;
  final VoidCallback onTap;
  final AnimationController animationController;

  const MicButtonWidget({
    super.key,
    required this.isListening,
    required this.onTap,
    required this.animationController,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedBuilder(
        animation: animationController,
        builder: (context, child) {
          return Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: isListening
                    ? [Colors.red.shade400, Colors.red.shade600]
                    : [Colors.deepPurple.shade400, Colors.purple.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: (isListening ? Colors.red : Colors.deepPurple)
                      .withOpacity(isListening
                          ? 0.3 + (animationController.value * 0.3)
                          : 0.4),
                  blurRadius: isListening
                      ? 20 + (animationController.value * 10)
                      : 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(
              isListening ? Icons.mic : Icons.mic_none,
              size: 60,
              color: Colors.white,
            ),
          );
        },
      ),
    );
  }
}

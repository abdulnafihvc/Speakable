import 'dart:math' as math;
import 'package:flutter/material.dart';

class MicButtonWidget extends StatefulWidget {
  final bool isListening;
  final VoidCallback onTap;
  final AnimationController? animationController;
  final double size;

  const MicButtonWidget({
    super.key,
    required this.isListening,
    required this.onTap,
    this.animationController, // Kept for compatibility, though we manage animations internally now
    this.size = 120.0,
  });

  @override
  State<MicButtonWidget> createState() => _MicButtonWidgetState();
}

class _MicButtonWidgetState extends State<MicButtonWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _waveController;
  late AnimationController _tapController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _tapAnimation;

  @override
  void initState() {
    super.initState();

    // Pulse animation for glow effect
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Wave rings animation
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Tap scale animation
    _tapController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _tapAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _tapController, curve: Curves.easeInOut),
    );

    if (widget.isListening) {
      _pulseController.repeat(reverse: true);
      _waveController.repeat();
    }
  }

  @override
  void didUpdateWidget(MicButtonWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isListening) {
      _pulseController.repeat(reverse: true);
      _waveController.repeat();
    } else {
      _pulseController.stop();
      _pulseController.reset();
      _waveController.stop();
      _waveController.reset();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _waveController.dispose();
    _tapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isListening = widget.isListening;
    final size = widget.size;

    // Gradient colors
    final listeningGradient = [Colors.red.shade400, Colors.red.shade600];
    final idleGradient = [Colors.deepPurple.shade400, Colors.purple.shade600];
    final gradient = isListening ? listeningGradient : idleGradient;

    return GestureDetector(
      onTapDown: (_) => _tapController.forward(),
      onTapUp: (_) {
        _tapController.reverse();
        widget.onTap();
      },
      onTapCancel: () => _tapController.reverse(),
      child: AnimatedBuilder(
        animation: Listenable.merge([_pulseAnimation, _waveController, _tapAnimation]),
        builder: (context, child) {
          return ScaleTransition(
            scale: _tapAnimation,
            child: SizedBox(
              width: size * 1.8,
              height: size * 1.8,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Radiating wave rings (only when listening)
                  if (isListening) ..._buildWaveRings(size, gradient[0]),

                  // Outer glow
                  Container(
                    width: size + 16,
                    height: size + 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: gradient[0].withOpacity(
                            isListening ? 0.25 + (_pulseAnimation.value * 0.15) : 0.2,
                          ),
                          blurRadius: isListening
                              ? 28 + (_pulseAnimation.value * 12)
                              : 20,
                          spreadRadius: isListening
                              ? 4 + (_pulseAnimation.value * 4)
                              : 2,
                        ),
                      ],
                    ),
                  ),

                  // Main button
                  Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: gradient,
                      ),
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: Icon(
                        isListening ? Icons.mic : Icons.mic_none,
                        key: ValueKey(isListening),
                        size: size * 0.48,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildWaveRings(double size, Color color) {
    return List.generate(3, (index) {
      final delay = index * 0.3;
      return AnimatedBuilder(
        animation: _waveController,
        builder: (context, child) {
          final progress = (_waveController.value + delay) % 1.0;
          final ringSize = size + (progress * size * 0.8);
          final opacity = (1.0 - progress) * 0.3;

          return Container(
            width: ringSize,
            height: ringSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: color.withOpacity(math.max(0, opacity)),
                width: 2.0 * (1.0 - progress),
              ),
            ),
          );
        },
      );
    });
  }
}

// Speaker Button Widget - Premium animated play/stop button for TTS
// Features gradient colors, radiating wave rings, and tactile scale animation
import 'dart:math' as math;
import 'package:flutter/material.dart';

class SpeakerButtonWidget extends StatefulWidget {
  final bool isSpeaking;
  final VoidCallback onTap;
  final double size;

  const SpeakerButtonWidget({
    super.key,
    required this.isSpeaking,
    required this.onTap,
    this.size = 120.0,
  });

  @override
  State<SpeakerButtonWidget> createState() => _SpeakerButtonWidgetState();
}

class _SpeakerButtonWidgetState extends State<SpeakerButtonWidget>
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
  }

  @override
  void didUpdateWidget(SpeakerButtonWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSpeaking) {
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
    final isSpeaking = widget.isSpeaking;
    final size = widget.size;

    // Gradient colors
    const speakingGradient = [Color(0xFF00C853), Color(0xFF69F0AE)];
    const idleGradient = [Color(0xFF7C4DFF), Color(0xFFB388FF)];
    final gradient = isSpeaking ? speakingGradient : idleGradient;

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
                  // Radiating wave rings (only when speaking)
                  if (isSpeaking) ..._buildWaveRings(size, gradient[0]),

                  // Outer glow
                  Container(
                    width: size + 16,
                    height: size + 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: gradient[0].withOpacity(
                            isSpeaking ? 0.25 + (_pulseAnimation.value * 0.15) : 0.2,
                          ),
                          blurRadius: isSpeaking
                              ? 28 + (_pulseAnimation.value * 12)
                              : 20,
                          spreadRadius: isSpeaking
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
                        isSpeaking ? Icons.stop_rounded : Icons.play_arrow_rounded,
                        key: ValueKey(isSpeaking),
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

import 'package:flutter/material.dart';

class HomeWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final VoidCallback onTap;

  const HomeWidget({
    super.key,
    required this.icon,
    required this.text,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Determine if we are in dark mode to adjust background color if needed
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          // Soft colored shadow to create the "glow" effect
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
          // Subtle white/light glow for extra depth
          BoxShadow(
            color: isDark ? Colors.transparent : Colors.white.withOpacity(0.8),
            blurRadius: 10,
            spreadRadius: -5,
            offset: const Offset(-5, -5),
          ),
        ],
        border: Border.all(
          color: color.withOpacity(0.15), // Very subtle colored border
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Large Icon with specific color
              Icon(
                icon,
                size: 48,
                color: color,
              ),
              const SizedBox(height: 16),
              // Text matching the icon color
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: color, // Text matches icon color
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

/// A reusable card widget for the home screen navigation grid
///
/// Displays an icon and text label in a styled container with shadow effects.
/// The widget is tappable and navigates to different app features.
/// Automatically adapts to light/dark theme modes.
class HomeWidget extends StatelessWidget {
  /// The icon to display in the card
  final IconData icon;

  /// The text label to display below the icon
  final String text;

  /// The accent color for the icon, text, and shadow
  final Color color;

  /// Callback function executed when the card is tapped
  final VoidCallback onTap;

  const HomeWidget({
    super.key,
    required this.icon,
    required this.text,
    required this.color,
    required this.onTap,
  });

  /// Builds the home navigation card widget
  ///
  /// Creates a tappable card with:
  /// - Rounded corners (15px radius)
  /// - Colored shadow that adapts to theme (lighter in dark mode)
  /// - Centered icon (60px) and text label
  /// - Theme-aware background color
  /// - Responsive sizing (170x165)
  /// Returns a [GestureDetector] wrapping a styled [Container]
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Flexible(
            flex: 1,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: isDark ? 0.2 : 0.3),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 60, color: color),
                  const SizedBox(height: 12),
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

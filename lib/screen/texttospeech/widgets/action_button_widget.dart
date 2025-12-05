// Action Button Widget - Reusable button for Copy, Clear, Save actions
// Displays an icon with label and colored background
import 'package:flutter/material.dart';

class ActionButtonWidget extends StatelessWidget {
  final IconData icon; // Icon to display (e.g., Icons.copy)
  final String label; // Button label text (e.g., 'Copy')
  final Color color; // Background color of the button
  final VoidCallback onTap; // Callback when button is tapped

  const ActionButtonWidget({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      // Rounded container with shadow effect
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
          // Shadow matches button color for cohesive look
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        // Row layout: icon on left, label on right
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

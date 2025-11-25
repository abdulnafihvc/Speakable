import 'package:flutter/material.dart';

// Beautiful category card with gradient and shadow - SAME DESIGN, SIMPLER CODE
class CategoryCard extends StatelessWidget {
  final String title; // Category name like "Family", "Food"
  final IconData icon; // Icon to show
  final Color color; // Main color for the card
  final VoidCallback onTap; // What happens when user taps

  const CategoryCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // When tapped, do the action
      child: Container(
        decoration: _buildCardDecoration(), // Create the beautiful look
        child: _buildCardContent(), // Create the icon and text inside
      ),
    );
  }

  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [color.withOpacity(0.8), color], // Light to dark gradient
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(20), // Rounded corners
      boxShadow: [
        BoxShadow(
          color: color.withOpacity(0.3), // Shadow with same color
          blurRadius: 12,
          offset: const Offset(0, 6), // Shadow below the card
        ),
      ],
    );
  }

  // Creates the icon and text content inside the card
  Widget _buildCardContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Icon with circle background
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2), // Transparent white circle
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 35, color: Colors.white),
        ),
        const SizedBox(height: 10),
        // Category title text
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

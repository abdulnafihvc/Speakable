import 'dart:io';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String email;
  final File? profileImage;
  final bool isEditMode;
  final VoidCallback? onImageTap;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.email,
    this.profileImage,
    this.isEditMode = false,
    this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: isDark
                          ? Colors.cyanAccent.withOpacity(0.5)
                          : Colors.cyan.withOpacity(0.5),
                      width: 2),
                  boxShadow: [
                    if (isDark)
                      BoxShadow(
                        color: Colors.cyanAccent.withOpacity(0.2),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                  ],
                ),
              ),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark ? const Color(0xFF1E293B) : Colors.grey[200],
                ),
                child: ClipOval(
                  child: profileImage != null
                      ? Image.file(profileImage!, fit: BoxFit.cover)
                      : Icon(Icons.person_outline,
                          size: 60,
                          color: isDark ? Colors.cyanAccent : Colors.cyan[700]),
                ),
              ),
              if (isEditMode)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: onImageTap,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.cyanAccent,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.cyanAccent.withOpacity(0.4),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.camera_alt,
                          color: Colors.black, size: 18),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            name.isEmpty ? 'GUEST USER' : name.toUpperCase(),
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: isDark
                      ? Colors.white.withOpacity(0.1)
                      : Colors.grey[300]!),
            ),
            child: Text(
              email.isEmpty ? 'NO EMAIL LINKED' : email,
              style: TextStyle(
                color: isDark ? Colors.white.withOpacity(0.7) : Colors.black54,
                fontSize: 14,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'profile_text_field.dart';
import 'profile_section_card.dart';

class EmergencyContactSection extends StatelessWidget {
  final TextEditingController emergencyNameController;
  final TextEditingController emergencyPhoneController;
  final bool isEditMode;

  const EmergencyContactSection({
    super.key,
    required this.emergencyNameController,
    required this.emergencyPhoneController,
    this.isEditMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return ProfileSectionCard(
      title: 'EMERGENCY CONTACT',
      icon: Icons.emergency,
      accentColor: Colors.redAccent,
      child: Column(
        children: [
          ProfileTextField(
            controller: emergencyNameController,
            label: 'CONTACT NAME',
            icon: Icons.person,
            isEditMode: isEditMode,
          ),
          const SizedBox(height: 16),
          ProfileTextField(
            controller: emergencyPhoneController,
            label: 'CONTACT PHONE',
            icon: Icons.phone,
            keyboardType: TextInputType.phone,
            isEditMode: isEditMode,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'profile_text_field.dart';
import 'profile_dropdown.dart';
import 'profile_section_card.dart';

class PersonalInfoSection extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController dobController;
  final TextEditingController addressController;
  final String? selectedGender;
  final List<String> genders;
  final bool isEditMode;
  final VoidCallback? onNameChanged;
  final VoidCallback? onEmailChanged;
  final VoidCallback? onDateTap;
  final Function(String?)? onGenderChanged;

  const PersonalInfoSection({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.dobController,
    required this.addressController,
    required this.selectedGender,
    required this.genders,
    this.isEditMode = false,
    this.onNameChanged,
    this.onEmailChanged,
    this.onDateTap,
    this.onGenderChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ProfileSectionCard(
      title: 'PERSONAL DATA',
      icon: Icons.person_outline,
      accentColor: Colors.cyanAccent,
      child: Column(
        children: [
          ProfileTextField(
            controller: nameController,
            label: 'FULL NAME',
            icon: Icons.person,
            isEditMode: isEditMode,
            onChanged: onNameChanged != null ? (_) => onNameChanged!() : null,
          ),
          const SizedBox(height: 16),
          ProfileTextField(
            controller: emailController,
            label: 'EMAIL',
            icon: Icons.email,
            keyboardType: TextInputType.emailAddress,
            isEditMode: isEditMode,
            onChanged: onEmailChanged != null ? (_) => onEmailChanged!() : null,
          ),
          const SizedBox(height: 16),
          ProfileTextField(
            controller: phoneController,
            label: 'PHONE',
            icon: Icons.phone,
            keyboardType: TextInputType.phone,
            isEditMode: isEditMode,
          ),
          const SizedBox(height: 16),
          ProfileTextField(
            controller: dobController,
            label: 'DATE OF BIRTH',
            icon: Icons.calendar_today,
            readOnly: true,
            onTap: onDateTap,
            isEditMode: isEditMode,
          ),
          const SizedBox(height: 16),
          ProfileDropdown(
            value: selectedGender,
            label: 'GENDER',
            icon: Icons.wc,
            items: genders,
            onChanged: onGenderChanged ?? (_) {},
            isEditMode: isEditMode,
          ),
          const SizedBox(height: 16),
          ProfileTextField(
            controller: addressController,
            label: 'ADDRESS',
            icon: Icons.location_on,
            maxLines: 2,
            isEditMode: isEditMode,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'profile_text_field.dart';
import 'profile_dropdown.dart';
import 'profile_section_card.dart';

class MedicalInfoSection extends StatelessWidget {
  final TextEditingController heightController;
  final TextEditingController weightController;
  final TextEditingController allergiesController;
  final TextEditingController medicationsController;
  final TextEditingController conditionsController;
  final String? selectedBloodGroup;
  final List<String> bloodGroups;
  final bool isEditMode;
  final Function(String?)? onBloodGroupChanged;

  const MedicalInfoSection({
    super.key,
    required this.heightController,
    required this.weightController,
    required this.allergiesController,
    required this.medicationsController,
    required this.conditionsController,
    required this.selectedBloodGroup,
    required this.bloodGroups,
    this.isEditMode = false,
    this.onBloodGroupChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ProfileSectionCard(
      title: 'MEDICAL RECORD',
      icon: Icons.medical_services_outlined,
      accentColor: Colors.purpleAccent,
      child: Column(
        children: [
          ProfileDropdown(
            value: selectedBloodGroup,
            label: 'BLOOD GROUP',
            icon: Icons.bloodtype,
            items: bloodGroups,
            onChanged: onBloodGroupChanged ?? (_) {},
            isEditMode: isEditMode,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ProfileTextField(
                  controller: heightController,
                  label: 'HEIGHT (CM)',
                  icon: Icons.height,
                  keyboardType: TextInputType.number,
                  isEditMode: isEditMode,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ProfileTextField(
                  controller: weightController,
                  label: 'WEIGHT (KG)',
                  icon: Icons.monitor_weight,
                  keyboardType: TextInputType.number,
                  isEditMode: isEditMode,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ProfileTextField(
            controller: allergiesController,
            label: 'ALLERGIES',
            icon: Icons.warning_amber,
            maxLines: 2,
            hintText: 'Enter allergies',
            isEditMode: isEditMode,
          ),
          const SizedBox(height: 16),
          ProfileTextField(
            controller: medicationsController,
            label: 'MEDICATIONS',
            icon: Icons.medication,
            maxLines: 2,
            hintText: 'Current medications',
            isEditMode: isEditMode,
          ),
          const SizedBox(height: 16),
          ProfileTextField(
            controller: conditionsController,
            label: 'CONDITIONS',
            icon: Icons.local_hospital,
            maxLines: 2,
            hintText: 'Medical conditions',
            isEditMode: isEditMode,
          ),
        ],
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:speakable/models/user_document.dart';
import 'package:speakable/controllers/auth_controller.dart';
import '../widgets/widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _allergiesController = TextEditingController();
  final TextEditingController _medicationsController = TextEditingController();
  final TextEditingController _conditionsController = TextEditingController();
  final TextEditingController _emergencyNameController =
      TextEditingController();
  final TextEditingController _emergencyPhoneController =
      TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();
  File? _profileImage;
  String? _selectedGender;
  String? _selectedBloodGroup;
  DateTime? _selectedDate;
  bool _isEditMode = false;

  late Box<UserDocument> _documentsBox;

  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-'
  ];

  @override
  void initState() {
    super.initState();
    _documentsBox = Hive.box<UserDocument>('documents');

    // Load the authenticated user's data from Firebase
    _loadUserData();
  }

  /// Loads user data from Firebase Auth into the text controllers
  void _loadUserData() {
    final authController = Get.find<AuthController>();
    final user = authController.user;

    if (user != null) {
      // Set the user's display name (from signup or Google Sign-In)
      if (user.displayName != null && user.displayName!.isNotEmpty) {
        _nameController.text = user.displayName!;
      }

      // Set the user's email
      if (user.email != null && user.email!.isNotEmpty) {
        _emailController.text = user.email!;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _addressController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _allergiesController.dispose();
    _medicationsController.dispose();
    _conditionsController.dispose();
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImageSource? source = await _showImageSourceDialog();
    if (source == null) return;

    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: $e',
                style: const TextStyle(color: Colors.white)),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<ImageSource?> _showImageSourceDialog() async {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[600] : Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Choose Image Source',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildSourceButton(
                    Icons.photo_library,
                    'Gallery',
                    () => Navigator.pop(context, ImageSource.gallery),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSourceButton(
                    Icons.camera_alt,
                    'Camera',
                    () => Navigator.pop(context, ImageSource.camera),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceButton(IconData icon, String label, VoidCallback onTap) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isDark ? primaryColor.withOpacity(0.2) : Colors.blue[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color:
                  isDark ? primaryColor.withOpacity(0.5) : Colors.blue[200]!),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: primaryColor),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue[700]!,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dobController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
    });
  }

  void _saveProfile() {
    // Validate required fields
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your name'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Save and exit edit mode
    setState(() {
      _isEditMode = false;
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Text('Profile saved successfully!'),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _cancelEdit() {
    setState(() {
      _isEditMode = false;
    });
  }

  Future<void> _pickDocument() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png', 'txt'],
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final fileName = result.files.single.name;
        final fileSize = await file.length();
        final fileType = fileName.split('.').last;

        // Create document model
        final document = UserDocument(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          fileName: fileName,
          filePath: file.path,
          fileType: fileType,
          fileSize: fileSize,
          uploadDate: DateTime.now(),
        );

        // Save to Hive
        await _documentsBox.add(document);

        setState(() {});

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text('Document "$fileName" uploaded successfully!',
                        style: const TextStyle(color: Colors.white)),
                  ),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload document: $e',
                style: const TextStyle(color: Colors.white)),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _deleteDocument(int index) async {
    final document = _documentsBox.getAt(index);
    if (document == null) return;

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        title: Text('Delete Document',
            style:
                TextStyle(color: isDarkMode ? Colors.white : Colors.black87)),
        content: Text('Are you sure you want to delete "${document.fileName}"?',
            style:
                TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel',
                style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.grey[600])),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _documentsBox.deleteAt(index);
      setState(() {});

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Document deleted successfully',
                style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.black.withOpacity(0.5)
                : Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.cyan.withOpacity(0.3)),
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back,
                color: isDark ? Colors.cyanAccent : Colors.cyan[700], size: 20),
            onPressed: () => Get.back(),
          ),
        ),
        title: Text(
          'PROFILE DASHBOARD',
          style: TextStyle(
            color: isDark ? Colors.cyanAccent : Colors.cyan[800],
            fontWeight: FontWeight.bold,
            fontSize: 18,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.black.withOpacity(0.5)
                  : Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.cyan.withOpacity(0.3)),
            ),
            child: !_isEditMode
                ? IconButton(
                    icon: Icon(Icons.edit,
                        color: isDark ? Colors.cyanAccent : Colors.cyan[700],
                        size: 20),
                    onPressed: _toggleEditMode,
                    tooltip: 'Edit Profile',
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close,
                            color: Colors.redAccent, size: 20),
                        onPressed: _cancelEdit,
                        tooltip: 'Cancel',
                      ),
                      IconButton(
                        icon: const Icon(Icons.check,
                            color: Colors.green, size: 20),
                        onPressed: _saveProfile,
                        tooltip: 'Save',
                      ),
                    ],
                  ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 100), // Spacing for extendBodyBehindAppBar
            ProfileHeader(
              name: _nameController.text,
              email: _emailController.text,
              profileImage: _profileImage,
              isEditMode: _isEditMode,
              onImageTap: _pickImage,
            ),
            const SizedBox(height: 24),
            PersonalInfoSection(
              nameController: _nameController,
              emailController: _emailController,
              phoneController: _phoneController,
              dobController: _dobController,
              addressController: _addressController,
              selectedGender: _selectedGender,
              genders: _genders,
              isEditMode: _isEditMode,
              onNameChanged: () => setState(() {}),
              onEmailChanged: () => setState(() {}),
              onDateTap: _selectDate,
              onGenderChanged: (value) =>
                  setState(() => _selectedGender = value),
            ),
            const SizedBox(height: 24),
            MedicalInfoSection(
              heightController: _heightController,
              weightController: _weightController,
              allergiesController: _allergiesController,
              medicationsController: _medicationsController,
              conditionsController: _conditionsController,
              selectedBloodGroup: _selectedBloodGroup,
              bloodGroups: _bloodGroups,
              isEditMode: _isEditMode,
              onBloodGroupChanged: (value) =>
                  setState(() => _selectedBloodGroup = value),
            ),
            const SizedBox(height: 24),
            EmergencyContactSection(
              emergencyNameController: _emergencyNameController,
              emergencyPhoneController: _emergencyPhoneController,
              isEditMode: _isEditMode,
            ),
            const SizedBox(height: 24),
            DocumentsSection(
              documentsBox: _documentsBox,
              isEditMode: _isEditMode,
              onUploadPressed: _pickDocument,
              onDeleteDocument: _deleteDocument,
            ),
            const SizedBox(height: 24),
            const LogoutSection(),
            if (_isEditMode) ...[
              const SizedBox(height: 24),
              SaveButton(onPressed: _saveProfile),
            ],
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

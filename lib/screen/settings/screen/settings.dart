import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speakable/controllers/auth_controller.dart';
import 'package:speakable/controllers/theme_controller.dart';
import 'package:speakable/screen/login/screen/login_screen.dart';
import 'package:speakable/services/voice_settings_service.dart';
import 'package:android_intent_plus/android_intent.dart';

import 'dart:io' show Platform;

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final voiceSettings = Get.find<VoiceSettingsService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Voice Settings Section
          _buildSectionHeader(context, 'Voice Settings'),
          const SizedBox(height: 8),

          // Voice Settings Card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Voice Gender
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Voice Gender',
                          style: TextStyle(fontSize: 16),
                        ),
                        DropdownButton<String>(
                          value: voiceSettings.voiceGender.value,
                          underline: const SizedBox(),
                          items: const [
                            DropdownMenuItem(
                              value: 'male',
                              child: Text('Male'),
                            ),
                            DropdownMenuItem(
                              value: 'female',
                              child: Text('Female'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              voiceSettings.setVoiceGender(value);
                            }
                          },
                        ),
                      ],
                    ),
                  ),

                  // Language
                  // Obx(
                  //   () => Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       const Text('Language', style: TextStyle(fontSize: 16)),
                  //       DropdownButton<String>(
                  //         value: voiceSettings.voiceLanguage.value,
                  //         underline: const SizedBox(),
                  //         items: const [
                  //           DropdownMenuItem(
                  //             value: 'en-US',
                  //             child: Text('English'),
                  //           ),
                  //           DropdownMenuItem(
                  //             value: 'ml-IN',
                  //             child: Text('Malayalam'),
                  //           ),
                  //           DropdownMenuItem(
                  //             value: 'en-IN',
                  //             child: Text('Manglish'),
                  //           ),
                  //         ],
                  //         onChanged: (value) {
                  //           if (value != null) {
                  //             voiceSettings.setVoiceLanguage(value);
                  //           }
                  //         },
                  //       ),
                  //     ],
                  //   ),
                  // ),

                  // Test Voice Button
                  // Obx(
                  //   () => SizedBox(
                  //     width: double.infinity,
                  //     child: ElevatedButton.icon(
                  //       onPressed: () async {
                  //         final tts = GoogleTtsService.instance;
                  //         final gender = voiceSettings.voiceGender.value;
                  //         final language = voiceSettings.voiceLanguage.value;

                  //         String testText;
                  //         if (language == 'ml-IN') {
                  //           testText = gender == 'male'
                  //               ? 'നമസ്കാരം! ഇത് പുരുഷ ശബ്ദത്തിന്റെ പ്രിവ്യൂ ആണ്.'
                  //               : 'നമസ്കാരം! ഇത് സ്ത്രീ ശബ്ദത്തിന്റെ പ്രിവ്യൂ ആണ്.';
                  //         } else if (language == 'en-IN') {
                  //           testText =
                  //               'Namaskaram! Ithu oru test aanu. This is Manglish mode.';
                  //         } else {
                  //           testText =
                  //               'Hello! This is a preview of the $gender voice.';
                  //         }

                  //         await tts.speak(
                  //           text: testText,
                  //           languageCode: language,
                  //           useMaleVoice: gender == 'male',
                  //         );
                  //       },
                  //       icon: const Icon(Icons.play_circle_outline),
                  //       label: Text(
                  //         'Test ${voiceSettings.getLanguageName()} ${voiceSettings.voiceGender.value} Voice',
                  //       ),
                  //       style: ElevatedButton.styleFrom(
                  //         padding: const EdgeInsets.symmetric(vertical: 12),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Manual Instructions Card with Expandable Instructions
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Theme(
              data: Theme.of(
                context,
              ).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                initiallyExpanded: false,
                tilePadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                childrenPadding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: 16,
                ),
                leading: Icon(
                  Icons.help_outline,
                  color: Colors.deepPurple,
                  size: 24,
                ),
                title: const Text(
                  'How to Access Phone TTS Settings',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                children: [
                  _buildInstructionStep('1', 'Open your phone\'s Settings app'),
                  _buildInstructionStep(
                    '2',
                    'Go to System or General Management',
                  ),
                  _buildInstructionStep(
                    '3',
                    'Tap on Language & input or Languages',
                  ),
                  _buildInstructionStep(
                    '4',
                    'Select Text-to-speech output or TTS',
                  ),
                  _buildInstructionStep(
                    '5',
                    'Choose your preferred Google TTS engine',
                  ),
                  _buildInstructionStep(
                    '6',
                    'Download English male or female voice if not available',
                  ),
                  _buildInstructionStep(
                    '7',
                    'Configure voice settings and language',
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(
                        255,
                        0,
                        0,
                        0,
                      ).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Note: Menu names may vary by device manufacturer',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Open Phone TTS Settings Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _openPhoneTTSSettings(context),
                      icon: const Icon(Icons.open_in_new),
                      label: const Text('Open Phone TTS Settings'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Appearance Section
          _buildSectionHeader(context, 'Appearance'),
          const SizedBox(height: 8),

          // Appearance Card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Dark Mode', style: TextStyle(fontSize: 16)),
                    Switch(
                      value: themeController.isDarkMode,
                      onChanged: (value) => themeController.toggleTheme(),
                      activeColor: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // About Section
          _buildSectionHeader(context, 'About'),
          const SizedBox(height: 8),

          // About Card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Speakable',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Version 1.0.0',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'A comprehensive voice and communication app designed to help you express yourself.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Account Section
          _buildSectionHeader(context, 'Account'),
          const SizedBox(height: 8),

          // Account Card with Logout Button
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.withOpacity(0.3)),
                      gradient: LinearGradient(
                        colors: [
                          Colors.red.withOpacity(0.1),
                          Colors.red.withOpacity(0.05)
                        ],
                      ),
                    ),
                    child: TextButton.icon(
                      onPressed: () => _handleLogout(context),
                      icon: const Icon(Icons.logout, color: Colors.redAccent),
                      label: const Text(
                        'LOGOUT',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Handles the logout process and navigates to login screen
  Future<void> _handleLogout(BuildContext context) async {
    try {
      // Get the auth controller
      final authController = Get.find<AuthController>();

      // Sign out the user
      await authController.signOut();

      // Navigate directly to login screen
      Get.offAll(() => const LoginScreen());

      // Show success message
      Get.snackbar(
        'Logged Out',
        'You have been logged out successfully.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to logout. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Opens the phone's Text-to-Speech settings directly
  Future<void> _openPhoneTTSSettings(BuildContext context) async {
    if (!Platform.isAndroid) {
      Get.snackbar(
        'Not Available',
        'This feature is only available on Android devices',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    try {
      const intent = AndroidIntent(action: 'com.android.settings.TTS_SETTINGS');
      await intent.launch();
    } catch (e) {
      // If TTS settings intent fails, try general settings
      try {
        const fallbackIntent = AndroidIntent(
          action: 'android.settings.SETTINGS',
        );
        await fallbackIntent.launch();

        Get.snackbar(
          'Settings Opened',
          'Navigate to: System > Languages & input > Text-to-speech',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 4),
          backgroundColor: Colors.blue,
          colorText: Colors.white,
        );
      } catch (e2) {
        Get.snackbar(
          'Error',
          'Unable to open settings. Please follow the manual steps above.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  /// Helper method to build instruction steps
  Widget _buildInstructionStep(String number, String instruction) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.deepPurple,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(instruction, style: const TextStyle(fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

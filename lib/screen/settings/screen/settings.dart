import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speakable/controllers/theme_controller.dart';
import 'package:speakable/services/voice_settings_service.dart';
import 'package:speakable/services/google_tts_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final voiceSettings = Get.find<VoiceSettingsService>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Voice Settings Section
          _buildSectionHeader(context, 'Voice Settings'),
          const SizedBox(height: 8),
          Obx(
            () => _buildSettingTile(
              context: context,
              icon: Icons.record_voice_over,
              title: 'Voice Gender',
              subtitle: voiceSettings.voiceGender.value == 'male'
                  ? 'Male Voice'
                  : 'Female Voice',
              trailing: SegmentedButton<String>(
                segments: const [
                  ButtonSegment(
                    value: 'male',
                    label: Text('Male'),
                    icon: Icon(Icons.man, size: 18),
                  ),
                  ButtonSegment(
                    value: 'female',
                    label: Text('Female'),
                    icon: Icon(Icons.woman, size: 18),
                  ),
                ],
                selected: {voiceSettings.voiceGender.value},
                onSelectionChanged: (Set<String> selection) {
                  voiceSettings.setVoiceGender(selection.first);
                },
              ),
            ),
          ),
          // Obx(
          //   () => _buildSettingTile(
          //     context: context,
          //     icon: Icons.language,
          //     title: 'Voice Language',
          //     subtitle: voiceSettings.getLanguageName(),
          //     trailing: SegmentedButton<String>(
          //       segments: const [
          //         ButtonSegment(
          //           value: 'en-US',
          //           label: Text('English'),
          //           icon: Icon(Icons.language, size: 18),
          //         ),
          //         ButtonSegment(
          //           value: 'ml-IN',
          //           label: Text('Malayalam'),
          //           icon: Icon(Icons.translate, size: 18),
          //         ),
          //       ],
          //       selected: {voiceSettings.voiceLanguage.value},
          //       onSelectionChanged: (Set<String> selection) {
          //         voiceSettings.setVoiceLanguage(selection.first);
          //       },
          //     ),
          //   ),
          // ),
          // Obx(
          //   () => _buildSettingTile(
          //     context: context,
          //     icon: Icons.play_circle_outline,
          //     title: 'Test Voice',
          //     subtitle:
          //         'Preview ${voiceSettings.getLanguageName()} ${voiceSettings.voiceGender.value} voice',
          //     onTap: () async {
          //       final tts = GoogleTtsService();
          //       final gender = voiceSettings.voiceGender.value;
          //       final language = voiceSettings.voiceLanguage.value;

          //       // Test text based on language
          //       final testText = language == 'ml-IN'
          //           ? 'നമസ്കാരം! ഇത് ${gender == 'male' ? 'പുരുഷ' : 'സ്ത്രീ'} ശബ്ദത്തിന്റെ പ്രിവ്യൂ ആണ്.'
          //           : 'Hello! This is a preview of the $gender voice.';

          //       await tts.speak(
          //         text: testText,
          //         languageCode: language,
          //         useMaleVoice: gender == 'male',
          //       );
          //       await Future.delayed(const Duration(seconds: 3));
          //       await tts.dispose();
          //     },
          //   ),
          // ),
          const SizedBox(height: 24),

          // Appearance Section
          _buildSectionHeader(context, 'Appearance'),
          const SizedBox(height: 8),
          Obx(
            () => _buildSettingTile(
              context: context,
              icon: themeController.isDarkMode
                  ? Icons.dark_mode
                  : Icons.light_mode,
              title: 'Dark Mode',
              subtitle: themeController.isDarkMode ? 'Enabled' : 'Disabled',
              trailing: Switch(
                value: themeController.isDarkMode,
                onChanged: (value) => themeController.toggleTheme(),
                activeTrackColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // About Section
          _buildSectionHeader(context, 'About'),
          const SizedBox(height: 8),
          _buildSettingTile(
            context: context,
            icon: Icons.info_outline,
            title: 'App Version',
            subtitle: '1.0.0',
          ),
          _buildSettingTile(
            context: context,
            icon: Icons.description_outlined,
            title: 'About Speakable',
            subtitle: 'Express Yourself',
            onTap: () {
              _showAboutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Theme.of(context).primaryColor),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              )
            : null,
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Speakable'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Speakable',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Version 1.0.0'),
            SizedBox(height: 16),
            Text(
              'A comprehensive voice and communication app designed to help you express yourself.',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

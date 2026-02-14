import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speakable/controllers/auth_controller.dart';
import 'package:speakable/screen/home/widget/home_widget.dart';
import 'package:speakable/screen/imagetoSpeech/screen/image_to_Speech.dart';
import 'package:speakable/screen/settings/screen/settings.dart';
import 'package:speakable/screen/texttospeech/screen/texttoSpeech_screen.dart';
import 'package:speakable/screen/savedMessege/screen/saved_messege.dart';
import 'package:speakable/screen/feelings/screen/feelingsScreen.dart';
import 'package:speakable/screen/profile/screen/profile_sreen.dart';
import 'package:speakable/screen/emergency/screen/emergency_screen.dart';
import 'package:speakable/screen/speechtoText/screen/speech_to_text.dart';
import 'package:speakable/screen/login/screen/login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  /// Navigate to Speech to Text screen with authentication check
  void _navigateToSpeechToText(BuildContext context) {
    final authController = Get.find<AuthController>();

    if (authController.user != null) {
      // User is authenticated, proceed to Speech to Text screen
      Get.to(() => const SpeechToTextScreen());
    } else {
      // User is not authenticated, show dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Authentication Required'),
          content: const Text(
            'You need to be logged in to use the Speech to Text feature. Please log in to continue.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Get.offAll(() => const LoginScreen());
              },
              child: const Text('Log In'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(child: _buildHomeContent(context)),
    );
  }

  Widget _buildHomeContent(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {
        'icon': Icons.text_fields,
        'text': 'Text to Speech',
        'color': Colors.green,
        'onTap': () => Get.to(() => const SpeechScreen()),
      },
      {
        'icon': Icons.mic,
        'text': 'Speech to Text',
        'color': Colors.pink,
        'onTap': () => _navigateToSpeechToText(context),
      },
      {
        'icon': Icons.image,
        'text': 'Image to Speech',
        'color': Colors.purple,
        'onTap': () => Get.to(() => const ImageToSpeechScreen()),
      },
      {
        'icon': Icons.emoji_emotions,
        'text': 'Feeling',
        'color': Colors.orange,
        'onTap': () => Get.to(() => const FeelingsScreen()),
      },
      {
        'icon': Icons.person,
        'text': 'Profile',
        'color': Colors.blue,
        'onTap': () => Get.to(() => const ProfileScreen()),
      },
      {
        'icon': Icons.save,
        'text': 'Saved Messege',
        'color': Colors.green,
        'onTap': () => Get.to(() => const SavedMessegescreen()),
      },
      {
        'icon': Icons.emergency,
        'text': 'Emergency',
        'color': Colors.red,
        'onTap': () => Get.to(() => EmergencyScreen()),
      },
      {
        'icon': Icons.settings,
        'text': 'Settings',
        'color': Colors.deepPurple,
        'onTap': () => Get.to(() => const SettingsScreen()),
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 1.0,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return HomeWidget(
            icon: item['icon'],
            text: item['text'],
            color: item['color'],
            onTap: item['onTap'],
          );
        },
      ),
    );
  }
}

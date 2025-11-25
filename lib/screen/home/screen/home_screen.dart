import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speakable/screen/home/widget/home_widget.dart';
import 'package:speakable/screen/imagetoSpeech/screen/image_to_Speech.dart';
import 'package:speakable/screen/settings/screen/settings.dart';
import 'package:speakable/screen/texttospeech/screen/texttoSpeech_screen.dart';
import 'package:speakable/screen/savedMessege/screen/saved_messege.dart';
import 'package:speakable/screen/feelings/screen/feelingsScreen.dart';
import 'package:speakable/screen/profile/screen/profile_sreen.dart';
import 'package:speakable/screen/emergency/screen/emergency_screen.dart';
import 'package:speakable/screen/speechtoText/screen/speech_to_text.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  /// Builds the main home screen widget
  ///
  /// Returns a [Scaffold] with the app's background color and
  /// displays the home content grid of navigation options
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _buildHomeContent(context),
    );
  }

  /// Builds the main content area of the home screen
  ///
  /// Creates a responsive grid layout of navigation cards that adapts to
  /// device orientation. In portrait mode, displays 2 columns; in landscape
  /// mode, displays 4 columns. Each card navigates to a different feature:
  /// - Text to Speech: Convert text input to spoken audio
  /// - Speech to Text: Convert spoken words to text
  /// - Image to Speech: Associate images with speech output
  /// - Feeling: Express emotions and thoughts
  /// - Profile: User profile and information
  /// - Saved Message: Access saved messages
  /// - Emergency: Quick access to emergency contacts/messages
  /// - Settings: App configuration and preferences
  ///
  /// Returns an [OrientationBuilder] containing a [GridView] of [HomeWidget] cards
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
        'onTap': () => Get.to(() => const SpeechToTextScreen()),
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
        'onTap': () => Get.to(() => SettingsScreen()),
      },
    ];

    return OrientationBuilder(
      builder: (context, orientation) {
        final isLandscape = orientation == Orientation.landscape;
        final crossAxisCount = isLandscape ? 4 : 2;
        final childAspectRatio = isLandscape ? 1.2 : 1.0;

        return Padding(
          padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
          child: GridView.count(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: childAspectRatio,
            physics: const NeverScrollableScrollPhysics(),
            children: items.map((item) {
              return HomeWidget(
                icon: item['icon'],
                text: item['text'],
                color: item['color'],
                onTap: item['onTap'],
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

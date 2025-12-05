import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speakable/services/voice_settings_service.dart';
import 'package:speakable/services/google_tts_service.dart';
import 'package:speakable/screen/home/screen/home_screen.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'dart:io' show Platform;

class VoiceSelectionScreen extends StatefulWidget {
  const VoiceSelectionScreen({super.key});

  @override
  State<VoiceSelectionScreen> createState() => _VoiceSelectionScreenState();
}

class _VoiceSelectionScreenState extends State<VoiceSelectionScreen>
    with WidgetsBindingObserver {
  final voiceSettings = Get.find<VoiceSettingsService>();
  final tts = GoogleTtsService.instance;
  bool isChecking = false;
  String? selectedGender;
  bool _isInTTSSettings = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    print('DEBUG: App lifecycle state changed to: $state');

    // When app resumes and a voice was previously selected, re-check
    if (state == AppLifecycleState.resumed && selectedGender != null) {
      print('DEBUG: App resumed with selected gender: $selectedGender');
      // Re-check voice availability after returning from settings
      _recheckVoiceAvailability(selectedGender!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [Color(0xFF1A1A2E), Color(0xFF16213E), Color(0xFF0F3460)]
                : [Color(0xFF1A1A2E), Color(0xFF16213E), Color(0xFF0F3460)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                // Header
                Text(
                  'Choose Your Voice',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Select the voice you\'d like to use for text-to-speech',
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark
                        ? Colors.white.withOpacity(0.7)
                        : const Color(0xFF1A1A2E).withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 60),

                // Voice Options
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Male Voice Card
                      _buildVoiceCard(
                        context: context,
                        gender: 'male',
                        icon: Icons.person,
                        title: 'Male Voice',
                        description: 'Deep and clear voice',
                        color: Colors.blue,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 24),

                      // Female Voice Card
                      _buildVoiceCard(
                        context: context,
                        gender: 'female',
                        icon: Icons.person_outline,
                        title: 'Female Voice',
                        description: 'Warm and natural voice',
                        color: Colors.pink,
                        isDark: isDark,
                      ),
                    ],
                  ),
                ),

                // Loading Indicator
                if (isChecking)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 12),
                        Text(
                          'Checking voice availability...',
                          style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Hint for re-checking
                if (selectedGender != null && !isChecking)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.blue,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Downloaded the voice? Click the card again to re-check',
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark ? Colors.white70 : Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVoiceCard({
    required BuildContext context,
    required String gender,
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required bool isDark,
  }) {
    final isSelected = selectedGender == gender;

    return GestureDetector(
      onTap: isChecking ? null : () => _selectVoice(gender),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isSelected
              ? color.withOpacity(0.2)
              : (isDark ? Colors.white.withOpacity(0.1) : Colors.white),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? color.withOpacity(0.3)
                  : Colors.black.withOpacity(0.1),
              blurRadius: isSelected ? 20 : 10,
              spreadRadius: isSelected ? 2 : 0,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 40, color: color),
              ),
              const SizedBox(width: 20),

              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),

              // Test Button
              IconButton(
                onPressed: isChecking ? null : () => _testVoice(gender),
                icon: Icon(Icons.play_circle_outline, color: color, size: 32),
                tooltip: 'Test Voice',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _testVoice(String gender) async {
    try {
      await tts.speak(
        text: gender == 'male'
            ? 'Hello! This is the male voice.'
            : 'Hello! This is the female voice.',
        languageCode: 'en-US',
        useMaleVoice: gender == 'male',
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not test voice. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _selectVoice(String gender) async {
    // If clicking the same voice that was previously unavailable, re-check it
    if (selectedGender == gender) {
      print('DEBUG: Re-checking $gender voice after user clicked again');
      await _recheckVoiceAvailability(gender);
      return;
    }

    setState(() {
      selectedGender = gender;
      isChecking = true;
    });

    try {
      // Save the voice preference
      await voiceSettings.setVoiceGender(gender);
      await voiceSettings.markFirstTimeSetupComplete();

      // Check if the voice is available
      final isAvailable = await voiceSettings.isVoiceAvailable(
        gender: gender,
        languageCode: 'en-US',
      );

      setState(() {
        isChecking = false;
      });

      if (isAvailable) {
        // Voice is available, proceed to home screen
        Get.snackbar(
          'Success',
          'Voice preference saved!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );

        await Future.delayed(const Duration(milliseconds: 500));
        Get.off(() => const HomeScreen(), transition: Transition.fadeIn);
      } else {
        // Voice not available, show instructions
        _showVoiceNotAvailableDialog(gender);
      }
    } catch (e) {
      setState(() {
        isChecking = false;
      });

      Get.snackbar(
        'Error',
        'Could not save voice preference. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _showVoiceNotAvailableDialog(String gender) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
            const SizedBox(width: 12),
            const Text('Voice Not Available'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'The ${gender} voice is not available on your device. You need to download it from your phone\'s TTS settings.',
            ),
            const SizedBox(height: 16),
            const Text(
              'Steps to download:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildDialogStep('1', 'Open phone TTS settings'),
            _buildDialogStep('2', 'Select Google Text-to-speech'),
            _buildDialogStep('3', 'Download English ${gender} voice'),
            _buildDialogStep('4', 'Return to the app'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                selectedGender = null;
              });
            },
            child: const Text('Choose Different Voice'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _openPhoneTTSSettings();
            },
            icon: const Icon(Icons.open_in_new),
            label: const Text('Open TTS Settings'),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogStep(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
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
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(text),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openPhoneTTSSettings() async {
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
      // Set flag to indicate user is going to TTS settings
      _isInTTSSettings = true;

      const intent = AndroidIntent(action: 'com.android.settings.TTS_SETTINGS');
      await intent.launch();

      // Show a snackbar to remind user to return
      Get.snackbar(
        'Download Voice',
        'After downloading, return to the app to continue',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
    } catch (e) {
      // If TTS settings intent fails, try general settings
      try {
        _isInTTSSettings = true;

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
        _isInTTSSettings = false;
        Get.snackbar(
          'Error',
          'Unable to open settings. Please open manually.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  Future<void> _recheckVoiceAvailability(String gender) async {
    print(
      'DEBUG: Re-checking voice availability for $gender after returning from settings',
    );

    setState(() {
      isChecking = true;
    });

    try {
      // Wait a moment for TTS engine to refresh
      print('DEBUG: Waiting for TTS engine to refresh...');
      await Future.delayed(const Duration(milliseconds: 1000));

      // Force refresh the TTS voices by getting them again
      print('DEBUG: Fetching available voices...');
      final voices = await tts.getVoices();
      print('DEBUG: Found ${voices.length} total voices');

      // Check if the voice is now available
      print('DEBUG: Checking if $gender voice is available...');
      final isAvailable = await voiceSettings.isVoiceAvailable(
        gender: gender,
        languageCode: 'en-US',
      );

      print('DEBUG: Voice availability result: $isAvailable');

      setState(() {
        isChecking = false;
      });

      if (isAvailable) {
        // Voice is now available, proceed to home screen
        print('DEBUG: Voice is available! Proceeding to home screen');
        Get.snackbar(
          'Success',
          'Voice downloaded successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );

        await Future.delayed(const Duration(milliseconds: 500));
        Get.off(() => const HomeScreen(), transition: Transition.fadeIn);
      } else {
        // Voice still not available
        print('DEBUG: Voice is still not available');
        Get.snackbar(
          'Voice Not Found',
          'The $gender voice is still not available. Please make sure you downloaded it.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      print('DEBUG: Error during recheck: $e');
      setState(() {
        isChecking = false;
      });

      Get.snackbar(
        'Error',
        'Could not check voice availability. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}

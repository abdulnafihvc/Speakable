// Text-to-Speech Screen - Main UI for converting text to speech
// This screen handles both portrait and landscape orientations
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speakable/services/google_tts_service.dart';
import 'package:speakable/screen/texttospeech/widgets/speaker_button_widget.dart';
import 'package:speakable/screen/texttospeech/widgets/text_ttsdisplay_widget.dart';
import 'package:speakable/screen/texttospeech/widgets/action_button_widget.dart';
import 'package:speakable/services/message_storage_service.dart';
import 'package:speakable/services/manglish_service.dart';
import 'package:speakable/services/voice_settings_service.dart';
import 'package:get/get.dart';

class SpeechScreen extends StatefulWidget {
  const SpeechScreen({super.key});

  @override
  State<SpeechScreen> createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  // State variables for managing speech functionality
  bool _isSpeaking = false; // Tracks if TTS is currently speaking
  final TextEditingController _textController =
      TextEditingController(); // Controls text input
  final FocusNode _textFocusNode = FocusNode(); // Focus node for text field
  late GoogleTtsService _flutterTts; // Google TTS instance
  final MessageStorageService _storageService =
      MessageStorageService(); // Service for saving messages
  String _selectedLanguage = 'en-US'; // Currently selected language

  // Available languages for text-to-speech
  final Map<String, String> _languages = {
    'en-US': 'English',
    'ml-IN': 'Malayalam',
    'manglish': 'Manglish',
  };

  final VoiceSettingsService _voiceSettings =
      Get.find<VoiceSettingsService>(); // Voice settings

  @override
  void initState() {
    super.initState();
    _initTts();
    // Request focus on text field after the frame is built and transition completes
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Small delay to ensure screen transition is complete and widget is stable
      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted) {
        _textFocusNode.requestFocus();
      }
    });
  }

  // Initialize Google TTS with event handlers and default settings
  void _initTts() {
    _flutterTts = GoogleTtsService();

    // Handler called when TTS starts speaking
    _flutterTts.setStartHandler(() {
      setState(() {
        _isSpeaking = true;
      });
    });

    // Handler called when TTS completes speaking
    _flutterTts.setCompletionHandler(() {
      setState(() {
        _isSpeaking = false;
      });
    });

    // Handler called when TTS encounters an error
    _flutterTts.setErrorHandler((msg) {
      setState(() {
        _isSpeaking = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $msg'),
          duration: const Duration(seconds: 2),
        ),
      );
    });
  }

  @override
  void dispose() {
    _flutterTts.stop();
    _textController.dispose();
    _textFocusNode.dispose();
    super.dispose();
  }

  // Toggle between speaking and stopping TTS
  Future<void> _toggleSpeaking() async {
    // Validate that text is entered
    if (_textController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter some text first'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (_isSpeaking) {
      // Stop speaking if currently active
      await _flutterTts.stop();
      setState(() {
        _isSpeaking = false;
      });
    } else {
      // Start speaking with the entered text
      String textToSpeak = _textController.text;
      String languageCode = _selectedLanguage;

      // Transliterate Manglish to Malayalam if in Manglish mode
      if (_selectedLanguage == 'manglish') {
        textToSpeak = ManglishService.transliterateToMalayalam(textToSpeak);
        languageCode = 'ml-IN';
      }

      // Start speaking
      await _flutterTts.speak(
        text: textToSpeak,
        languageCode: languageCode,
        useMaleVoice: _voiceSettings.voiceGender.value == 'male',
      );
    }
  }

  // Copy text to clipboard
  void _copyText() {
    if (_textController.text.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _textController.text));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Text copied to clipboard'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.blue,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No text to copy'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  // Clear all text from the input field
  void _clearText() {
    setState(() {
      _textController.clear();
    });
  }

  // Save the current text to storage
  Future<void> _saveText() async {
    if (_textController.text.isNotEmpty) {
      await _storageService.saveMessage(_textController.text);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Text saved successfully'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter some text first'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if keyboard is visible
    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // AppBar with language selector and back button
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 2,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Text to Speech',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          // Show Done button when keyboard is visible
          if (isKeyboardVisible)
            IconButton(
              icon: Icon(
                Icons.keyboard_hide,
                color: Theme.of(context).primaryColor,
              ),
              tooltip: 'Hide Keyboard',
              onPressed: () {
                _textFocusNode.unfocus();
              },
            ),
          // Language selector dropdown menu
          PopupMenuButton<String>(
            icon: Icon(Icons.language, color: Theme.of(context).primaryColor),
            tooltip: 'Select Language',
            onSelected: (String value) {
              setState(() {
                _selectedLanguage = value;
              });
            },
            itemBuilder: (BuildContext context) {
              return _languages.entries.map((entry) {
                return PopupMenuItem<String>(
                  value: entry.key,
                  child: Row(
                    children: [
                      if (_selectedLanguage == entry.key)
                        Icon(
                          Icons.check,
                          color: Theme.of(context).primaryColor,
                          size: 20,
                        )
                      else
                        const SizedBox(width: 20),
                      const SizedBox(width: 8),
                      Text(entry.value),
                    ],
                  ),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          // Dismiss keyboard when tapping outside text field
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          // LayoutBuilder provides constraints for responsive layout
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isLandscape = constraints.maxWidth > constraints.maxHeight;
              final availableHeight = constraints.maxHeight;
              final availableWidth = constraints.maxWidth;

              if (isLandscape) {
                // LANDSCAPE LAYOUT: Horizontal split-screen layout
                return Row(
                  children: [
                    // Left half - Text input area
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: TextDisplayWidget(
                          text: _textController.text,
                          isSpeaking: _isSpeaking,
                          controller: _textController,
                          focusNode: _textFocusNode,
                        ),
                      ),
                    ),
                    // Right half - Controls
                    Expanded(
                      flex: 1,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Speaker Button with dynamic size
                              SpeakerButtonWidget(
                                isSpeaking: _isSpeaking,
                                onTap: _toggleSpeaking,
                                size: availableHeight * 0.25 < 100
                                    ? availableHeight * 0.25
                                    : 100,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _isSpeaking ? 'Tap to stop' : 'Tap to play',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.color,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 24),
                              // Action Buttons
                              Wrap(
                                alignment: WrapAlignment.center,
                                spacing: 12,
                                runSpacing: 12,
                                children: [
                                  ActionButtonWidget(
                                    icon: Icons.copy,
                                    label: 'Copy',
                                    color: Colors.blue,
                                    onTap: _copyText,
                                  ),
                                  ActionButtonWidget(
                                    icon: Icons.delete,
                                    label: 'Clear',
                                    color: Colors.orange,
                                    onTap: _clearText,
                                  ),
                                  ActionButtonWidget(
                                    icon: Icons.save,
                                    label: 'Save',
                                    color: Colors.green,
                                    onTap: _saveText,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                // PORTRAIT LAYOUT: Vertical stacking layout
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: availableHeight),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(height: 16),
                          // Text input widget - takes up proportional height
                          SizedBox(
                            height:
                                availableHeight * 0.45, // 45% of screen height
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: TextDisplayWidget(
                                text: _textController.text,
                                isSpeaking: _isSpeaking,
                                controller: _textController,
                                focusNode: _textFocusNode,
                              ),
                            ),
                          ),

                          // Controls section
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Column(
                              children: [
                                // Animated speaker button
                                SpeakerButtonWidget(
                                  isSpeaking: _isSpeaking,
                                  onTap: _toggleSpeaking,
                                  size: availableWidth * 0.3 < 120
                                      ? availableWidth * 0.3
                                      : 120,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _isSpeaking ? 'Tap to stop' : 'Tap to play',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium?.color,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 30),
                                // Action buttons
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: isSmallScreen
                                      ? Wrap(
                                          // Wrap on very small screens
                                          alignment: WrapAlignment.center,
                                          spacing: 10,
                                          runSpacing: 10,
                                          children: [
                                            ActionButtonWidget(
                                              icon: Icons.copy,
                                              label: 'Copy',
                                              color: Colors.blue,
                                              onTap: _copyText,
                                            ),
                                            ActionButtonWidget(
                                              icon: Icons.delete,
                                              label: 'Clear',
                                              color: Colors.orange,
                                              onTap: _clearText,
                                            ),
                                            ActionButtonWidget(
                                              icon: Icons.save,
                                              label: 'Save',
                                              color: Colors.green,
                                              onTap: _saveText,
                                            ),
                                          ],
                                        )
                                      : Row(
                                          // Row on normal screens
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            ActionButtonWidget(
                                              icon: Icons.copy,
                                              label: 'Copy',
                                              color: Colors.blue,
                                              onTap: _copyText,
                                            ),
                                            ActionButtonWidget(
                                              icon: Icons.delete,
                                              label: 'Clear',
                                              color: Colors.orange,
                                              onTap: _clearText,
                                            ),
                                            ActionButtonWidget(
                                              icon: Icons.save,
                                              label: 'Save',
                                              color: Colors.green,
                                              onTap: _saveText,
                                            ),
                                          ],
                                        ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

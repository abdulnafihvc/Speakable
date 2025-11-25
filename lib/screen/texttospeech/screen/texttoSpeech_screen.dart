// Text-to-Speech Screen - Main UI for converting text to speech
// This screen handles both portrait and landscape orientations
import 'package:flutter/material.dart';
import 'package:speakable/services/google_tts_service.dart';
import 'package:speakable/screen/texttospeech/widgets/speaker_button_widget.dart';
import 'package:speakable/screen/texttospeech/widgets/text_ttsdisplay_widget.dart';
import 'package:speakable/screen/texttospeech/widgets/action_button_widget.dart';
import 'package:speakable/services/message_storage_service.dart';
import 'package:speakable/services/manglish_service.dart';

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
  late GoogleTtsService _flutterTts; // Google TTS instance
  final MessageStorageService _storageService =
      MessageStorageService(); // Service for saving messages
  String _selectedLanguage = 'en-US'; // Currently selected language
  double _speechRate =
      0.5; // Speech rate (0.0 to 1.0, displayed as 0.2x to 2.0x)

  // Available languages for text-to-speech
  final Map<String, String> _languages = {
    'en-US': 'English',
    'ml-IN': 'Malayalam',
    'manglish': 'Manglish',
  };

  @override
  void initState() {
    super.initState();
    _initTts();
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
      await _flutterTts.speak(text: textToSpeak, languageCode: languageCode);
    }
  }

  // Update the speech rate (speed) for display only
  void _updateSpeechRate(double rate) {
    setState(() {
      _speechRate = rate;
    });
  }

  // Copy text to clipboard (TODO: implement actual clipboard functionality)
  void _copyText() {
    if (_textController.text.isNotEmpty) {
      // TODO: Implement copy to clipboard using Clipboard.setData()
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Text copied to clipboard'),
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
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // AppBar with language selector and back button
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
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
          // OrientationBuilder provides different layouts for portrait/landscape
          child: OrientationBuilder(
            builder: (context, orientation) {
              final isLandscape = orientation == Orientation.landscape;

              if (isLandscape) {
                // LANDSCAPE LAYOUT: Horizontal split-screen layout
                // Left side: Text input | Right side: Controls
                return Row(
                  children: [
                    // Left half - Text input area with scrolling
                    Expanded(
                      flex: 1,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: TextDisplayWidget(
                            text: _textController.text,
                            isSpeaking: _isSpeaking,
                            controller: _textController,
                          ),
                        ),
                      ),
                    ),
                    // Right half - Speaker button, speed control, and action buttons
                    Expanded(
                      flex: 1,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 20),
                              // Speaker Button
                              SpeakerButtonWidget(
                                isSpeaking: _isSpeaking,
                                onTap: _toggleSpeaking,
                              ),
                              const SizedBox(height: 20),
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
                              // Speech Rate Control
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Icon(
                                          Icons.speed,
                                          color: Theme.of(context).primaryColor,
                                          size: 20,
                                        ),
                                        Text(
                                          'Speed: ${(_speechRate * 2).toStringAsFixed(1)}x',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Theme.of(
                                              context,
                                            ).primaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Slider(
                                      value: _speechRate,
                                      min: 0.1,
                                      max: 1.0,
                                      divisions: 18,
                                      label:
                                          '${(_speechRate * 2).toStringAsFixed(1)}x',
                                      activeColor: Theme.of(
                                        context,
                                      ).primaryColor,
                                      onChanged: (value) {
                                        _updateSpeechRate(value);
                                      },
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Slow',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Theme.of(
                                              context,
                                            ).textTheme.bodySmall?.color,
                                          ),
                                        ),
                                        Text(
                                          'Fast',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Theme.of(
                                              context,
                                            ).textTheme.bodySmall?.color,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 30),
                              // Action Buttons
                              Wrap(
                                alignment: WrapAlignment.center,
                                spacing: 12,
                                runSpacing: 12,
                                children: [
                                  ActionButtonWidget(
                                    icon: Icons.copy,
                                    label: 'Copy',
                                    color: Colors.red,
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
                              const SizedBox(height: 20),
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 0,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        // Text input widget with animated border
                        TextDisplayWidget(
                          text: _textController.text,
                          isSpeaking: _isSpeaking,
                          controller: _textController,
                        ),
                        // ✅ FIXED: Replaced Spacer with fixed spacing to prevent overflow
                        // Spacer was trying to fill all remaining space, causing overflow
                        const SizedBox(height: 30),
                        // Animated speaker button (play/stop)
                        SpeakerButtonWidget(
                          isSpeaking: _isSpeaking,
                          onTap: _toggleSpeaking,
                        ),
                        const SizedBox(height: 20),
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
                        // Speed control slider (0.2x to 2.0x)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(
                                    Icons.speed,
                                    color: Theme.of(context).primaryColor,
                                    size: 20,
                                  ),
                                  Text(
                                    'Speed: ${(_speechRate * 2).toStringAsFixed(1)}x',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                              Slider(
                                value: _speechRate,
                                min: 0.1,
                                max: 1.0,
                                divisions: 18,
                                label:
                                    '${(_speechRate * 2).toStringAsFixed(1)}x',
                                activeColor: Theme.of(context).primaryColor,
                                onChanged: (value) {
                                  _updateSpeechRate(value);
                                },
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Slow',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(
                                        context,
                                      ).textTheme.bodySmall?.color,
                                    ),
                                  ),
                                  Text(
                                    'Fast',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(
                                        context,
                                      ).textTheme.bodySmall?.color,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                        // Action buttons: Copy, Clear, Save
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
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
                        const SizedBox(height: 30),
                      ],
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

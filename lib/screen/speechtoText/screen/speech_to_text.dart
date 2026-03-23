import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'package:speakable/services/message_storage_service.dart';
import 'package:speakable/screen/speechtoText/widget/info_banner_widget.dart';
import 'package:speakable/screen/speechtoText/widget/mic_button_widget.dart';
import 'package:speakable/screen/speechtoText/widget/text_display_widget.dart';
import 'package:speakable/screen/speechtoText/widget/action_button_widget.dart';
import 'package:speakable/services/manglish_service.dart';
import 'package:speakable/widgets/custom_app_bar.dart';

class SpeechToTextScreen extends StatefulWidget {
  const SpeechToTextScreen({super.key});

  @override
  State<SpeechToTextScreen> createState() => _SpeechToTextScreenState();
}

class _SpeechToTextScreenState extends State<SpeechToTextScreen> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  bool _isAvailable = false;
  String _recognizedText = '';
  double _confidence = 0.0;
  final MessageStorageService _storageService = MessageStorageService();
  String _selectedLanguage = 'en-US';
  bool _manglishMode = false;

  final Map<String, String> _languages = {
    'en-US': 'English',
    'ml-IN': 'Malayalam',
    'manglish': 'Manglish',
  };

  final Map<String, IconData> _languageIcons = {
    'en-US': Icons.language_rounded,
    'ml-IN': Icons.translate_rounded,
    'manglish': Icons.g_translate_rounded,
  };

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    try {
      // Request microphone permission at runtime (required on Android 6+)
      final micStatus = await Permission.microphone.request();
      if (!micStatus.isGranted) {
        if (mounted) {
          setState(() => _isAvailable = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Microphone permission denied. Please allow it in Settings.',
              ),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 4),
            ),
          );
        }
        return;
      }

      // Initialize speech recognition
      bool available = await _speech.initialize(
        onStatus: (status) {
          if (mounted) {
            setState(() {
              if (status == 'done' || status == 'notListening') {
                _isListening = false;
              }
            });
          }
        },
        onError: (error) {
          if (mounted) {
            setState(() {
              _isListening = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${error.errorMsg}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
      );

      if (mounted) {
        setState(() {
          _isAvailable = available;
        });

        if (!available) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Speech recognition not available. Please grant microphone permission.',
              ),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 4),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isAvailable = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to initialize: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  Future<void> _toggleListening() async {
    if (!_isAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Speech recognition not available'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_isListening) {
      await _speech.stop();
      setState(() {
        _isListening = false;
      });
    } else {
      setState(() {
        _isListening = true;
        _recognizedText = '';
        _confidence = 0.0;
      });

      // Set locale based on selected language
      // For Manglish, use Malayalam locale and then transliterate the output to romanized text
      String localeId =
          _selectedLanguage == 'manglish' ? 'ml-IN' : _selectedLanguage;

      await _speech.listen(
        onResult: (result) {
          if (mounted) {
            setState(() {
              String recognizedWords = result.recognizedWords;

              // If Manglish mode, convert Malayalam script to romanized Manglish
              if (_manglishMode && recognizedWords.isNotEmpty) {
                recognizedWords = ManglishService.transliterateToManglish(
                  recognizedWords,
                );
              }

              _recognizedText = recognizedWords;
              _confidence = result.confidence;
            });
          }
        },
        localeId: localeId,
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 5),
        listenOptions: stt.SpeechListenOptions(
          partialResults: true,
          cancelOnError: true,
          listenMode: stt.ListenMode.confirmation,
        ),
      );
    }
  }

  void _clearText() {
    setState(() {
      _recognizedText = '';
      _confidence = 0.0;
    });
  }

  void _copyText() {
    if (_recognizedText.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _recognizedText));
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

  Future<void> _saveText() async {
    if (_recognizedText.isNotEmpty) {
      await _storageService.saveMessage(_recognizedText, languageCode: _selectedLanguage);
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
          content: Text('No text to save'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void dispose() {
    _speech.stop();
    super.dispose();
  }



  Widget _buildLanguageChips(bool isDark, Color primaryColor) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: _languages.entries.map((entry) {
          final isSelected = _selectedLanguage == entry.key;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                if (!_isListening) {
                  setState(() {
                    _selectedLanguage = entry.key;
                    _manglishMode = (entry.key == 'manglish');
                  });
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(
                          colors: [
                            primaryColor,
                            primaryColor.withOpacity(0.7),
                          ],
                        )
                      : null,
                  color: isSelected
                      ? null
                      : (isDark
                          ? Colors.white.withOpacity(0.08)
                          : primaryColor.withOpacity(0.06)),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : primaryColor.withOpacity(0.15),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _languageIcons[entry.key],
                      size: 16,
                      color: isSelected
                          ? Colors.white
                          : primaryColor.withOpacity(0.7),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      entry.value,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : (isDark ? Colors.white70 : primaryColor),
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const CustomAppBar(
        title: 'Speech to Text',
        icon: Icons.mic_none_rounded,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate responsive dimensions
          final screenWidth = constraints.maxWidth;
          final isSmallScreen = screenWidth < 360;
          final isMediumScreen = screenWidth >= 360 && screenWidth < 600;

          // Responsive padding
          final horizontalPadding =
              isSmallScreen ? 16.0 : (isMediumScreen ? 20.0 : 24.0);
          final verticalPadding = isSmallScreen ? 16.0 : 20.0;

          return SafeArea(
            child: OrientationBuilder(
              builder: (context, orientation) {
                final isLandscape = orientation == Orientation.landscape;

                if (isLandscape) {
                  // LANDSCAPE LAYOUT: Split screen between recognized text and controls
                  return Row(
                    children: [
                      // Left side - Recognized text
                      Expanded(
                        flex: 1,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.all(horizontalPadding),
                            child: Column(
                              children: [
                                SizedBox(height: verticalPadding),
                                TextDisplayWidget(
                                  recognizedText: _recognizedText,
                                  confidence: _confidence,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Right side - Controls (language, mic, status, actions)
                      Expanded(
                        flex: 1,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Column(
                              children: [
                                _buildLanguageChips(isDark, primaryColor),
                                const SizedBox(height: 16),
                                // Info Banner
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                                  child: InfoBannerWidget(isAvailable: _isAvailable),
                                ),
                                const SizedBox(height: 40),
                                // Microphone Button
                                MicButtonWidget(
                                  isListening: _isListening,
                                  onTap: _toggleListening,
                                ),
                                const SizedBox(height: 20),
                                // Status Text
                                Column(
                                  children: [
                                    Text(
                                      _isListening
                                          ? 'Listening...'
                                          : 'Tap to speak',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: _isListening
                                            ? Colors.red
                                            : Theme.of(
                                                context,
                                              ).textTheme.bodyMedium?.color,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    if (_manglishMode)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.orange.withValues(
                                              alpha: 0.2,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.translate,
                                                size: 16,
                                                color: Colors.orange[700],
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                'Manglish Mode Active',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.orange[700],
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 30),
                                // Action Buttons
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth: screenWidth * 0.4,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                ),
                                SizedBox(height: verticalPadding),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  // PORTRAIT LAYOUT: Original vertical layout with scrolling
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: verticalPadding),
                        // Language Selector
                        _buildLanguageChips(isDark, primaryColor),
                        const SizedBox(height: 16),
                        // Info Banner
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                          child: InfoBannerWidget(isAvailable: _isAvailable),
                        ),
                        SizedBox(height: isSmallScreen ? 30.0 : 40.0),
                        // Microphone Button
                        MicButtonWidget(
                          isListening: _isListening,
                          onTap: _toggleListening,
                        ),
                        const SizedBox(height: 20),
                        // Status Text
                        Column(
                          children: [
                            Text(
                              _isListening ? 'Listening...' : 'Tap to speak',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 16.0 : 18.0,
                                color: _isListening
                                    ? Colors.red
                                    : Theme.of(
                                        context,
                                      ).textTheme.bodyMedium?.color,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (_manglishMode)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withValues(
                                      alpha: 0.2,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.translate,
                                        size: 16,
                                        color: Colors.orange[700],
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Manglish Mode Active',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.orange[700],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: isSmallScreen ? 30.0 : 40.0),
                        // Recognized Text Display at the top equivalent position
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                          child: TextDisplayWidget(
                            recognizedText: _recognizedText,
                            confidence: _confidence,
                          ),
                        ),
                        const SizedBox(height: 30),
                        // Action Buttons - Equal width with consistent spacing
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                        SizedBox(height: verticalPadding),
                      ],
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}

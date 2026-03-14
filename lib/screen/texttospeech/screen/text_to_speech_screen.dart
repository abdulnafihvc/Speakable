// Text-to-Speech Screen - Premium UI for converting text to speech
// Features gradient header, language chips, speech rate slider, and styled feedback
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

class _SpeechScreenState extends State<SpeechScreen>
    with TickerProviderStateMixin {
  bool _isSpeaking = false;
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFocusNode = FocusNode();
  late GoogleTtsService _flutterTts;
  final MessageStorageService _storageService = MessageStorageService();
  String _selectedLanguage = 'en-US';

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

  final VoiceSettingsService _voiceSettings =
      Get.find<VoiceSettingsService>();

  @override
  void initState() {
    super.initState();
    _initTts();
    _textController.addListener(() {
      setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted) {
        _textFocusNode.requestFocus();
      }
    });
  }

  void _initTts() {
    _flutterTts = GoogleTtsService();

    _flutterTts.setStartHandler(() {
      setState(() {
        _isSpeaking = true;
      });
    });

    _flutterTts.setCompletionHandler(() {
      setState(() {
        _isSpeaking = false;
      });
    });

    _flutterTts.setErrorHandler((msg) {
      setState(() {
        _isSpeaking = false;
      });
      _showStyledSnackBar(
        message: 'Error: $msg',
        icon: Icons.error_outline_rounded,
        color: const Color(0xFFEF5350),
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

  Future<void> _toggleSpeaking() async {
    if (_textController.text.isEmpty) {
      _showStyledSnackBar(
        message: 'Please enter some text first',
        icon: Icons.info_outline_rounded,
        color: const Color(0xFFFFA726),
      );
      return;
    }

    if (_isSpeaking) {
      await _flutterTts.stop();
      setState(() {
        _isSpeaking = false;
      });
    } else {
      String textToSpeak = _textController.text;
      String languageCode = _selectedLanguage;

      if (_selectedLanguage == 'manglish') {
        textToSpeak = ManglishService.transliterateToMalayalam(textToSpeak);
        languageCode = 'ml-IN';
      }

      await _flutterTts.speak(
        text: textToSpeak,
        languageCode: languageCode,
        useMaleVoice: _voiceSettings.voiceGender.value == 'male',
        volume: 1.0,
      );
    }
  }

  void _copyText() {
    if (_textController.text.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _textController.text));
      _showStyledSnackBar(
        message: 'Text copied to clipboard',
        icon: Icons.check_circle_outline_rounded,
        color: const Color(0xFF42A5F5),
      );
    } else {
      _showStyledSnackBar(
        message: 'No text to copy',
        icon: Icons.info_outline_rounded,
        color: const Color(0xFFFFA726),
      );
    }
  }

  void _clearText() {
    setState(() {
      _textController.clear();
    });
  }

  Future<void> _saveText() async {
    if (_textController.text.isNotEmpty) {
      await _storageService.saveMessage(_textController.text, languageCode: _selectedLanguage);
      if (mounted) {
        _showStyledSnackBar(
          message: 'Text saved successfully',
          icon: Icons.check_circle_outline_rounded,
          color: const Color(0xFF66BB6A),
        );
      }
    } else {
      _showStyledSnackBar(
        message: 'Please enter some text first',
        icon: Icons.info_outline_rounded,
        color: const Color(0xFFFFA726),
      );
    }
  }

  void _showStyledSnackBar({
    required String message,
    required IconData icon,
    required Color color,
  }) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        duration: const Duration(seconds: 2),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(context, isKeyboardVisible, isDark, primaryColor),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isLandscape =
                  constraints.maxWidth > constraints.maxHeight;
              final availableHeight = constraints.maxHeight;
              final availableWidth = constraints.maxWidth;

              if (isLandscape) {
                return _buildLandscapeLayout(
                  context,
                  availableHeight,
                  availableWidth,
                  isDark,
                  primaryColor,
                );
              } else {
                return _buildPortraitLayout(
                  context,
                  availableHeight,
                  availableWidth,
                  isDark,
                  primaryColor,
                );
              }
            },
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    bool isKeyboardVisible,
    bool isDark,
    Color primaryColor,
  ) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [const Color(0xFF1A1A2E), const Color(0xFF16213E)]
                : [primaryColor.withOpacity(0.05), primaryColor.withOpacity(0.02)],
          ),
        ),
      ),
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.arrow_back_ios_new_rounded,
              color: primaryColor, size: 18),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.record_voice_over_rounded,
              color: primaryColor, size: 22),
          const SizedBox(width: 8),
          Text(
            'Text to Speech',
            style: TextStyle(
              color: isDark ? Colors.white : primaryColor,
              fontWeight: FontWeight.w700,
              fontSize: 19,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
      centerTitle: true,
      actions: [
        if (isKeyboardVisible)
          IconButton(
            icon: Icon(Icons.keyboard_hide_rounded,
                color: primaryColor, size: 22),
            tooltip: 'Hide Keyboard',
            onPressed: () => _textFocusNode.unfocus(),
          ),
      ],
    );
  }

  // ─── Language Chips ─────────────────────────────────────────────
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
              onTap: () => setState(() => _selectedLanguage = entry.key),
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


  // ─── Portrait Layout ─────────────────────────────────────────────
  Widget _buildPortraitLayout(
    BuildContext context,
    double availableHeight,
    double availableWidth,
    bool isDark,
    Color primaryColor,
  ) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: availableHeight),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 12),
            // Language chips
            _buildLanguageChips(isDark, primaryColor),
            const SizedBox(height: 14),
            // Text input widget
            SizedBox(
              height: availableHeight * 0.40,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextDisplayWidget(
                  text: _textController.text,
                  isSpeaking: _isSpeaking,
                  controller: _textController,
                  focusNode: _textFocusNode,
                  onTextChanged: () => setState(() {}),
                ),
              ),
            ),
            // Controls section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                children: [
                  // Speaker button
                  SpeakerButtonWidget(
                    isSpeaking: _isSpeaking,
                    onTap: _toggleSpeaking,
                    size: availableWidth * 0.25 < 110
                        ? availableWidth * 0.25
                        : 110,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isSpeaking ? 'Tap to stop' : 'Tap to play',
                    style: TextStyle(
                      fontSize: 14,
                      color: _isSpeaking
                          ? const Color(0xFF66BB6A)
                          : (isDark ? Colors.white54 : Colors.black45),
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Action buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ActionButtonWidget(
                          icon: Icons.copy_rounded,
                          label: 'Copy',
                          color: const Color(0xFF42A5F5),
                          onTap: _copyText,
                        ),
                        ActionButtonWidget(
                          icon: Icons.delete_outline_rounded,
                          label: 'Clear',
                          color: const Color(0xFFFFA726),
                          onTap: _clearText,
                        ),
                        ActionButtonWidget(
                          icon: Icons.bookmark_add_outlined,
                          label: 'Save',
                          color: const Color(0xFF66BB6A),
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
    );
  }

  // ─── Landscape Layout ─────────────────────────────────────────────
  Widget _buildLandscapeLayout(
    BuildContext context,
    double availableHeight,
    double availableWidth,
    bool isDark,
    Color primaryColor,
  ) {
    return Row(
      children: [
        // Left half - Text input area
        Expanded(
          flex: 1,
          child: Column(
            children: [
              const SizedBox(height: 8),
              _buildLanguageChips(isDark, primaryColor),
              const SizedBox(height: 8),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 8, 16),
                  child: TextDisplayWidget(
                    text: _textController.text,
                    isSpeaking: _isSpeaking,
                    controller: _textController,
                    focusNode: _textFocusNode,
                    onTextChanged: () => setState(() {}),
                  ),
                ),
              ),
            ],
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
                  SpeakerButtonWidget(
                    isSpeaking: _isSpeaking,
                    onTap: _toggleSpeaking,
                    size: availableHeight * 0.22 < 90
                        ? availableHeight * 0.22
                        : 90,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isSpeaking ? 'Tap to stop' : 'Tap to play',
                    style: TextStyle(
                      fontSize: 14,
                      color: _isSpeaking
                          ? const Color(0xFF66BB6A)
                          : (isDark ? Colors.white54 : Colors.black45),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      ActionButtonWidget(
                        icon: Icons.copy_rounded,
                        label: 'Copy',
                        color: const Color(0xFF42A5F5),
                        onTap: _copyText,
                      ),
                      ActionButtonWidget(
                        icon: Icons.delete_outline_rounded,
                        label: 'Clear',
                        color: const Color(0xFFFFA726),
                        onTap: _clearText,
                      ),
                      ActionButtonWidget(
                        icon: Icons.bookmark_add_outlined,
                        label: 'Save',
                        color: const Color(0xFF66BB6A),
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
  }
}

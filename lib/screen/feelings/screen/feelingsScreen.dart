import 'package:flutter/material.dart';
import 'package:speakable/services/google_tts_service.dart';
import 'package:speakable/models/emotion.dart';
import 'package:speakable/services/emotion_storage_service.dart';
import 'package:speakable/screen/feelings/widgets/emotion_button_widget.dart';
import 'package:get/get.dart';
import 'package:speakable/services/voice_settings_service.dart';
import 'package:speakable/widgets/custom_app_bar.dart';

class FeelingsScreen extends StatefulWidget {
  const FeelingsScreen({super.key});

  @override
  State<FeelingsScreen> createState() => _FeelingsScreenState();
}

class _FeelingsScreenState extends State<FeelingsScreen> {
  final EmotionStorageService _storageService = EmotionStorageService();
  late GoogleTtsService _googleTts;
  final VoiceSettingsService _voiceSettings = Get.find<VoiceSettingsService>();
  List<Emotion> _emotions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initTts();
    _loadEmotions();
  }

  void _initTts() {
    _googleTts = GoogleTtsService();
  }

  Future<void> _loadEmotions() async {
    setState(() => _isLoading = true);
    final emotions = await _storageService.getAllEmotions();
    setState(() {
      _emotions = emotions;
      _isLoading = false;
    });
  }

  Future<void> _speakEmotion(Emotion emotion) async {
    await _googleTts.stop();
    await _googleTts.speak(
      text: emotion.text,
      languageCode: 'en-US',
      useMaleVoice: _voiceSettings.voiceGender.value == 'male',
    );
  }

  void _showAddCustomEmotionDialog() {
    final textController = TextEditingController();
    String selectedEmoji = '😀';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Add Custom Thought'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: textController,
                    decoration: const InputDecoration(
                      labelText: 'What do you want to say?',
                      hintText: 'e.g., I want to go outside',
                      border: OutlineInputBorder(),
                    ),
                    maxLength: 50,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Choose Icon:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        [
                          '😀', '😂', '🥺', '🤔', '😴', 
                          '🤢', '😡', '🙄', '😇', '🥲', 
                          '🥳', '😠', '😞', '😁', '🙂',
                          '❤️', '💖', '👎', '👍',
                          '👋', '🙏', '🤝', '🫂',
                          '🚽', '🚿', '🛌', '🍽️', '🧃', 
                          '🎮', '📺', '⚽', '🎨',
                          '🏠', '🏫', '🚗', '✈️', '🏥',
                          '🐶', '🐈', '🐢', '🎵',
                        ].map((emojiStr) {
                          return GestureDetector(
                            onTap: () =>
                                setDialogState(() => selectedEmoji = emojiStr),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: selectedEmoji == emojiStr
                                    ? Colors.deepPurple.withOpacity(0.2)
                                    : Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: selectedEmoji == emojiStr
                                      ? Colors.deepPurple
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: Text(
                                emojiStr,
                                style: const TextStyle(fontSize: 30),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (textController.text.isNotEmpty) {
                    final newEmotion = Emotion(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      text: textController.text,
                      emoji: selectedEmoji,
                      color: Colors.white,
                      isCustom: true,
                    );
                    await _storageService.saveCustomEmotion(newEmotion);
                    await _loadEmotions();
                    if (mounted) Navigator.pop(context);
                  }
                },
                child: const Text('Add'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _deleteCustomEmotion(Emotion emotion) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Custom Thought'),
        content: Text('Delete "${emotion.text}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _storageService.deleteCustomEmotion(emotion.id);
      await _loadEmotions();
    }
  }

  @override
  void dispose() {
    // Don't dispose singleton - just stop any ongoing speech
    _googleTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Feelings',
        icon: Icons.emoji_emotions,
        themeColor: Colors.orange,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                gridDelegate:
                    const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.95,
                    ),
                itemCount: _emotions.length,
                itemBuilder: (context, index) {
                  final emotion = _emotions[index];
                  return EmotionButtonWidget(
                    emotion: emotion,
                    onTap: () => _speakEmotion(emotion),
                    onLongPress: emotion.isCustom
                        ? () => _deleteCustomEmotion(emotion)
                        : null,
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddCustomEmotionDialog,
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
        tooltip: 'Add Custom Thought',
      ),
    );
  }
}

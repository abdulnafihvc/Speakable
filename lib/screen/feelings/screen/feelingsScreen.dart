import 'package:flutter/material.dart';
import 'package:speakable/services/google_tts_service.dart';
import 'package:speakable/models/emotion.dart';
import 'package:speakable/services/emotion_storage_service.dart';
import 'package:speakable/screen/feelings/widgets/emotion_button_widget.dart';
import 'package:get/get.dart';
import 'package:speakable/services/voice_settings_service.dart';

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
    IconData selectedIcon = Icons.sentiment_satisfied;

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
                          Icons.sentiment_satisfied,
                          Icons.favorite,
                          Icons.star,
                          Icons.home,
                          Icons.school,
                          Icons.directions_car,
                          Icons.pets,
                          Icons.music_note,
                          Icons.sentiment_very_dissatisfied,
                          Icons.sentiment_dissatisfied,
                          Icons.sentiment_very_satisfied,
                          Icons.sentiment_satisfied_alt,
                        ].map((icon) {
                          return GestureDetector(
                            onTap: () =>
                                setDialogState(() => selectedIcon = icon),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: selectedIcon == icon
                                    ? Colors.deepPurple.withOpacity(0.2)
                                    : Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: selectedIcon == icon
                                      ? Colors.deepPurple
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: Icon(icon, size: 30),
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
                      icon: selectedIcon,
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.only(
                    top: 16,
                    left: 16,
                    right: 16,
                    bottom: 16,
                  ),
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
          Positioned(
            top: 40,
            left: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey.shade800
                    : Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black.withOpacity(0.3)
                        : Colors.grey.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
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

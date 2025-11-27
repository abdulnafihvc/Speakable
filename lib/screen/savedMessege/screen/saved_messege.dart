import 'package:flutter/material.dart';
import 'package:speakable/services/google_tts_service.dart';
import 'package:speakable/models/saved_message.dart';
import 'package:speakable/services/message_storage_service.dart';
import 'package:speakable/screen/savedMessege/widgets/saved_message_card.dart';
import 'package:get/get.dart';
import 'package:speakable/services/voice_settings_service.dart';

class SavedMessegescreen extends StatefulWidget {
  const SavedMessegescreen({super.key});

  @override
  State<SavedMessegescreen> createState() => _SavedMessegescreenState();
}

class _SavedMessegescreenState extends State<SavedMessegescreen> {
  final MessageStorageService _storageService = MessageStorageService();
  late GoogleTtsService _flutterTts;
  final VoiceSettingsService _voiceSettings = Get.find<VoiceSettingsService>();
  List<SavedMessage> _messages = [];
  List<SavedMessage> _filteredMessages = [];
  String? _playingMessageId;
  bool _isLoading = true;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initTts();
    _loadMessages();
    _searchController.addListener(_filterMessages);
  }

  void _initTts() {
    _flutterTts = GoogleTtsService();

    _flutterTts.setCompletionHandler(() {
      setState(() {
        _playingMessageId = null;
      });
    });

    _flutterTts.setErrorHandler((msg) {
      setState(() {
        _playingMessageId = null;
      });
    });
  }

  Future<void> _loadMessages() async {
    setState(() {
      _isLoading = true;
    });

    final messages = await _storageService.getSavedMessages();

    setState(() {
      _messages = messages;
      _filteredMessages = messages;
      _isLoading = false;
    });
  }

  void _filterMessages() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredMessages = _messages;
      } else {
        _filteredMessages = _messages
            .where((message) => message.text.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  Future<void> _playMessage(SavedMessage message) async {
    if (_playingMessageId == message.id) {
      // Stop playing
      await _flutterTts.stop();
      setState(() {
        _playingMessageId = null;
      });
    } else {
      // Stop any current playback
      await _flutterTts.stop();

      // Start playing new message
      setState(() {
        _playingMessageId = message.id;
      });

      await _flutterTts.speak(
        text: message.text,
        languageCode: 'en-US',
        useMaleVoice: _voiceSettings.voiceGender.value == 'male',
      );
    }
  }

  Future<void> _deleteMessage(SavedMessage message) async {
    // Stop if currently playing
    if (_playingMessageId == message.id) {
      await _flutterTts.stop();
      setState(() {
        _playingMessageId = null;
      });
    }

    await _storageService.deleteMessage(message.id);
    await _loadMessages();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Message deleted'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showAddMessageDialog() {
    final TextEditingController textController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.add_circle_outline,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 8),
            const Text('Add New Message'),
          ],
        ),
        content: TextField(
          controller: textController,
          maxLines: 5,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Enter your message here...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
            ),
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
                await _storageService.saveMessage(textController.text);
                await _loadMessages();
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Message added successfully'),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black
                  : Colors.white,
            ),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditMessageDialog(SavedMessage message) {
    final TextEditingController textController = TextEditingController(
      text: message.text,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.edit, color: Theme.of(context).primaryColor),
            const SizedBox(width: 8),
            const Text('Edit Message'),
          ],
        ),
        content: TextField(
          controller: textController,
          maxLines: 5,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Edit your message...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
            ),
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
                await _storageService.updateMessage(
                  message.id,
                  textController.text,
                );
                await _loadMessages();
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Message updated successfully'),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black
                  : Colors.white,
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _flutterTts.stop();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 2,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: TextStyle(color: Theme.of(context).primaryColor),
                decoration: InputDecoration(
                  hintText: 'Search messages...',
                  hintStyle: TextStyle(
                    color: Theme.of(context).primaryColor.withOpacity(0.5),
                  ),
                  border: InputBorder.none,
                ),
              )
            : Text(
                'Saved Messages',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                }
              });
            },
          ),
          if (_messages.isNotEmpty && !_isSearching)
            IconButton(
              icon: const Icon(Icons.delete_sweep, color: Colors.red),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Clear All'),
                    content: const Text('Delete all saved messages?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text(
                          'Delete',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  await _flutterTts.stop();
                  await _storageService.clearAllMessages();
                  await _loadMessages();
                }
              },
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _filteredMessages.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _searchController.text.isNotEmpty
                        ? Icons.search_off
                        : Icons.inbox_outlined,
                    size: 80,
                    color: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.color?.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _searchController.text.isNotEmpty
                        ? 'No messages found'
                        : 'No saved messages',
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _searchController.text.isNotEmpty
                        ? 'Try a different search term'
                        : 'Tap + to add a new message',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.color?.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadMessages,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 16),
                itemCount: _filteredMessages.length,
                itemBuilder: (context, index) {
                  final message = _filteredMessages[index];
                  return SavedMessageCard(
                    message: message,
                    isPlaying: _playingMessageId == message.id,
                    onPlay: () => _playMessage(message),
                    onDelete: () => _deleteMessage(message),
                    onEdit: () => _showEditMessageDialog(message),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMessageDialog,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.black
            : Colors.white,
        tooltip: 'Add Message',
        child: const Icon(Icons.add),
      ),
    );
  }
}

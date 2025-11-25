import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/saved_message.dart';

class MessageStorageService {
  static const String _key = 'saved_messages';

  Future<List<SavedMessage>> getSavedMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final String? messagesJson = prefs.getString(_key);

    if (messagesJson == null) {
      return [];
    }

    final List<dynamic> messagesList = jsonDecode(messagesJson);
    return messagesList
        .map((json) => SavedMessage.fromJson(json))
        .toList()
        .reversed
        .toList(); // Most recent first
  }

  Future<void> saveMessage(String text) async {
    final prefs = await SharedPreferences.getInstance();
    final messages = await getSavedMessages();

    final newMessage = SavedMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      timestamp: DateTime.now(),
    );

    messages.insert(0, newMessage); // Add to beginning

    final messagesJson = jsonEncode(messages.map((m) => m.toJson()).toList());

    await prefs.setString(_key, messagesJson);
  }

  Future<void> updateMessage(String id, String newText) async {
    final prefs = await SharedPreferences.getInstance();
    final messages = await getSavedMessages();

    final index = messages.indexWhere((message) => message.id == id);
    if (index != -1) {
      messages[index] = SavedMessage(
        id: messages[index].id,
        text: newText,
        timestamp: messages[index].timestamp,
      );

      final messagesJson = jsonEncode(messages.map((m) => m.toJson()).toList());

      await prefs.setString(_key, messagesJson);
    }
  }

  Future<void> deleteMessage(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final messages = await getSavedMessages();

    messages.removeWhere((message) => message.id == id);

    final messagesJson = jsonEncode(messages.map((m) => m.toJson()).toList());

    await prefs.setString(_key, messagesJson);
  }

  Future<void> clearAllMessages() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}

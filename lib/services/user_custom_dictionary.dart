import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speakable/services/manglish_service.dart';

class UserCustomDictionary {
  static const String _dictionaryKey = 'user_custom_manglish_dictionary';
  static UserCustomDictionary? _instance;
  static UserCustomDictionary get instance => _instance ??= UserCustomDictionary._internal();
  UserCustomDictionary._internal();

  Map<String, String> _userDictionary = {};
  bool _isLoaded = false;

  Future<void> _loadDictionary() async {
    if (_isLoaded) return;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final dictionaryJson = prefs.getString(_dictionaryKey);
      
      if (dictionaryJson != null) {
        final Map<String, dynamic> decoded = jsonDecode(dictionaryJson);
        _userDictionary = decoded.map((key, value) => MapEntry(key, value.toString()));
      }
      _isLoaded = true;
    } catch (e) {
      // If loading fails, start with empty dictionary
      _userDictionary = {};
      _isLoaded = true;
    }
  }

  Future<void> _saveDictionary() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dictionaryJson = jsonEncode(_userDictionary);
      await prefs.setString(_dictionaryKey, dictionaryJson);
    } catch (e) {
      // Handle save error silently or log it
      print('Error saving user dictionary: $e');
    }
  }

  Future<void> addWord(String manglish, String malayalam) async {
    await _loadDictionary();
    
    if (manglish.isNotEmpty && malayalam.isNotEmpty) {
      _userDictionary[manglish.toLowerCase()] = malayalam;
      await _saveDictionary();
    }
  }

  Future<void> removeWord(String manglish) async {
    await _loadDictionary();
    
    _userDictionary.remove(manglish.toLowerCase());
    await _saveDictionary();
  }

  Future<void> updateWord(String manglish, String malayalam) async {
    await _loadDictionary();
    
    if (manglish.isNotEmpty && malayalam.isNotEmpty) {
      _userDictionary[manglish.toLowerCase()] = malayalam;
      await _saveDictionary();
    }
  }

  Future<String?> getWord(String manglish) async {
    await _loadDictionary();
    return _userDictionary[manglish.toLowerCase()];
  }

  Future<bool> hasWord(String manglish) async {
    await _loadDictionary();
    return _userDictionary.containsKey(manglish.toLowerCase());
  }

  Future<Map<String, String>> getAllWords() async {
    await _loadDictionary();
    return Map.from(_userDictionary);
  }

  Future<List<String>> getSuggestions(String input) async {
    await _loadDictionary();
    
    final suggestions = <String>[];
    final lowerInput = input.toLowerCase();
    
    for (var entry in _userDictionary.entries) {
      if (entry.key.startsWith(lowerInput)) {
        suggestions.add('${entry.key} → ${entry.value}');
      }
    }
    
    return suggestions;
  }

  Future<void> clearDictionary() async {
    await _loadDictionary();
    _userDictionary.clear();
    await _saveDictionary();
  }

  Future<void> importDictionary(Map<String, String> dictionary) async {
    await _loadDictionary();
    
    for (var entry in dictionary.entries) {
      if (entry.key.isNotEmpty && entry.value.isNotEmpty) {
        _userDictionary[entry.key.toLowerCase()] = entry.value;
      }
    }
    
    await _saveDictionary();
  }

  Future<Map<String, String>> exportDictionary() async {
    await _loadDictionary();
    return Map.from(_userDictionary);
  }

  int get wordCount => _userDictionary.length;
}

class EnhancedManglishService {
  static Future<String> transliterateToMalayalam(String manglishText) async {
    if (manglishText.isEmpty) return manglishText;

    // Split into words and process each word
    List<String> words = manglishText.split(RegExp(r'\s+'));
    List<String> transliteratedWords = [];

    for (String word in words) {
      if (word.isEmpty) continue;

      // Check for punctuation at the end
      String punctuation = '';
      String cleanWord = word;
      final punctuationRegex = RegExp(r'[.,!?;:]$');
      if (punctuationRegex.hasMatch(word)) {
        punctuation = word[word.length - 1];
        cleanWord = word.substring(0, word.length - 1);
      }

      String transliterated = await _transliterateWordWithCustom(cleanWord.toLowerCase());
      transliteratedWords.add(transliterated + punctuation);
    }

    return transliteratedWords.join(' ');
  }

  static Future<String> _transliterateWordWithCustom(String word) async {
    // First check user custom dictionary
    final userWord = await UserCustomDictionary.instance.getWord(word);
    if (userWord != null) {
      return userWord;
    }

    // Fall back to original service
    return ManglishService.transliterateToMalayalam(word);
  }

  static Future<List<String>> getAllSuggestions(String input) async {
    final suggestions = <String>[];
    
    // Get suggestions from original service
    suggestions.addAll(ManglishService.getSuggestions(input));
    
    // Get suggestions from user dictionary
    suggestions.addAll(await UserCustomDictionary.instance.getSuggestions(input));
    
    // Remove duplicates and sort
    final uniqueSuggestions = suggestions.toSet().toList();
    uniqueSuggestions.sort();
    
    return uniqueSuggestions;
  }

  static Future<void> addToUserDictionary(String manglish, String malayalam) async {
    await UserCustomDictionary.instance.addWord(manglish, malayalam);
  }

  static Future<void> removeFromUserDictionary(String manglish) async {
    await UserCustomDictionary.instance.removeWord(manglish);
  }

  static Future<bool> isInUserDictionary(String manglish) async {
    return await UserCustomDictionary.instance.hasWord(manglish);
  }

  static Future<Map<String, String>> getUserDictionary() async {
    return await UserCustomDictionary.instance.getAllWords();
  }

  static Future<void> clearUserDictionary() async {
    await UserCustomDictionary.instance.clearDictionary();
  }

  static Future<int> getUserDictionarySize() async {
    await UserCustomDictionary.instance._loadDictionary();
    return UserCustomDictionary.instance.wordCount;
  }
}

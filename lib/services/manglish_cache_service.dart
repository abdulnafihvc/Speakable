import 'dart:async';
import 'package:speakable/services/manglish_service.dart';

class ManglishCache {
  static final ManglishCache _instance = ManglishCache._internal();
  factory ManglishCache() => _instance;
  ManglishCache._internal();

  final Map<String, String> _malayalamToManglishCache = {};
  final Map<String, String> _manglishToMalayalamCache = {};
  final Map<String, bool> _isManglishCache = {};
  final Map<String, List<String>> _suggestionsCache = {};
  
  static const int _maxCacheSize = 1000;
  static const Duration _cacheExpiry = Duration(hours: 1);
  
  Timer? _cleanupTimer;

  void _startCleanupTimer() {
    _cleanupTimer?.cancel();
    _cleanupTimer = Timer.periodic(Duration(minutes: 30), (_) => _cleanupOldEntries());
  }

  void _cleanupOldEntries() {
    // Simple LRU-like cleanup - remove oldest entries if cache is too large
    if (_malayalamToManglishCache.length > _maxCacheSize) {
      final keysToRemove = _malayalamToManglishCache.keys.take(100).toList();
      for (final key in keysToRemove) {
        _malayalamToManglishCache.remove(key);
      }
    }
    
    if (_manglishToMalayalamCache.length > _maxCacheSize) {
      final keysToRemove = _manglishToMalayalamCache.keys.take(100).toList();
      for (final key in keysToRemove) {
        _manglishToMalayalamCache.remove(key);
      }
    }
    
    if (_isManglishCache.length > _maxCacheSize) {
      final keysToRemove = _isManglishCache.keys.take(100).toList();
      for (final key in keysToRemove) {
        _isManglishCache.remove(key);
      }
    }
  }

  String? getCachedMalayalamToManglish(String input) {
    return _malayalamToManglishCache[input];
  }

  void cacheMalayalamToManglish(String input, String result) {
    _malayalamToManglishCache[input] = result;
    _startCleanupTimer();
  }

  String? getCachedManglishToMalayalam(String input) {
    return _manglishToMalayalamCache[input];
  }

  void cacheManglishToMalayalam(String input, String result) {
    _manglishToMalayalamCache[input] = result;
    _startCleanupTimer();
  }

  bool? getCachedIsManglish(String input) {
    return _isManglishCache[input];
  }

  void cacheIsManglish(String input, bool result) {
    _isManglishCache[input] = result;
    _startCleanupTimer();
  }

  List<String>? getCachedSuggestions(String input) {
    return _suggestionsCache[input];
  }

  void cacheSuggestions(String input, List<String> result) {
    _suggestionsCache[input] = result;
    _startCleanupTimer();
  }

  void clearCache() {
    _malayalamToManglishCache.clear();
    _manglishToMalayalamCache.clear();
    _isManglishCache.clear();
    _suggestionsCache.clear();
    _cleanupTimer?.cancel();
  }

  Map<String, int> getCacheStats() {
    return {
      'malayalamToManglish': _malayalamToManglishCache.length,
      'manglishToMalayalam': _manglishToMalayalamCache.length,
      'isManglish': _isManglishCache.length,
      'suggestions': _suggestionsCache.length,
    };
  }
}

class OptimizedManglishService {
  static final ManglishCache _cache = ManglishCache();

  static String transliterateToManglish(String malayalamText) {
    if (malayalamText.isEmpty) return malayalamText;

    // Check cache first
    final cached = _cache.getCachedMalayalamToManglish(malayalamText);
    if (cached != null) return cached;

    // Process in chunks for large texts
    if (malayalamText.length > 500) {
      return _processLargeText(malayalamText, _transliterateChunkToManglish);
    }

    final result = ManglishService.transliterateToManglish(malayalamText);
    _cache.cacheMalayalamToManglish(malayalamText, result);
    return result;
  }

  static String transliterateToMalayalam(String manglishText) {
    if (manglishText.isEmpty) return manglishText;

    // Check cache first
    final cached = _cache.getCachedManglishToMalayalam(manglishText);
    if (cached != null) return cached;

    // Process in chunks for large texts
    if (manglishText.length > 500) {
      return _processLargeText(manglishText, _transliterateChunkToMalayalam);
    }

    final result = ManglishService.transliterateToMalayalam(manglishText);
    _cache.cacheManglishToMalayalam(manglishText, result);
    return result;
  }

  static bool isManglish(String text) {
    if (text.isEmpty) return false;

    // Check cache first
    final cached = _cache.getCachedIsManglish(text);
    if (cached != null) return cached;

    final result = ManglishService.isManglish(text);
    _cache.cacheIsManglish(text, result);
    return result;
  }

  static List<String> getSuggestions(String input) {
    if (input.isEmpty) return [];

    // Check cache first
    final cached = _cache.getCachedSuggestions(input);
    if (cached != null) return cached;

    final result = ManglishService.getSuggestions(input);
    _cache.cacheSuggestions(input, result);
    return result;
  }

  static String _processLargeText(String text, String Function(String) processor) {
    // Split by sentences to maintain context
    final sentences = text.split(RegExp(r'[.!?]+'));
    final results = <String>[];
    
    for (int i = 0; i < sentences.length; i++) {
      String sentence = sentences[i].trim();
      if (sentence.isNotEmpty) {
        // Add back punctuation if it was removed
        if (i < sentences.length - 1) {
          final punctuationMatch = RegExp(r'[.!?]+$').firstMatch(text.substring(0, text.indexOf(sentence) + sentence.length + 5));
          if (punctuationMatch != null) {
            sentence += punctuationMatch.group(0)!;
          }
        }
        results.add(processor(sentence));
      }
    }
    
    return results.join(' ');
  }

  static String _transliterateChunkToManglish(String chunk) {
    return ManglishService.transliterateToManglish(chunk);
  }

  static String _transliterateChunkToMalayalam(String chunk) {
    return ManglishService.transliterateToMalayalam(chunk);
  }

  static void clearCache() {
    _cache.clearCache();
  }

  static Map<String, int> getCacheStats() {
    return _cache.getCacheStats();
  }
}

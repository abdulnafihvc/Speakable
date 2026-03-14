import 'package:shared_preferences/shared_preferences.dart';
import 'storage_service_interface.dart';

/// SharedPreferences implementation of StorageService
/// Used for lightweight key-value storage (strings, ints, bools, etc.)
class SharedPrefsService implements StorageServiceInterface {
  late SharedPreferences _prefs;

  @override
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  Future<void> save<T>(String key, T value) async {
    if (value is String) {
      await _prefs.setString(key, value);
    } else if (value is int) {
      await _prefs.setInt(key, value);
    } else if (value is double) {
      await _prefs.setDouble(key, value);
    } else if (value is bool) {
      await _prefs.setBool(key, value);
    } else if (value is List<String>) {
      await _prefs.setStringList(key, value);
    } else {
      throw UnsupportedError(
        'Type ${T.toString()} is not supported by SharedPreferences. '
        'Use HiveStorageService for complex types.',
      );
    }
  }

  @override
  T? get<T>(String key) {
    final value = _prefs.get(key);
    return value as T?;
  }

  /// Get string value
  String? getString(String key) => _prefs.getString(key);

  /// Get int value
  int? getInt(String key) => _prefs.getInt(key);

  /// Get double value
  double? getDouble(String key) => _prefs.getDouble(key);

  /// Get bool value
  bool? getBool(String key) => _prefs.getBool(key);

  /// Get string list value
  List<String>? getStringList(String key) => _prefs.getStringList(key);

  /// Save string value
  Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  /// Save int value
  Future<void> setInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  /// Save double value
  Future<void> setDouble(String key, double value) async {
    await _prefs.setDouble(key, value);
  }

  /// Save bool value
  Future<void> setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  /// Save string list value
  Future<void> setStringList(String key, List<String> value) async {
    await _prefs.setStringList(key, value);
  }

  @override
  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  @override
  Future<void> clear() async {
    await _prefs.clear();
  }

  @override
  bool containsKey(String key) {
    return _prefs.containsKey(key);
  }

  @override
  List<String> getAllKeys() {
    return _prefs.getKeys().toList();
  }

  @override
  Future<void> close() async {
    // SharedPreferences doesn't need explicit closing
  }
}

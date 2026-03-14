/// Abstract interface for storage operations
/// This allows for different storage implementations (Hive, SharedPreferences, etc.)
abstract class StorageServiceInterface {
  /// Initialize the storage service
  Future<void> init();

  /// Save data with a key
  Future<void> save<T>(String key, T value);

  /// Get data by key
  T? get<T>(String key);

  /// Remove data by key
  Future<void> remove(String key);

  /// Clear all data
  Future<void> clear();

  /// Check if key exists
  bool containsKey(String key);

  /// Get all keys
  List<String> getAllKeys();

  /// Close the storage service
  Future<void> close();
}

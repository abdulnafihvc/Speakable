import 'package:hive_flutter/hive_flutter.dart';
import 'storage_service_interface.dart';

/// Hive implementation of StorageService
/// Used for complex data with type adapters
class HiveStorageService implements StorageServiceInterface {
  late Box _box;
  final String boxName;

  HiveStorageService({this.boxName = 'app_storage'});

  @override
  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(boxName);
  }

  @override
  Future<void> save<T>(String key, T value) async {
    await _box.put(key, value);
  }

  @override
  T? get<T>(String key) {
    return _box.get(key) as T?;
  }

  @override
  Future<void> remove(String key) async {
    await _box.delete(key);
  }

  @override
  Future<void> clear() async {
    await _box.clear();
  }

  @override
  bool containsKey(String key) {
    return _box.containsKey(key);
  }

  @override
  List<String> getAllKeys() {
    return _box.keys.cast<String>().toList();
  }

  @override
  Future<void> close() async {
    await _box.close();
  }

  /// Get the raw Hive box for advanced operations
  Box get box => _box;

  /// Register a Hive type adapter
  static void registerAdapter<T>(TypeAdapter<T> adapter) {
    if (!Hive.isAdapterRegistered(adapter.typeId)) {
      Hive.registerAdapter(adapter);
    }
  }

  /// Open a typed box for specific models
  static Future<Box<T>> openTypedBox<T>(String name) async {
    return await Hive.openBox<T>(name);
  }
}

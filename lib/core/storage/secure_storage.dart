import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Абстракция над платформенным secure storage (удобно подменять в тестах).
abstract interface class SecureStorage {
  Future<void> write({required String key, required String? value});
  Future<String?> read({required String key});
  Future<void> delete({required String key});
  Future<void> deleteAll();
}

final class FlutterSecureStorageAdapter implements SecureStorage {
  FlutterSecureStorageAdapter(this._inner);

  final FlutterSecureStorage _inner;

  @override
  Future<void> delete({required String key}) => _inner.delete(key: key);

  @override
  Future<void> deleteAll() => _inner.deleteAll();

  @override
  Future<String?> read({required String key}) => _inner.read(key: key);

  @override
  Future<void> write({required String key, required String? value}) async {
    if (value == null || value.isEmpty) {
      await _inner.delete(key: key);
    } else {
      await _inner.write(key: key, value: value);
    }
  }
}

/// In-memory реализация для unit/widget-тестов.
final class InMemorySecureStorage implements SecureStorage {
  final Map<String, String> _store = {};

  @override
  Future<void> delete({required String key}) async {
    _store.remove(key);
  }

  @override
  Future<void> deleteAll() async {
    _store.clear();
  }

  @override
  Future<String?> read({required String key}) async => _store[key];

  @override
  Future<void> write({required String key, required String? value}) async {
    if (value == null || value.isEmpty) {
      _store.remove(key);
    } else {
      _store[key] = value;
    }
  }
}

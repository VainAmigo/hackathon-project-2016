import 'preferences_keys.dart';
import 'preferences_service.dart';
import 'secure_storage.dart';

class PreferencesServiceImpl implements PreferencesService {
  PreferencesServiceImpl({required SecureStorage secureStorage})
      : _secure = secureStorage;

  final SecureStorage _secure;

  @override
  Future<void> saveAccessToken(String? token) async {
    await _secure.write(key: PreferencesKeys.accessToken, value: token);
  }

  @override
  Future<String?> getAccessToken() =>
      _secure.read(key: PreferencesKeys.accessToken);

  @override
  Future<void> saveRefreshToken(String? token) async {
    await _secure.write(key: PreferencesKeys.refreshToken, value: token);
  }

  @override
  Future<String?> getRefreshToken() =>
      _secure.read(key: PreferencesKeys.refreshToken);

  @override
  Future<void> clearSession() => _secure.deleteAll();
}

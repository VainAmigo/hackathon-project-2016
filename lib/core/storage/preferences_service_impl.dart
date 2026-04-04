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
  Future<void> saveAuthProfile({
    required String username,
    required String role,
  }) async {
    await _secure.write(key: PreferencesKeys.authUsername, value: username);
    await _secure.write(key: PreferencesKeys.authRole, value: role);
  }

  @override
  Future<String?> getStoredUsername() =>
      _secure.read(key: PreferencesKeys.authUsername);

  @override
  Future<String?> getStoredRole() => _secure.read(key: PreferencesKeys.authRole);

  @override
  Future<void> clearSession() => _secure.deleteAll();
}

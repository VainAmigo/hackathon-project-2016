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
    required String email,
    required String role,
  }) async {
    await _secure.write(key: PreferencesKeys.authEmail, value: email);
    await _secure.write(key: PreferencesKeys.authRole, value: role);
  }

  @override
  Future<String?> getStoredEmail() async {
    final v = await _secure.read(key: PreferencesKeys.authEmail);
    if (v != null && v.isNotEmpty) return v;
    return _secure.read(key: PreferencesKeys.authUsernameLegacy);
  }

  @override
  Future<String?> getStoredRole() =>
      _secure.read(key: PreferencesKeys.authRole);

  @override
  Future<void> clearSession() => _secure.deleteAll();
}

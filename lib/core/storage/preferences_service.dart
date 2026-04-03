/// Только токены (secure storage).
abstract class PreferencesService {
  Future<void> saveAccessToken(String? token);
  Future<String?> getAccessToken();

  Future<void> saveRefreshToken(String? token);
  Future<String?> getRefreshToken();

  Future<void> clearSession();
}

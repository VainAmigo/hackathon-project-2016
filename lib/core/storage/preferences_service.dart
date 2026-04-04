/// Токены и кэш профиля для cold start (secure storage).
abstract class PreferencesService {
  Future<void> saveAccessToken(String? token);
  Future<String?> getAccessToken();

  Future<void> saveRefreshToken(String? token);
  Future<String?> getRefreshToken();

  Future<void> saveAuthProfile({required String username, required String role});
  Future<String?> getStoredUsername();
  Future<String?> getStoredRole();

  Future<void> clearSession();
}

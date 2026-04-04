/// Токены и кэш профиля для cold start (secure storage).
abstract class PreferencesService {
  Future<void> saveAccessToken(String? token);
  Future<String?> getAccessToken();

  Future<void> saveRefreshToken(String? token);
  Future<String?> getRefreshToken();

  Future<void> saveAuthProfile({required String email, required String role});
  Future<String?> getStoredEmail();
  Future<String?> getStoredRole();

  Future<void> clearSession();
}

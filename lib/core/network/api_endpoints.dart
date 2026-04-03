/// Базовый URL API. Переопределение: `--dart-define=API_BASE_URL=http://10.0.2.2:7007/api/v1`
/// (10.0.2.2 — хост-машина с Android-эмулятора).
abstract final class ApiConfig {
  static const baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://mapi.agi.kg/',
  );
}

abstract final class ApiEndpoints {
  static const login = 'api/v1/auth/login';
  static const userProfile = 'api/v1/user/profile';
}

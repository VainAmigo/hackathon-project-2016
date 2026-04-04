/// Базовый URL API. Переопределение: `--dart-define=API_BASE_URL=http://host:port`
abstract final class ApiConfig {
  static const baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://54.147.49.220:8081',
  );
}

abstract final class ApiEndpoints {
  static const login = '/api/auth/login';
  static const register = '/api/auth/register';
  static const refresh = '/api/auth/refresh';
  static const logout = '/api/auth/logout';
}

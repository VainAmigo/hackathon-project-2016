/// Базовый URL API. Переопределение: `--dart-define=API_BASE_URL=http://host:port`
abstract final class ApiConfig {
  static const baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://54.147.49.220:8080',
  );
}

abstract final class ApiEndpoints {
  static const login = '/api/v1/auth/login';
  static const register = '/api/v1/auth/register';
  static const refresh = '/api/v1/auth/refresh';
  static const logout = '/api/v1/auth/logout';

  static const upload = '/api/upload';
  static const confirm = '/api/v1/confirm';

  static const persons = '/api/v1/persons';

  static const chats = '/api/v1/chats';

  static String chatPath(int chatId) => '/api/v1/chats/$chatId';

  static String chatMessagesPath(int chatId) => '/api/v1/chats/$chatId/messages';

  static const filesPrefix = '/api/v1/files';

  /// [kind] — `images` или `files`; [resourceName] — имя ресурса (как в ответе API).
  static String filesResourcePath(String kind, String resourceName) {
    final encoded = Uri.encodeComponent(resourceName);
    return '$filesPrefix/$kind/$encoded';
  }
}

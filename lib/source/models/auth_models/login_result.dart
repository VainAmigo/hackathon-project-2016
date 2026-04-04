import 'package:project_temp/source/models/models.dart';

Map<String, dynamic> _unwrapData(Map<String, dynamic> json) {
  if (json['data'] is Map<String, dynamic>) {
    return json['data'] as Map<String, dynamic>;
  }
  return json;
}

/// Ответ POST /api/auth/login: токены и профиль в одном JSON.
class LoginResult {
  const LoginResult({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  final String accessToken;
  final String refreshToken;
  final User user;

  factory LoginResult.fromJson(Map<String, dynamic> json) {
    final data = _unwrapData(json);
    final access = (data['accessToken'] ??
            data['access_token'] ??
            data['token'] ??
            '')
        .toString();
    final refresh = (data['refreshToken'] ?? data['refresh_token'] ?? '')
        .toString();
    final username = (data['username'] ?? '').toString().trim();
    final role = (data['role'] ?? '').toString();
    if (username.isEmpty) {
      throw const FormatException('Ответ входа: нет username');
    }
    return LoginResult(
      accessToken: access,
      refreshToken: refresh,
      user: User(username: username, role: role),
    );
  }
}

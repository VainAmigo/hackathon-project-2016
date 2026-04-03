import 'package:project_temp/source/models/models.dart';

Map<String, dynamic> _normalizeLoginJson(Map<String, dynamic> json) {
  final data = json['data'] is Map<String, dynamic>
      ? json['data'] as Map<String, dynamic>
      : json;

  final userRaw = data['user'] as Map<String, dynamic>? ??
      json['user'] as Map<String, dynamic>?;

  if (userRaw == null) {
    throw FormatException('Ответ входа: нет поля user');
  }

  final token = data['token'] ?? data['access_token'] ?? data['accessToken'] ?? '';
  final refresh =
      data['refreshToken'] ?? data['refresh_token'] ?? '';

  return <String, dynamic>{
    'token': token is String ? token : token.toString(),
    'refreshToken': refresh is String ? refresh : refresh.toString(),
    'user': userRaw,
  };
}

/// Результат успешного входа: токены и пользователь из одного ответа API.
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
    final n = _normalizeLoginJson(json);
    return LoginResult(
      accessToken: (n['token'] ?? '').toString(),
      refreshToken: (n['refreshToken'] ?? '').toString(),
      user: User.fromJson(n['user'] as Map<String, dynamic>),
    );
  }
}

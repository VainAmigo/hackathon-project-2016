import 'package:project_temp/source/models/models.dart';

Map<String, dynamic> _unwrapData(Map<String, dynamic> json) {
  if (json['data'] is Map<String, dynamic>) {
    return json['data'] as Map<String, dynamic>;
  }
  if (json['result'] is Map<String, dynamic>) {
    return json['result'] as Map<String, dynamic>;
  }
  return json;
}

/// Пустая строка и null считаются «нет значения» — иначе `email: ""` блокирует fallback на `username`.
String? _nonEmptyString(dynamic v) {
  if (v == null) return null;
  final s = v.toString().trim();
  if (s.isEmpty || s == 'null') return null;
  return s;
}

String? _firstLoginIdentity(Map<String, dynamic> map) {
  const keys = [
    'email',
    'username',
    'userEmail',
    'userName',
    'user_name',
    'login',
  ];
  for (final k in keys) {
    final s = _nonEmptyString(map[k]);
    if (s != null) return s;
  }
  return null;
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
    final nested = data['user'];
    final Map<String, dynamic> profile = nested is Map<String, dynamic>
        ? Map<String, dynamic>.from(nested)
        : data;
    // Сначала вложенный user, затем корень ответа (почта часто только в username).
    final email = _firstLoginIdentity(profile) ?? _firstLoginIdentity(data) ?? '';
    final role = (profile['role'] ?? data['role'] ?? data['password'] ?? '')
        .toString();
    if (email.isEmpty) {
      throw const FormatException(
        'Ответ входа: нет email/username (пустые или отсутствуют поля)',
      );
    }
    return LoginResult(
      accessToken: access,
      refreshToken: refresh,
      user: User(email: email, role: role),
    );
  }
}

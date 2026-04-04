/// Ответ POST /api/auth/register (без токенов).
class RegisterResult {
  const RegisterResult({
    required this.username,
    required this.role,
  });

  final String username;
  final String role;

  factory RegisterResult.fromJson(Map<String, dynamic> json) {
    return RegisterResult(
      username: (json['username'] ?? '').toString().trim(),
      role: (json['role'] ?? '').toString(),
    );
  }
}

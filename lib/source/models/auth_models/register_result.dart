/// Ответ POST /api/auth/register (без токенов).
class RegisterResult {
  const RegisterResult({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  factory RegisterResult.fromJson(Map<String, dynamic> json) {
    return RegisterResult(
      email: (json['email'] ?? '').toString().trim(),
      password: (json['password'] ?? '').toString().trim(),
    );
  }
}

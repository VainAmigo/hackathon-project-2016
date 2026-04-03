import 'package:project_temp/core/core.dart';

/// Правила ввода для форм auth (без зависимости от Cubit).
abstract final class AuthValidators {
  AuthValidators._();

  static String? email(AppLocalizations l10n, String? v) {
    final s = v?.trim() ?? '';
    if (s.isEmpty) return l10n.authEmailRequired;
    if (!_email.hasMatch(s)) return l10n.authEmailInvalid;
    return null;
  }

  static String? password(AppLocalizations l10n, String? v) {
    if (v == null || v.isEmpty) return l10n.authPasswordRequired;
    if (v.length < minPasswordLength) return l10n.authPasswordTooShort;
    return null;
  }

  static String? confirmPassword(
    AppLocalizations l10n,
    String? v,
    String password,
  ) {
    if (v == null || v.isEmpty) return l10n.authPasswordRequired;
    if (v != password) return l10n.authConfirmMismatch;
    return null;
  }

  static const int minPasswordLength = 8;

  static final RegExp _email = RegExp(r'^[\w.+-]+@[\w.-]+\.\w{2,}$');
}

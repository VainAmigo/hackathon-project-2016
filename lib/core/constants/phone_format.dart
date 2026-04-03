/// Номер для API: код КР +996 и 9 цифр абонента.
abstract final class PhoneFormat {
  static const prefix = '+996';
  static const nationalDigits = 9;
  static const fullLength = prefix.length + nationalDigits; // +996 + 9 = 13

  /// Строгий вид: `+996XXXXXXXXX`.
  static final fullPattern = RegExp(r'^\+996\d{9}$');

  /// Отображение: `+996` + 9 цифр.
  static String buildFull(String nineDigits) => '$prefix$nineDigits';

  /// Для тела запроса API — без `+`, например `996XXXXXXXXX`.
  static String buildForRequest(String nineDigits) =>
      '${prefix.substring(1)}$nineDigits';

  static String? validateNineDigits(String? raw) {
    final digits = raw?.trim() ?? '';
    if (digits.isEmpty) return 'Введите 9 цифр номера';
    if (!RegExp(r'^\d{9}$').hasMatch(digits)) {
      return 'Нужно ровно 9 цифр после +996';
    }
    return null;
  }

  static String? validateFull(String? raw) {
    final s = raw?.trim() ?? '';
    if (s.isEmpty) return 'Укажите номер телефона';
    if (!fullPattern.hasMatch(s)) {
      return 'Формат: +996 и 9 цифр (+996XXXXXXXXX)';
    }
    return null;
  }
}

import 'package:shared_preferences/shared_preferences.dart';

/// Сохранение выбранного языка интерфейса между запусками.
class LocalePreferences {
  LocalePreferences(this._prefs);

  final SharedPreferences _prefs;

  static const _key = 'app_language_code';

  String? readLanguageCode() => _prefs.getString(_key);

  Future<void> saveLanguageCode(String code) =>
      _prefs.setString(_key, code);
}

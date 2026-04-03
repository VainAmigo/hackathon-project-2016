import 'package:flutter/material.dart';

/// Поддерживаемые коды интерфейса (кнопка переключает по кругу).
enum AppLanguageCode {
  en,
  ky,
  ru,
  tr,
}

extension AppLanguageCodeX on AppLanguageCode {
  String get uiLabel => switch (this) {
        AppLanguageCode.en => 'EN',
        AppLanguageCode.ky => 'KY',
        AppLanguageCode.ru => 'RU',
        AppLanguageCode.tr => 'TR',
      };

  Locale get locale => Locale(name);
}

/// Состояние выбранной локали для [MaterialApp.locale] и UI.
class AppLocaleController extends ChangeNotifier {
  AppLocaleController();

  AppLanguageCode _code = AppLanguageCode.en;

  AppLanguageCode get code => _code;

  Locale get locale => _code.locale;

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('ky'),
    Locale('ru'),
    Locale('tr'),
  ];

  void cycle() {
    const all = AppLanguageCode.values;
    _code = all[(all.indexOf(_code) + 1) % all.length];
    notifyListeners();
  }

  void setCode(AppLanguageCode value) {
    if (_code == value) return;
    _code = value;
    notifyListeners();
  }
}

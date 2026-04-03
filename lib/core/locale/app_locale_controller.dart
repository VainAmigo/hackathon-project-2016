import 'dart:async';

import 'package:flutter/material.dart';
import 'package:project_temp/core/locale/locale_preferences.dart';
import 'package:project_temp/l10n/app_localizations.dart';

/// Разбор значения из хранилища (имя enum: en, ru, ky, tr).
AppLanguageCode? parseSavedLanguageCode(String? raw) {
  if (raw == null || raw.isEmpty) return null;
  for (final v in AppLanguageCode.values) {
    if (v.name == raw) return v;
  }
  return null;
}

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
  AppLocaleController({
    required LocalePreferences localePreferences,
    AppLanguageCode? initialCode,
  })  : _localePreferences = localePreferences,
        _code = initialCode ?? AppLanguageCode.en;

  final LocalePreferences _localePreferences;

  AppLanguageCode _code;

  AppLanguageCode get code => _code;

  Locale get locale => _code.locale;

  static List<Locale> get supportedLocales => AppLocalizations.supportedLocales;

  void _persist() {
    unawaited(_localePreferences.saveLanguageCode(_code.name));
  }

  void cycle() {
    const all = AppLanguageCode.values;
    _code = all[(all.indexOf(_code) + 1) % all.length];
    notifyListeners();
    _persist();
  }

  void setCode(AppLanguageCode value) {
    if (_code == value) return;
    _code = value;
    notifyListeners();
    _persist();
  }
}

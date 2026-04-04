import 'package:flutter/widgets.dart';
import 'package:project_temp/l10n/app_localizations.dart';

/// Доступ к строкам [AppLocalizations] из [BuildContext].
///
/// Нужны [AppLocalizations.delegate] в [MaterialApp.localizationsDelegates]
/// и [MaterialApp.locale] (например [AppLocaleController]).
extension AppLocalizationContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

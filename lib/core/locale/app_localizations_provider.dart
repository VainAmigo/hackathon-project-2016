import 'package:flutter/widgets.dart';
import 'package:project_temp/l10n/app_localizations.dart';

/// Доступ к сгенерированным строкам [AppLocalizations] из [BuildContext].
///
/// Требует [AppLocalizations.delegate] в [MaterialApp.localizationsDelegates]
/// и обновляемый [MaterialApp.locale] (например через [AppLocaleController]).
extension AppLocalizationContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

import 'package:project_temp/core/locale/app_locale_controller.dart';

/// Числовой `language` для API persons v1 (как в POST `/api/v1/persons`): en=0, ky=1, ru=2, tr=3.
///
/// GET `/api/v1/persons/{id}` ожидает это же значение в query; строка `ru` не подставляется → id 0.
int personsV1LanguageIndex(String localeKey) {
  final k = localeKey.toLowerCase().trim();
  for (final v in AppLanguageCode.values) {
    if (v.name == k) return v.index;
  }
  return AppLanguageCode.en.index;
}

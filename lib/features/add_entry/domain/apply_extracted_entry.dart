import 'package:flutter/material.dart';
import 'package:project_temp/core/locale/app_locale_controller.dart';
import 'package:project_temp/source/source.dart';

/// Редактирование при `type: single` (или тип не указан) и непустом `result`; при `plural` — только кнопка закрытия.
bool importExtractAllowsEditing(EntryMlResponse? ml) {
  if (ml == null || ml.byLocale.isEmpty) return false;
  final t = (ml.type ?? '').toLowerCase();
  if (t == 'plural') return false;
  return t == 'single' || t.isEmpty;
}

/// Порядок вкладок языка: ky → ru → en → tr, остальные по алфавиту.
List<String> sortedImportLocaleKeys(Map<String, EntryExtractedFields> byLocale) {
  const order = ['ky', 'ru', 'en', 'tr'];
  final keys = byLocale.keys.toList();
  keys.sort((a, b) {
    final ai = order.indexOf(a.toLowerCase());
    final bi = order.indexOf(b.toLowerCase());
    if (ai == -1 && bi == -1) return a.compareTo(b);
    if (ai == -1) return 1;
    if (bi == -1) return -1;
    return ai.compareTo(bi);
  });
  return keys;
}

String pickInitialImportLocaleKey(
  Map<String, EntryExtractedFields> byLocale,
  AppLanguageCode ui,
) {
  final sorted = sortedImportLocaleKeys(byLocale);
  if (sorted.isEmpty) return 'en';
  for (final k in sorted) {
    if (k.toLowerCase() == ui.name) return k;
  }
  return sorted.first;
}

EntryExtractedFields? pickExtractedForLocale(
  EntryMlResponse? ml,
  AppLanguageCode code,
) {
  if (ml == null || ml.byLocale.isEmpty) return null;
  final order = <String>[
    code.name,
    'en',
    'ru',
    'ky',
    'tr',
    ...ml.byLocale.keys,
  ];
  final seen = <String>{};
  for (final k in order) {
    if (seen.add(k) && ml.byLocale.containsKey(k)) {
      return ml.byLocale[k];
    }
  }
  return ml.byLocale.values.first;
}

void _setYear(TextEditingController c, int? year, String? isoDate) {
  if (year != null) {
    c.text = year.toString();
    return;
  }
  if (isoDate != null && isoDate.length >= 4) {
    final y = int.tryParse(isoDate.substring(0, 4));
    if (y != null) c.text = y.toString();
  } else {
    c.clear();
  }
}

/// Заполняет поля ручной формы из выбранной локали ответа ML.
void applyExtractedToManualForm({
  required EntryExtractedFields? fields,
  required TextEditingController fullName,
  required TextEditingController accusation,
  required TextEditingController yearFrom,
  required TextEditingController yearTo,
  required TextEditingController punishment,
  required TextEditingController region,
  required TextEditingController punishmentDate,
  required TextEditingController occupation,
  required TextEditingController rehabDate,
  required TextEditingController biography,
}) {
  if (fields == null) return;

  fullName.text = fields.fullName ?? '';
  accusation.text = fields.charge ?? '';
  _setYear(yearFrom, fields.birthYear, fields.birthDate);
  _setYear(yearTo, fields.deathYear, fields.deathDate);

  punishment.text = fields.sentence ?? '';

  final regionParts = <String>[
    if (fields.region != null && fields.region!.trim().isNotEmpty)
      fields.region!.trim(),
    if (fields.district != null && fields.district!.trim().isNotEmpty)
      fields.district!.trim(),
  ];
  region.text = regionParts.join(', ');

  punishmentDate.text = fields.sentenceDate ?? fields.arrestDate ?? '';

  occupation.text = fields.occupation ?? '';
  rehabDate.text = fields.rehabilitationDate ?? '';

  final bio = StringBuffer(fields.biography ?? '');
  if (fields.birthPlace != null && fields.birthPlace!.trim().isNotEmpty) {
    if (bio.isNotEmpty) bio.writeln();
    bio.write(fields.birthPlace);
  }
  if (fields.deathPlace != null && fields.deathPlace!.trim().isNotEmpty) {
    if (bio.isNotEmpty) bio.writeln();
    bio.write(fields.deathPlace);
  }
  biography.text = bio.toString().trim();
}

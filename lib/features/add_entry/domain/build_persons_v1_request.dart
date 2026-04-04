import 'package:project_temp/core/locale/app_locale_controller.dart';
import 'package:project_temp/features/add_entry/domain/build_person_confirm_payload.dart';
import 'package:project_temp/source/source.dart';

/// Индекс языка контента для API (порядок как у [AppLanguageCode]: en, ky, ru, tr).
int personsV1LanguageFromContentLocaleKey(String key) {
  final k = key.toLowerCase().trim();
  for (final v in AppLanguageCode.values) {
    if (v.name == k) return v.index;
  }
  return AppLanguageCode.en.index;
}

void _putString(Map<String, dynamic> m, String key, String? value) {
  if (value == null) return;
  final t = value.trim();
  if (t.isEmpty) return;
  m[key] = t;
}

void _putInt(Map<String, dynamic> m, String key, int? value) {
  if (value == null) return;
  m[key] = value;
}

/// Тело `request` для POST `/api/v1/persons` (только camelCase).
Map<String, dynamic> buildPersonsV1Request({
  required int documentId,
  /// Код локали из ответа импорта: en / ky / ru / tr.
  required String contentLocaleKey,
  required String fullName,
  required String accusation,
  required String yearFrom,
  required String yearTo,
  required String punishment,
  required String regionLine,
  required String punishmentDate,
  required String occupation,
  required String rehabDate,
  required String biography,
  EntryExtractedFields? ruBaseline,
}) {
  final ru = ruBaseline;

  String pickStr(String form, String? fallback) {
    final t = form.trim();
    if (t.isNotEmpty) return t;
    return (fallback ?? '').trim();
  }

  int? pickYear(String form, int? fallback) {
    final y = int.tryParse(form.trim());
    if (y != null) return y;
    return fallback;
  }

  var fn = pickStr(fullName, ru?.fullName).trim();
  fn = fn.replaceAll(RegExp(r'\s+'), ' ').toLowerCase();

  String ruRegionFallback() {
    if (ru == null) return '';
    final r = ru.region?.trim() ?? '';
    final d = ru.district?.trim() ?? '';
    if (r.isEmpty && d.isEmpty) return '';
    if (d.isEmpty) return r;
    return '$r, $d';
  }

  final regLine = pickStr(regionLine, ruRegionFallback());
  final (reg, dist) = splitRegionLine(regLine);

  final pd = pickStr(punishmentDate, ru?.arrestDate);
  final sentence = pickStr(punishment, ru?.sentence);
  final occ = pickStr(occupation, ru?.occupation);
  final charge = pickStr(accusation, ru?.charge);
  final bio = pickStr(biography, ru?.biography);
  final rd = pickStr(rehabDate, ru?.rehabilitationDate);

  final birthYear = pickYear(yearFrom, ru?.birthYear);
  final deathYear = pickYear(yearTo, ru?.deathYear);

  final arrestDateStr = pd.isNotEmpty ? pd : null;
  String? sentenceDateStr;
  final ruSentence = ru?.sentenceDate?.trim();
  if (ruSentence != null && ruSentence.isNotEmpty) {
    sentenceDateStr = ruSentence;
  } else if (pd.isNotEmpty) {
    sentenceDateStr = pd;
  }

  final m = <String, dynamic>{
    'documentId': documentId,
    'language': personsV1LanguageFromContentLocaleKey(contentLocaleKey),
    'fullName': fn,
  };

  _putInt(m, 'birthYear', birthYear);
  _putInt(m, 'deathYear', deathYear);
  _putString(m, 'birthDate', ru?.birthDate);
  _putString(m, 'deathDate', ru?.deathDate);
  _putString(m, 'arrestDate', arrestDateStr);
  _putString(m, 'sentenceDate', sentenceDateStr);
  _putString(m, 'rehabilitationDate', rd.isNotEmpty ? rd : null);
  _putString(m, 'birthPlace', ru?.birthPlace);
  _putString(m, 'deathPlace', ru?.deathPlace);
  _putString(m, 'region', reg);
  _putString(m, 'district', dist);
  _putString(m, 'occupation', occ.isNotEmpty ? occ : null);
  _putString(m, 'charge', charge.isNotEmpty ? charge : null);
  _putString(m, 'sentence', sentence.isNotEmpty ? sentence : null);
  _putString(m, 'biography', bio.isNotEmpty ? bio : null);

  return m;
}

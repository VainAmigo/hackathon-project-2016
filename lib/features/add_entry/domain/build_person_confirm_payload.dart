import 'package:project_temp/source/source.dart';

/// Делит строку «область, район» на регион и район.
(String? region, String? district) splitRegionLine(String line) {
  final parts = line
      .split(',')
      .map((s) => s.trim())
      .where((s) => s.isNotEmpty)
      .toList();
  if (parts.isEmpty) return (null, null);
  if (parts.length == 1) return (parts.first, null);
  return (parts.first, parts.sublist(1).join(', '));
}

int? _yearFromDateOrYearField(String raw) {
  final t = raw.trim();
  if (t.isEmpty) return null;
  if (t.length >= 4) {
    final y = int.tryParse(t.substring(0, 4));
    if (y != null && y >= 1000 && y <= 9999) return y;
  }
  return int.tryParse(t);
}

String _pickStr(String form, String? ruFallback) {
  final t = form.trim();
  if (t.isNotEmpty) return t;
  return (ruFallback ?? '').trim();
}

int? _pickYear(String form, int? ruFallback) {
  final y = int.tryParse(form.trim());
  if (y != null) return y;
  return ruFallback;
}

/// JSON для `personData`: в `translations` для ru/ky/en/tr один набор — **русский**
/// эталон из [ruBaseline], поля формы перекрывают при непустом вводе.
Map<String, dynamic> buildPersonConfirmPayload({
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

  final fn = _pickStr(fullName, ru?.fullName);
  final ruNorm = ru?.normalizedName?.trim();
  final norm =
      (ruNorm != null && ruNorm.isNotEmpty) ? ruNorm : fn.toLowerCase();

  final birthYear = _pickYear(yearFrom, ru?.birthYear);
  final deathYear = _pickYear(yearTo, ru?.deathYear);

  String ruRegionFallback() {
    if (ru == null) return '';
    final r = ru.region?.trim() ?? '';
    final d = ru.district?.trim() ?? '';
    if (r.isEmpty && d.isEmpty) return '';
    if (d.isEmpty) return r;
    return '$r, $d';
  }

  final regLine = _pickStr(regionLine, ruRegionFallback());

  final (reg, dist) = splitRegionLine(regLine);

  final pd = _pickStr(punishmentDate, ru?.arrestDate);
  final sentence = _pickStr(punishment, ru?.sentence);
  final occ = _pickStr(occupation, ru?.occupation);
  final charge = _pickStr(accusation, ru?.charge);
  final bio = _pickStr(biography, ru?.biography);
  final rd = _pickStr(rehabDate, ru?.rehabilitationDate);

  final repressionYear = _yearFromDateOrYearField(pd) ??
      _yearFromDateOrYearField(rd) ??
      birthYear;

  Map<String, dynamic> translationSlice() => <String, dynamic>{
        'fullName': fn.isEmpty ? null : fn,
        'normalizedName': norm.isEmpty ? null : norm,
        'birthYear': birthYear,
        'deathYear': deathYear,
        'birthDate': ru?.birthDate,
        'deathDate': ru?.deathDate,
        'birthPlace': ru?.birthPlace,
        'deathPlace': ru?.deathPlace,
        'region': reg,
        'district': dist,
        'occupation': occ.isEmpty ? null : occ,
        'charge': charge.isEmpty ? null : charge,
        'arrestDate': pd.isEmpty ? null : pd,
        'sentence': sentence.isEmpty ? null : sentence,
        'sentenceDate': ru?.sentenceDate ?? (pd.isEmpty ? null : pd),
        'rehabilitationDate': rd.isEmpty ? null : rd,
        'biography': bio.isEmpty ? null : bio,
      };

  final slice = translationSlice();
  final translations = <String, Map<String, dynamic>>{
    for (final code in const ['ru', 'ky', 'en', 'tr'])
      code: Map<String, dynamic>.from(slice),
  };

  return <String, dynamic>{
    'birthYear': birthYear,
    'deathYear': deathYear,
    'repressionYear': repressionYear,
    'translations': translations,
  };
}

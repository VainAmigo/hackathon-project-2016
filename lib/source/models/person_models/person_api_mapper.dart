import 'package:project_temp/core/core.dart';
import 'package:project_temp/source/models/person_models/archive_entry.dart';
import 'package:project_temp/source/models/person_models/archive_entry_source.dart';

class _Tr {
  const _Tr({
    required this.fullName,
    required this.birthPlace,
    required this.deathPlace,
    required this.region,
    required this.district,
    required this.occupation,
    required this.charge,
    required this.sentence,
    required this.biography,
  });

  final String fullName;
  final String birthPlace;
  final String deathPlace;
  final String region;
  final String district;
  final String occupation;
  final String charge;
  final String sentence;
  final String biography;

  static const empty = _Tr(
    fullName: '',
    birthPlace: '',
    deathPlace: '',
    region: '',
    district: '',
    occupation: '',
    charge: '',
    sentence: '',
    biography: '',
  );

  static _Tr pick(Object? raw) {
    if (raw is! Map) return empty;
    var best = empty;
    for (final e in raw.entries) {
      final v = e.value;
      if (v is! Map) continue;
      final m = Map<String, dynamic>.from(v);
      String s(String k) => m[k]?.toString().trim() ?? '';
      final t = _Tr(
        fullName: s('fullName'),
        birthPlace: s('birthPlace'),
        deathPlace: s('deathPlace'),
        region: s('region'),
        district: s('district'),
        occupation: s('occupation'),
        charge: s('charge'),
        sentence: s('sentence'),
        biography: s('biography'),
      );
      if (t.fullName.isNotEmpty) return t;
      if (best.fullName.isEmpty &&
          (t.birthPlace.isNotEmpty ||
              t.charge.isNotEmpty ||
              t.occupation.isNotEmpty ||
              t.biography.isNotEmpty)) {
        best = t;
      }
    }
    return best;
  }
}

abstract final class PersonApiMapper {
  static ArchiveEntry fromListItem(Map<String, dynamic> m) {
    return _fromShared(m, detail: false);
  }

  static ArchiveEntry fromDetail(Map<String, dynamic> m) {
    return _fromShared(m, detail: true);
  }

  static ArchiveEntry _fromShared(Map<String, dynamic> m, {required bool detail}) {
    final id = m['id']?.toString() ?? '';
    final imageName = m['imageName']?.toString();
    final birthRaw = m['birthDate']?.toString();
    final deathRaw = m['deathDate']?.toString();
    final birthCal = DateTime.tryParse(birthRaw ?? '');
    final deathCal = DateTime.tryParse(deathRaw ?? '');
    final birthY = m['birthYear'];
    final deathY = m['deathYear'];
    final birthYearStr = birthY is int
        ? '$birthY'
        : (birthY is num ? '${birthY.toInt()}' : '');
    final deathYearStr = deathY is int
        ? '$deathY'
        : (deathY is num ? '${deathY.toInt()}' : '');

    final t = _Tr.pick(m['translations']);

    final yearFrom = birthCal != null
        ? '${birthCal.year}'
        : (birthYearStr.isNotEmpty ? birthYearStr : '—');
    final yearTo = deathCal != null
        ? '${deathCal.year}'
        : (deathYearStr.isNotEmpty ? deathYearStr : '—');

    final rawImageName = imageName?.toString().trim();
    final portraitImageName =
        (rawImageName != null && rawImageName.isNotEmpty) ? rawImageName : null;

    final charge = t.charge;
    final listExcerpt = charge.isNotEmpty
        ? (charge.length > 220 ? '${charge.substring(0, 220)}…' : charge)
        : (t.birthPlace.isNotEmpty ? t.birthPlace : '—');

    final baseUri = Uri.parse(ApiConfig.baseUrl);
    final personRef = baseUri.replace(path: '${ApiEndpoints.persons}/$id');

    final bioText = t.biography.isNotEmpty
        ? t.biography
        : (charge.isNotEmpty
            ? charge
            : [t.birthPlace, t.occupation]
                .where((s) => s.isNotEmpty)
                .join('\n\n'));

    String? isoDate(Object? v) {
      final s = v?.toString().trim();
      if (s == null || s.isEmpty) return null;
      final d = DateTime.tryParse(s);
      if (d != null) {
        final y = d.year.toString().padLeft(4, '0');
        final mo = d.month.toString().padLeft(2, '0');
        final da = d.day.toString().padLeft(2, '0');
        return '$y-$mo-$da';
      }
      return s;
    }

    final arrest = detail ? (isoDate(m['arrestDate']) ?? '') : '';
    final sentenceD = detail ? (isoDate(m['sentenceDate']) ?? '') : '';
    final rehabD = detail ? (isoDate(m['rehabilitationDate']) ?? '') : '';

    final docs = detail ? _documents(m['documents']) : const <PersonDocumentRef>[];

    final verdict = t.sentence.trim().isNotEmpty ? t.sentence.trim() : null;

    return ArchiveEntry(
      id: id,
      fullName: t.fullName.isNotEmpty ? t.fullName : '—',
      accusation: charge,
      yearFrom: yearFrom,
      yearTo: yearTo,
      punishment: t.sentence.isNotEmpty ? t.sentence : charge,
      region: t.region,
      district: t.district,
      deathPlace: t.deathPlace,
      punishmentDate: detail ? sentenceD : '',
      occupation: t.occupation.isNotEmpty ? t.occupation : '—',
      rehabDate: detail ? rehabD : '',
      arrestDate: arrest,
      biography: bioText.isNotEmpty ? bioText : '—',
      portraitImageUrl: null,
      portraitImageName: portraitImageName,
      portraitAssetPath: null,
      birthCalendarDate: birthCal,
      deathCalendarDate: deathCal,
      source: ArchiveEntryLinkSource(uri: personRef),
      listExcerpt: listExcerpt,
      caseNumber: id,
      birthPlace: t.birthPlace.isNotEmpty ? t.birthPlace : '—',
      socialOrigin: '—',
      rehabFootnote: '',
      transcriptSection: null,
      verdictSection: verdict,
      familyConsequencesSection: null,
      documents: docs,
    );
  }

  static List<PersonDocumentRef> _documents(Object? raw) {
    if (raw is! List) return const [];
    final out = <PersonDocumentRef>[];
    for (final e in raw) {
      if (e is! Map) continue;
      final m = Map<String, dynamic>.from(e);
      final name = m['originalName']?.toString().trim() ?? '';
      if (name.isEmpty) continue;
      out.add(
        PersonDocumentRef(
          id: m['id']?.toString() ?? '',
          originalName: name,
        ),
      );
    }
    return out;
  }
}

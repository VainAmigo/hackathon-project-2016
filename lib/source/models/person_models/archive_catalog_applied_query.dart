import 'package:project_temp/source/models/person_models/archive_entry.dart';
import 'package:project_temp/source/models/person_models/persons_list_query.dart';

/// Условия фильтра каталога: маппинг в API и локальное уточнение по полям без query.
class ArchiveCatalogAppliedQuery {
  const ArchiveCatalogAppliedQuery({
    this.fullName = '',
    this.accusation = '',
    this.yearFrom = '',
    this.yearTo = '',
    this.punishment = '',
    this.region = '',
    this.punishmentDate = '',
    this.occupation = '',
    this.rehabDate = '',
  });

  static const empty = ArchiveCatalogAppliedQuery();

  final String fullName;
  final String accusation;
  final String yearFrom;
  final String yearTo;
  final String punishment;
  final String region;
  final String punishmentDate;
  final String occupation;
  final String rehabDate;

  PersonsListQuery toPersonsListQuery({required int page, required int size}) {
    return PersonsListQuery(
      page: page,
      size: size,
      name: fullName.trim().isEmpty ? null : fullName.trim(),
      region: region.trim().isEmpty ? null : region.trim(),
      occupation: occupation.trim().isEmpty ? null : occupation.trim(),
      birthYear: int.tryParse(yearFrom.trim()),
      deathYear: int.tryParse(yearTo.trim()),
      sentenceDate: _tryParseLocalDate(punishmentDate),
      rehabilitationDate: _tryParseLocalDate(rehabDate),
    );
  }

  bool matches(ArchiveEntry e) {
    if (!_contains(fullName, e.fullName)) return false;
    if (!_contains(accusation, e.accusation)) return false;
    if (!_contains(punishment, e.punishment)) return false;
    if (!_contains(region, e.region)) return false;
    if (!_contains(punishmentDate, e.punishmentDate)) return false;
    if (!_contains(occupation, e.occupation)) return false;
    if (!_contains(rehabDate, e.rehabDate)) return false;
    if (!_yearMatches(e)) return false;
    return true;
  }

  static bool _contains(String filter, String value) {
    final f = filter.trim().toLowerCase();
    if (f.isEmpty) return true;
    return value.toLowerCase().contains(f);
  }

  bool _yearMatches(ArchiveEntry e) {
    final birth = int.tryParse(e.yearFrom.trim());
    if (birth == null) return true;
    final yFrom = int.tryParse(yearFrom.trim());
    final yTo = int.tryParse(yearTo.trim());
    if (yFrom != null && birth < yFrom) return false;
    if (yTo != null && birth > yTo) return false;
    return true;
  }

  static DateTime? _tryParseLocalDate(String raw) {
    final s = raw.trim();
    if (s.isEmpty) return null;
    final iso = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$').firstMatch(s);
    if (iso != null) {
      final y = int.tryParse(iso.group(1)!);
      final mo = int.tryParse(iso.group(2)!);
      final d = int.tryParse(iso.group(3)!);
      if (y != null && mo != null && d != null) {
        return DateTime(y, mo, d);
      }
    }
    final dot = RegExp(r'^(\d{2})\.(\d{2})\.(\d{4})$').firstMatch(s);
    if (dot != null) {
      final d = int.tryParse(dot.group(1)!);
      final mo = int.tryParse(dot.group(2)!);
      final y = int.tryParse(dot.group(3)!);
      if (y != null && mo != null && d != null) {
        return DateTime(y, mo, d);
      }
    }
    return DateTime.tryParse(s);
  }
}

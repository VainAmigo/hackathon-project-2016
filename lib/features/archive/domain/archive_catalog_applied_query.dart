import 'package:project_temp/features/archive/domain/archive_entry.dart';

/// Применённые к каталогу условия фильтрации (чистая логика, без UI).
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
}

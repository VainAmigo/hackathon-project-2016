import 'package:equatable/equatable.dart';

import 'package:project_temp/features/archive/domain/archive_entry_source.dart';

/// Карточка записи архива (доменная модель).
class ArchiveEntry extends Equatable {
  const ArchiveEntry({
    required this.id,
    required this.fullName,
    required this.accusation,
    required this.yearFrom,
    required this.yearTo,
    required this.punishment,
    required this.region,
    required this.punishmentDate,
    required this.occupation,
    required this.rehabDate,
    required this.biography,
    required this.portraitAssetPath,
    required this.source,
    required this.listExcerpt,
    required this.caseNumber,
    required this.birthPlace,
    required this.socialOrigin,
    required this.rehabFootnote,
    this.transcriptSection,
    this.verdictSection,
    this.familyConsequencesSection,
  });

  final String id;
  final String fullName;
  final String accusation;
  final String yearFrom;
  final String yearTo;
  final String punishment;
  final String region;
  final String punishmentDate;
  final String occupation;
  final String rehabDate;
  final String biography;
  final String portraitAssetPath;
  final ArchiveEntrySource source;

  /// Краткий абзац для списка на главной.
  final String listExcerpt;
  final String caseNumber;
  final String birthPlace;
  final String socialOrigin;
  final String rehabFootnote;

  final String? transcriptSection;
  final String? verdictSection;
  final String? familyConsequencesSection;

  String get lifeYearsLabel => '$yearFrom — $yearTo';

  @override
  List<Object?> get props => [id];
}

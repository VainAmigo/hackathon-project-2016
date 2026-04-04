import 'package:equatable/equatable.dart';

import 'package:project_temp/source/models/person_models/archive_entry_source.dart';

/// Ссылка на документ в карточке персоны (ответ API).
class PersonDocumentRef extends Equatable {
  const PersonDocumentRef({
    required this.id,
    required this.originalName,
  });

  final String id;
  final String originalName;

  @override
  List<Object?> get props => [id];
}

/// Карточка записи архива (модель слоя source + поля для макета).
class ArchiveEntry extends Equatable {
  const ArchiveEntry({
    required this.id,
    required this.fullName,
    required this.accusation,
    required this.yearFrom,
    required this.yearTo,
    required this.punishment,
    required this.region,
    required this.district,
    required this.deathPlace,
    required this.punishmentDate,
    required this.occupation,
    required this.rehabDate,
    required this.arrestDate,
    required this.biography,
    required this.source,
    required this.listExcerpt,
    required this.caseNumber,
    required this.birthPlace,
    required this.socialOrigin,
    required this.rehabFootnote,
    this.portraitImageUrl,
    this.portraitImageName,
    this.portraitAssetPath,
    this.birthCalendarDate,
    this.deathCalendarDate,
    this.transcriptSection,
    this.verdictSection,
    this.familyConsequencesSection,
    this.documents = const [],
  });

  final String id;
  final String fullName;
  final String accusation;
  final String yearFrom;
  final String yearTo;
  final String punishment;
  final String region;
  final String district;
  final String deathPlace;
  final String punishmentDate;
  final String occupation;
  final String rehabDate;
  final String arrestDate;
  final String biography;

  /// Прямой URL портрета (без Bearer); редко нужен, приоритет у [portraitImageName].
  final String? portraitImageUrl;

  /// Имя файла для GET /api/v1/files/images/{name} (поле imageName в API).
  final String? portraitImageName;

  /// Локальный asset (демо/офлайн).
  final String? portraitAssetPath;

  final DateTime? birthCalendarDate;
  final DateTime? deathCalendarDate;

  final ArchiveEntrySource source;
  final String listExcerpt;
  final String caseNumber;
  final String birthPlace;
  final String socialOrigin;
  final String rehabFootnote;

  final String? transcriptSection;
  final String? verdictSection;
  final String? familyConsequencesSection;

  final List<PersonDocumentRef> documents;

  String get lifeYearsLabel => '$yearFrom — $yearTo';

  @override
  List<Object?> get props => [id];
}

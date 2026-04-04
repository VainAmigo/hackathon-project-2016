import 'package:equatable/equatable.dart';

/// Одна локаль из [EntryMlResponse.result] (ky / ru / en / tr).
class EntryExtractedFields extends Equatable {
  const EntryExtractedFields({
    this.fullName,
    this.normalizedName,
    this.birthYear,
    this.deathYear,
    this.birthDate,
    this.deathDate,
    this.birthPlace,
    this.deathPlace,
    this.region,
    this.district,
    this.occupation,
    this.charge,
    this.arrestDate,
    this.sentence,
    this.sentenceDate,
    this.rehabilitationDate,
    this.biography,
  });

  final String? fullName;
  final String? normalizedName;
  final int? birthYear;
  final int? deathYear;
  final String? birthDate;
  final String? deathDate;
  final String? birthPlace;
  final String? deathPlace;
  final String? region;
  final String? district;
  final String? occupation;
  final String? charge;
  final String? arrestDate;
  final String? sentence;
  final String? sentenceDate;
  final String? rehabilitationDate;
  final String? biography;

  static int? _asInt(Object? v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString());
  }

  static String? _asStr(Object? v) => v == null
      ? null
      : v.toString().trim().isEmpty
      ? null
      : v.toString();

  factory EntryExtractedFields.fromJson(Map<String, dynamic> json) {
    return EntryExtractedFields(
      fullName: _asStr(json['full_name']),
      normalizedName: _asStr(json['normalized_name']),
      birthYear: _asInt(json['birth_year']),
      deathYear: _asInt(json['death_year']),
      birthDate: _asStr(json['birth_date']),
      deathDate: _asStr(json['death_date']),
      birthPlace: _asStr(json['birth_place']),
      deathPlace: _asStr(json['death_place']),
      region: _asStr(json['region']),
      district: _asStr(json['district']),
      occupation: _asStr(json['occupation']),
      charge: _asStr(json['charge']),
      arrestDate: _asStr(json['arrest_date']),
      sentence: _asStr(json['sentence']),
      sentenceDate: _asStr(json['sentence_date']),
      rehabilitationDate: _asStr(json['rehabilitation_date']),
      biography: _asStr(json['biography']),
    );
  }

  @override
  List<Object?> get props => [fullName, birthYear, deathYear, region];
}

/// Объект `mlResponse` в ответе POST /api/upload.
class EntryMlResponse extends Equatable {
  const EntryMlResponse({
    this.type,
    required this.byLocale,
    required this.missingFields,
    required this.warnings,
  });

  final String? type;
  final Map<String, EntryExtractedFields> byLocale;
  final List<String> missingFields;
  final List<String> warnings;

  static List<String> _stringList(Object? v) {
    if (v is! List) return const [];
    return v.map((e) => e.toString()).toList();
  }

  factory EntryMlResponse.fromJson(Map<String, dynamic> json) {
    final byLocale = <String, EntryExtractedFields>{};
    final raw = json['result'];
    if (raw is Map) {
      final rawMap = Map<String, dynamic>.from(raw);
      for (final e in rawMap.entries) {
        final v = e.value;
        if (v is Map) {
          byLocale[e.key.toString()] = EntryExtractedFields.fromJson(
            Map<String, dynamic>.from(v),
          );
        }
      }
    }
    return EntryMlResponse(
      type: json['type'] as String?,
      byLocale: byLocale,
      missingFields: _stringList(json['missing_fields']),
      warnings: _stringList(json['warnings']),
    );
  }

  @override
  List<Object?> get props => [type, byLocale, missingFields, warnings];
}

/// Тело ответа после загрузки PDF.
class DocumentUploadResponse extends Equatable {
  const DocumentUploadResponse({
    this.mlResponse,
    this.documentId,
    this.fileUrl,
  });

  final EntryMlResponse? mlResponse;
  final int? documentId;
  final String? fileUrl;

  factory DocumentUploadResponse.fromJson(Map<String, dynamic> json) {
    EntryMlResponse? ml;
    final rawMl = json['mlResponse'];
    if (rawMl is Map) {
      ml = EntryMlResponse.fromJson(Map<String, dynamic>.from(rawMl));
    }
    if (ml == null || ml.byLocale.isEmpty) {
      final top = json['result'];
      if (top is Map) {
        final topMap = Map<String, dynamic>.from(top);
        if (_isLocaleKeyedFieldMap(topMap)) {
          ml = EntryMlResponse.fromJson({
            'type': json['type'],
            'result': topMap,
            'missing_fields': json['missing_fields'],
            'warnings': json['warnings'],
          });
        }
      }
    }
    final idRaw = json['documentId'];
    int? docId;
    if (idRaw is int) {
      docId = idRaw;
    } else if (idRaw != null) {
      docId = int.tryParse(idRaw.toString());
    }
    return DocumentUploadResponse(
      mlResponse: ml,
      documentId: docId,
      fileUrl: json['fileUrl'] as String?,
    );
  }

  @override
  List<Object?> get props => [mlResponse, documentId, fileUrl];
}

/// В `result` могут быть лишние поля (например `normalized_name: null`); учитываем только вложенные карты локалей.
bool _isLocaleKeyedFieldMap(Map<String, dynamic> map) {
  for (final v in map.values) {
    if (v is Map) return true;
  }
  return false;
}

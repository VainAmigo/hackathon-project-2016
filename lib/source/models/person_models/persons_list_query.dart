import 'package:equatable/equatable.dart';

/// Параметры GET /api/v1/persons. Пустые/null поля в query не передаются.
class PersonsListQuery extends Equatable {
  const PersonsListQuery({
    this.birthYear,
    this.deathYear,
    this.birthDate,
    this.deathDate,
    this.arrestDate,
    this.sentenceDate,
    this.rehabilitationDate,
    this.name,
    this.region,
    this.district,
    this.occupation,
    this.page = 0,
    this.size = 20,
  });

  /// Превью архива на главной: в query только `page` и `size`, без фильтров.
  factory PersonsListQuery.homeRecentRecoveries() {
    return const PersonsListQuery(
      page: 0,
      size: 8,
    );
  }

  final int? birthYear;
  final int? deathYear;
  final DateTime? birthDate;
  final DateTime? deathDate;
  final DateTime? arrestDate;
  final DateTime? sentenceDate;
  final DateTime? rehabilitationDate;
  final String? name;
  final String? region;
  final String? district;
  final String? occupation;
  final int page;
  final int size;

  static String _ymd(DateTime d) {
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y-$m-$day';
  }

  Map<String, dynamic> toQueryParameters() {
    final m = <String, dynamic>{
      'page': page,
      'size': size,
    };
    void put(String key, Object? value) {
      if (value == null) return;
      if (value is String && value.trim().isEmpty) return;
      m[key] = value;
    }

    put('birthYear', birthYear);
    put('deathYear', deathYear);
    if (birthDate != null) put('birthDate', _ymd(birthDate!));
    if (deathDate != null) put('deathDate', _ymd(deathDate!));
    if (arrestDate != null) put('arrestDate', _ymd(arrestDate!));
    if (sentenceDate != null) put('sentenceDate', _ymd(sentenceDate!));
    if (rehabilitationDate != null) {
      put('rehabilitationDate', _ymd(rehabilitationDate!));
    }
    put('name', name?.trim());
    put('region', region?.trim());
    put('district', district?.trim());
    put('occupation', occupation?.trim());
    return m;
  }

  @override
  List<Object?> get props => [
        birthYear,
        deathYear,
        birthDate,
        deathDate,
        arrestDate,
        sentenceDate,
        rehabilitationDate,
        name,
        region,
        district,
        occupation,
        page,
        size,
      ];
}

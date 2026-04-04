import 'package:equatable/equatable.dart';

import 'package:project_temp/source/models/person_models/archive_entry.dart';

class PersonsPageResult extends Equatable {
  const PersonsPageResult({
    required this.content,
    required this.totalElements,
    required this.totalPages,
    required this.number,
    required this.size,
    required this.last,
    required this.first,
  });

  final List<ArchiveEntry> content;
  final int totalElements;
  final int totalPages;
  final int number;
  final int size;
  final bool last;
  final bool first;

  @override
  List<Object?> get props => [
        content,
        totalElements,
        totalPages,
        number,
        size,
        last,
        first,
      ];
}

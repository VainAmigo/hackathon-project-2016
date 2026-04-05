import 'dart:typed_data';

import 'package:fpdart/fpdart.dart' show Either, Unit;
import 'package:project_temp/source/models/person_models/archive_entry.dart';
import 'package:project_temp/source/models/person_models/persons_list_query.dart';
import 'package:project_temp/source/models/person_models/persons_page_result.dart';
import 'package:project_temp/source/error/failures.dart';

abstract class PersonsRepository {
  Future<Either<Failure, PersonsPageResult>> listPersons(PersonsListQuery query);

  /// GET /api/v1/persons/{id}?language= — целый индекс как в POST (en=0…tr=3); без него — 400.
  Future<Either<Failure, ArchiveEntry>> getPerson(
    String id, {
    required String languageCode,
  });

  /// GET /api/v1/persons/{id}/audio?language= — ответ: один бинарный файл.
  Future<Either<Failure, Uint8List>> fetchPersonAudio(
    String personId,
    String languageCode,
  );

  /// PUT /api/v1/moderator/persons/{id}?approved=
  Future<Either<Failure, Unit>> moderatePerson(
    String personId, {
    required bool approved,
  });
}

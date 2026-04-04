import 'package:fpdart/fpdart.dart';
import 'package:project_temp/source/models/person_models/archive_entry.dart';
import 'package:project_temp/source/models/person_models/persons_list_query.dart';
import 'package:project_temp/source/models/person_models/persons_page_result.dart';
import 'package:project_temp/source/error/failures.dart';

abstract class PersonsRepository {
  Future<Either<Failure, PersonsPageResult>> listPersons(PersonsListQuery query);

  Future<Either<Failure, ArchiveEntry>> getPerson(String id);
}

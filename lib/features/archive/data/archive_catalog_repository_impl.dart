import 'package:fpdart/fpdart.dart';
import 'package:project_temp/features/archive/domain/archive_catalog_repository.dart';
import 'package:project_temp/source/source.dart';

class ArchiveCatalogRepositoryImpl implements ArchiveCatalogRepository {
  ArchiveCatalogRepositoryImpl(this._persons);

  final PersonsRepository _persons;

  @override
  Future<Either<Failure, List<ArchiveEntry>>> loadHomePreview() async {
    final r = await _persons.listPersons(PersonsListQuery.homeRecentRecoveries());
    return r.map((page) => page.content);
  }

  @override
  Future<Either<Failure, PersonsPageResult>> fetchPersons(
    PersonsListQuery query,
  ) {
    return _persons.listPersons(query);
  }
}

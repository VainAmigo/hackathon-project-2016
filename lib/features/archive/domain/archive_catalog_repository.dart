import 'package:fpdart/fpdart.dart';
import 'package:project_temp/source/source.dart';

/// Каталог записей: превью на главной и постраничная выдача API.
abstract class ArchiveCatalogRepository {
  /// Секция архива на главной (узкий запрос по датам).
  Future<Either<Failure, List<ArchiveEntry>>> loadHomePreview();

  Future<Either<Failure, PersonsPageResult>> fetchPersons(
    PersonsListQuery query,
  );
}

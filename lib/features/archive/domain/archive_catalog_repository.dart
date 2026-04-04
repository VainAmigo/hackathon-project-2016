import 'package:project_temp/features/archive/domain/archive_entry.dart';

/// Каталог записей для главной и детального экрана.
abstract class ArchiveCatalogRepository {
  Future<List<ArchiveEntry>> loadEntries();
}

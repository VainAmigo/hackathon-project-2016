import 'package:project_temp/features/archive/data/archive_static_entries.dart';
import 'package:project_temp/features/archive/domain/archive_catalog_repository.dart';
import 'package:project_temp/features/archive/domain/archive_entry.dart';

class ArchiveCatalogRepositoryImpl implements ArchiveCatalogRepository {
  @override
  Future<List<ArchiveEntry>> loadEntries() async {
    return List<ArchiveEntry>.unmodifiable(archiveStaticEntries);
  }
}

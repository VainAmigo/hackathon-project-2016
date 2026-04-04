import 'package:equatable/equatable.dart';

import 'package:project_temp/source/models/person_models/data_source_format.dart';

sealed class ArchiveEntrySource extends Equatable {
  const ArchiveEntrySource();

  @override
  List<Object?> get props => [];
}

final class ArchiveEntryAssetSource extends ArchiveEntrySource {
  const ArchiveEntryAssetSource({
    required this.assetPath,
    required this.format,
    required this.displayFileName,
  });

  final String assetPath;
  final DataSourceFormat format;
  final String displayFileName;

  @override
  List<Object?> get props => [assetPath, format, displayFileName];
}

final class ArchiveEntryLinkSource extends ArchiveEntrySource {
  const ArchiveEntryLinkSource({required this.uri});

  final Uri uri;

  @override
  List<Object?> get props => [uri];
}

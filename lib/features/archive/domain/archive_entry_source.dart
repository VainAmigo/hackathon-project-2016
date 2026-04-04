import 'package:equatable/equatable.dart';

import 'package:project_temp/features/archive/domain/data_source_format.dart';

/// Источник данных для записи: локальный ассет (pdf/md/txt) или внешняя ссылка.
sealed class ArchiveEntrySource extends Equatable {
  const ArchiveEntrySource();

  @override
  List<Object?> get props => [];
}

/// Файл из assets (просмотр в [DataSourceViewerSheet]).
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

/// Внешний URL (открытие во внешнем приложении / браузере).
final class ArchiveEntryLinkSource extends ArchiveEntrySource {
  const ArchiveEntryLinkSource({required this.uri});

  final Uri uri;

  @override
  List<Object?> get props => [uri];
}

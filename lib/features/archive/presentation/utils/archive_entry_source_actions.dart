import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:project_temp/components/data_source/data_source_viewer_sheet.dart';
import 'package:project_temp/core/core.dart';
import 'package:project_temp/features/archive/domain/archive_entry.dart';
import 'package:project_temp/features/archive/domain/archive_entry_source.dart';

/// Подпись источника для UI (имя файла или хост ссылки).
String archiveSourceDisplayTitle(ArchiveEntrySource source) {
  return switch (source) {
    ArchiveEntryAssetSource s => s.displayFileName,
    ArchiveEntryLinkSource s => s.uri.host.isNotEmpty ? s.uri.host : s.uri.toString(),
  };
}

Future<void> openArchiveEntrySource(BuildContext context, ArchiveEntry entry) async {
  final l10n = context.l10n;
  switch (entry.source) {
    case ArchiveEntryAssetSource s:
      await openDataSourceFromAsset(
        context: context,
        assetPath: s.assetPath,
        format: s.format,
        displayFileName: s.displayFileName,
      );
    case ArchiveEntryLinkSource s:
      final ok = await launchUrl(
        s.uri,
        mode: LaunchMode.externalApplication,
      );
      if (!context.mounted) return;
      if (!ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.dataSourceLinkOpenFailed)),
        );
      }
  }
}

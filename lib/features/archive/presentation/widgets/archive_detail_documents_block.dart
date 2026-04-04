import 'package:flutter/material.dart';

import 'package:project_temp/core/core.dart';
import 'package:project_temp/features/archive/presentation/widgets/archive_document_file_row.dart';
import 'package:project_temp/l10n/app_localizations.dart';
import 'package:project_temp/source/source.dart';

/// Блок «Источник»: список документов с загрузкой через /api/v1/files/files/{name}.
class ArchiveDetailDocumentsBlock extends StatelessWidget {
  const ArchiveDetailDocumentsBlock({
    super.key,
    required this.entry,
    required this.l10n,
  });

  final ArchiveEntry entry;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    if (entry.documents.isEmpty) {
      return Text(
        l10n.archiveDetailDocumentsEmpty,
        style: TextStyle(
          fontFamily: 'serif',
          fontSize: 15,
          height: 1.4,
          color: AppThemes.textColorGrey,
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < entry.documents.length; i++) ...[
          if (i > 0) const Divider(height: 1),
          ArchiveDocumentFileRow(document: entry.documents[i]),
        ],
      ],
    );
  }
}

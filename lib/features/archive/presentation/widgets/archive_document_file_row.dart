import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:project_temp/core/core.dart';
import 'package:project_temp/core/platform/share_bytes.dart';
import 'package:project_temp/source/source.dart';

/// Строка документа: имя + загрузка файла (GET /api/v1/files/files/{originalName}).
class ArchiveDocumentFileRow extends StatefulWidget {
  const ArchiveDocumentFileRow({super.key, required this.document});

  final PersonDocumentRef document;

  @override
  State<ArchiveDocumentFileRow> createState() => _ArchiveDocumentFileRowState();
}

class _ArchiveDocumentFileRowState extends State<ArchiveDocumentFileRow> {
  bool _busy = false;

  Future<void> _download() async {
    if (_busy) return;
    final name = widget.document.originalName.trim();
    if (name.isEmpty) return;

    setState(() => _busy = true);
    final result = await sl<FilesRepository>().fetchBytes('files', name);
    if (!mounted) return;
    setState(() => _busy = false);

    final l10n = context.l10n;
    await result.fold(
      (f) async {
        AppSnackMessenger.showMessage(f.message, isError: true);
      },
      (Uint8List bytes) async {
        try {
          await shareDownloadedBytes(bytes, name);
          if (mounted) {
            AppSnackMessenger.showMessage(l10n.dataSourceSavedToast);
          }
        } on Object catch (e) {
          if (mounted) {
            AppSnackMessenger.showMessage(
              '${l10n.dataSourceSaveFailedToast} $e',
              isError: true,
            );
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _busy ? null : _download,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.document.originalName,
                  style: const TextStyle(
                    fontFamily: 'serif',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                    color: AppThemes.textColorPrimary,
                  ),
                ),
              ),
              if (_busy)
                const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                Tooltip(
                  message: l10n.dataSourceSaveCopy,
                  child: Icon(
                    Icons.download_outlined,
                    size: 22,
                    color: AppThemes.accentColor,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

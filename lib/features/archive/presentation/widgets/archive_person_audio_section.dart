import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:project_temp/core/core.dart';
import 'package:project_temp/core/platform/share_bytes.dart';
import 'package:project_temp/l10n/app_localizations.dart';
import 'package:project_temp/source/source.dart';

/// Кнопка загрузки аудиопересказа: GET /api/v1/persons/{id}/audio?language=…
class ArchivePersonAudioSection extends StatefulWidget {
  const ArchivePersonAudioSection({
    super.key,
    required this.personId,
    required this.l10n,
  });

  final String personId;
  final AppLocalizations l10n;

  @override
  State<ArchivePersonAudioSection> createState() =>
      _ArchivePersonAudioSectionState();
}

class _ArchivePersonAudioSectionState extends State<ArchivePersonAudioSection> {
  bool _busy = false;

  String get _lang =>
      Localizations.localeOf(context).languageCode.toLowerCase().trim();

  Future<void> _download() async {
    if (_busy) return;
    final id = widget.personId.trim();
    if (id.isEmpty) return;

    setState(() => _busy = true);
    final result = await sl<PersonsRepository>().fetchPersonAudio(id, _lang);
    if (!mounted) return;
    setState(() => _busy = false);

    final l10n = widget.l10n;
    final safeName = id.replaceAll(RegExp(r'[^\w\-]+'), '_');
    final fileName = 'narration_${safeName}_$_lang.mp3';

    await result.fold(
      (f) async {
        AppSnackMessenger.showMessage(f.message, isError: true);
      },
      (Uint8List bytes) async {
        try {
          await shareDownloadedBytes(bytes, fileName);
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
    final l10n = widget.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.archiveDetailAudioHeading,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.4,
            color: AppThemes.textColorGrey,
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: _busy ? null : _download,
          icon: _busy
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.headphones_outlined, size: 20),
          label: Text(l10n.archiveDetailAudioDownload),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppThemes.textColorPrimary,
            side: BorderSide(
              color: AppThemes.textColorGrey.withValues(alpha: 0.35),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }
}

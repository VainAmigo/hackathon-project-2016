import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:pdfx/pdfx.dart';
import 'package:project_temp/core/core.dart';
import 'package:project_temp/core/platform/share_bytes.dart';
import 'package:project_temp/l10n/app_localizations.dart';
import 'package:project_temp/source/models/person_models/data_source_format.dart';

/// Показывает нижний лист с просмотром источника (PDF / Markdown / текст) и кнопкой «Сохранить / поделиться».
Future<void> showDataSourceViewerSheet({
  required BuildContext context,
  required String assetPath,
  required DataSourceFormat format,
  required String displayFileName,
  required Uint8List bytes,
}) {
  final l10n = AppLocalizations.of(context);
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppThemes.backgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.92,
        minChildSize: 0.45,
        maxChildSize: 0.96,
        builder: (context, scrollController) {
          return Column(
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppThemes.textColorGrey.withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                      color: AppThemes.textColorPrimary,
                    ),
                    Expanded(
                      child: Text(
                        displayFileName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'serif',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppThemes.textColorPrimary,
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () async {
                        try {
                          await shareDownloadedBytes(bytes, displayFileName);
                          if (ctx.mounted) {
                            ScaffoldMessenger.of(ctx).showSnackBar(
                              SnackBar(content: Text(l10n.dataSourceSavedToast)),
                            );
                          }
                        } catch (_) {
                          if (ctx.mounted) {
                            ScaffoldMessenger.of(ctx).showSnackBar(
                              SnackBar(
                                content: Text(l10n.dataSourceSaveFailedToast),
                              ),
                            );
                          }
                        }
                      },
                      icon: const Icon(Icons.ios_share_outlined, size: 20),
                      label: Text(l10n.dataSourceSaveCopy),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: _SourceContent(
                  format: format,
                  bytes: bytes,
                  assetPath: assetPath,
                  scrollController: scrollController,
                  l10n: l10n,
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

class _SourceContent extends StatelessWidget {
  const _SourceContent({
    required this.format,
    required this.bytes,
    required this.assetPath,
    required this.scrollController,
    required this.l10n,
  });

  final DataSourceFormat format;
  final Uint8List bytes;
  final String assetPath;
  final ScrollController scrollController;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    switch (format) {
      case DataSourceFormat.txt:
        return Scrollbar(
          controller: scrollController,
          child: SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(20),
            child: SelectableText(
              utf8.decode(bytes),
              style: TextStyle(
                fontSize: 15,
                height: 1.5,
                color: AppThemes.textColorSecondary,
              ),
            ),
          ),
        );
      case DataSourceFormat.md:
        return Scrollbar(
          controller: scrollController,
          child: Markdown(
            controller: scrollController,
            padding: const EdgeInsets.all(20),
            data: utf8.decode(bytes),
            selectable: true,
            styleSheet: MarkdownStyleSheet(
              p: TextStyle(
                fontSize: 15,
                height: 1.5,
                color: AppThemes.textColorSecondary,
              ),
              h1: const TextStyle(
                fontFamily: 'serif',
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppThemes.textColorPrimary,
              ),
              h2: const TextStyle(
                fontFamily: 'serif',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppThemes.textColorPrimary,
              ),
              strong: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppThemes.textColorPrimary,
              ),
              listBullet: TextStyle(color: AppThemes.textColorSecondary),
            ),
          ),
        );
      case DataSourceFormat.pdf:
        return _PdfSourceView(
          assetPath: assetPath,
          bytes: bytes,
          l10n: l10n,
        );
    }
  }
}

class _PdfSourceView extends StatefulWidget {
  const _PdfSourceView({
    required this.assetPath,
    required this.bytes,
    required this.l10n,
  });

  final String assetPath;
  final Uint8List bytes;
  final AppLocalizations l10n;

  @override
  State<_PdfSourceView> createState() => _PdfSourceViewState();
}

class _PdfSourceViewState extends State<_PdfSourceView> {
  PdfControllerPinch? _controller;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _open();
  }

  Future<void> _open() async {
    try {
      final doc = await PdfDocument.openData(widget.bytes);
      if (!mounted) {
        await doc.close();
        return;
      }
      setState(() {
        _controller = PdfControllerPinch(document: Future.value(doc));
      });
    } catch (e) {
      setState(() => _error = e);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            widget.l10n.dataSourcePdfUnavailable,
            textAlign: TextAlign.center,
            style: TextStyle(color: AppThemes.textColorSecondary, height: 1.45),
          ),
        ),
      );
    }
    final c = _controller;
    if (c == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return PdfViewPinch(
      controller: c,
      backgroundDecoration: BoxDecoration(color: AppThemes.surfaceColor),
    );
  }
}

/// Загружает ассет и открывает [showDataSourceViewerSheet].
Future<void> openDataSourceFromAsset({
  required BuildContext context,
  required String assetPath,
  required DataSourceFormat format,
  required String displayFileName,
}) async {
  final data = await DefaultAssetBundle.of(context).load(assetPath);
  final bytes = data.buffer.asUint8List();
  if (!context.mounted) return;
  await showDataSourceViewerSheet(
    context: context,
    assetPath: assetPath,
    format: format,
    displayFileName: displayFileName,
    bytes: bytes,
  );
}

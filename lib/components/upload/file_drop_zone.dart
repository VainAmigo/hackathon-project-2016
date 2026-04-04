import 'dart:math' as math;

import 'package:cross_file/cross_file.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:project_temp/core/core.dart';

/// Визуальный акцент зоны (иконка в пустом и загруженном состоянии).
enum FileDropZoneKind {
  generic,
  document,
  image,
}

/// Зона выбора файлов: перетаскивание (где поддерживает [desktop_drop]) и диалог выбора.
///
/// При [maxFiles] == 1 после загрузки показывается компактная строка файла, а не чипы.
/// Если заданы [allowedExtensions], принимаются только подходящие файлы (остальные — [invalidTypeMessage]).
class FileDropZone extends StatefulWidget {
  const FileDropZone({
    super.key,
    required this.title,
    required this.hint,
    required this.browseLabel,
    required this.changeFileLabel,
    required this.removeFileLabel,
    required this.invalidTypeMessage,
    this.onFilesChanged,
    this.fileType = FileType.any,
    this.allowedExtensions,
    this.minHeightEmpty = 168,
    this.maxFiles = 1,
    this.kind = FileDropZoneKind.generic,
  });

  final String title;
  final String hint;
  final String browseLabel;
  final String changeFileLabel;
  final String removeFileLabel;
  final String invalidTypeMessage;
  final ValueChanged<List<XFile>>? onFilesChanged;
  final FileType fileType;
  final List<String>? allowedExtensions;
  final double minHeightEmpty;
  final int maxFiles;
  final FileDropZoneKind kind;

  @override
  State<FileDropZone> createState() => _FileDropZoneState();
}

class _FileDropZoneState extends State<FileDropZone> {
  final List<XFile> _files = <XFile>[];
  bool _dragging = false;

  void _notify() {
    widget.onFilesChanged?.call(List<XFile>.unmodifiable(_files));
  }

  Set<String> get _allowedLower =>
      widget.allowedExtensions?.map((e) => e.toLowerCase()).toSet() ?? {};

  bool get _restrictsTypes => _allowedLower.isNotEmpty;

  static String? _extensionLower(String name) {
    final i = name.toLowerCase().lastIndexOf('.');
    if (i < 0 || i >= name.length - 1) return null;
    return name.toLowerCase().substring(i + 1);
  }

  bool _accepts(XFile file) {
    if (!_restrictsTypes) return true;
    final ext = _extensionLower(file.name);
    if (ext != null && _allowedLower.contains(ext)) return true;
    final mime = file.mimeType?.toLowerCase();
    if (mime == null) return false;
    if (_allowedLower.contains('pdf') && mime == 'application/pdf') return true;
    if (_allowedLower.contains('txt') && mime == 'text/plain') return true;
    if (_allowedLower.contains('md')) {
      if (mime == 'text/markdown' ||
          mime == 'text/x-markdown' ||
          mime == 'text/plain') {
        return true;
      }
    }
    if (_allowedLower.contains('jpg') ||
        _allowedLower.contains('jpeg') ||
        _allowedLower.contains('png')) {
      if (mime == 'image/jpeg' || mime == 'image/jpg') return true;
      if (mime == 'image/png') return true;
    }
    return false;
  }

  XFile? _firstAccepted(Iterable<XFile> candidates) {
    for (final f in candidates) {
      if (_accepts(f)) return f;
    }
    return null;
  }

  void _rejectTypeIfNeeded(
    List<XFile> incoming, {
    required bool acceptedAny,
  }) {
    if (!_restrictsTypes || incoming.isEmpty || acceptedAny || !mounted) {
      return;
    }
    AppSnackMessenger.showMessage(
      widget.invalidTypeMessage,
      isError: true,
    );
  }

  void _commitIncoming(List<XFile> incoming) {
    if (incoming.isEmpty) return;
    final max = widget.maxFiles;

    if (max <= 1) {
      final one = _firstAccepted(incoming);
      _rejectTypeIfNeeded(incoming, acceptedAny: one != null);
      if (one == null) return;
      setState(() {
        _files
          ..clear()
          ..add(one);
      });
      _notify();
      return;
    }

    final accepted = incoming.where(_accepts).toList();
    _rejectTypeIfNeeded(incoming, acceptedAny: accepted.isNotEmpty);
    if (accepted.isEmpty) return;
    setState(() {
      _files.addAll(accepted);
      if (_files.length > max) {
        _files.removeRange(0, _files.length - max);
      }
    });
    _notify();
  }

  void _removeAt(int index) {
    setState(() {
      _files.removeAt(index);
    });
    _notify();
  }

  Future<void> _browse() async {
    final multi = widget.maxFiles > 1;
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: multi,
      type: widget.fileType,
      allowedExtensions: widget.allowedExtensions,
      withData: kIsWeb,
    );
    if (result == null || !mounted) return;
    final list = <XFile>[];
    for (final f in result.files) {
      if (f.path != null && f.path!.isNotEmpty) {
        list.add(XFile(f.path!, name: f.name));
      } else if (f.bytes != null) {
        list.add(XFile.fromData(f.bytes!, name: f.name));
      }
    }
    _commitIncoming(list);
  }

  static List<XFile> _flattenDropped(List<DropItem> items) {
    final out = <XFile>[];
    void walk(DropItem item) {
      if (item is DropItemFile) {
        out.add(item);
      } else if (item is DropItemDirectory) {
        for (final c in item.children) {
          walk(c);
        }
      }
    }
    for (final i in items) {
      walk(i);
    }
    return out;
  }

  IconData _leadingIcon({required bool filled}) {
    switch (widget.kind) {
      case FileDropZoneKind.document:
        return filled ? Icons.picture_as_pdf_outlined : Icons.upload_file_outlined;
      case FileDropZoneKind.image:
        return filled ? Icons.image_outlined : Icons.add_photo_alternate_outlined;
      case FileDropZoneKind.generic:
        return filled ? Icons.attach_file : Icons.note_add_outlined;
    }
  }

  void _onDropDone(DropDoneDetails details) {
    setState(() => _dragging = false);
    final flat = _flattenDropped(details.files);
    if (flat.isEmpty) return;
    _commitIncoming(flat);
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = _dragging
        ? AppThemes.accentColor
        : AppThemes.textColorGrey.withValues(alpha: 0.55);

    final singleFilled = widget.maxFiles <= 1 && _files.length == 1;
    final file = singleFilled ? _files.single : null;

    return DropTarget(
      onDragEntered: (_) => setState(() => _dragging = true),
      onDragExited: (_) => setState(() => _dragging = false),
      onDragDone: _onDropDone,
      child: singleFilled && file != null
          ? _buildLoadedSingle(context, file)
          : CustomPaint(
              foregroundPainter: _DashedRRectPainter(
                color: borderColor,
                strokeWidth: 2,
                radius: 12,
              ),
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: _buildEmptyOrMulti(context),
              ),
            ),
    );
  }

  Widget _buildLoadedSingle(BuildContext context, XFile file) {
    final box = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppThemes.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _dragging
              ? AppThemes.accentColor.withValues(alpha: 0.65)
              : AppThemes.textColorGrey.withValues(alpha: 0.4),
          width: _dragging ? 1.8 : 1,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, c) {
          final narrow = c.maxWidth < 420;
          final meta = Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                _leadingIcon(filled: true),
                size: 36,
                color: AppThemes.textColorSecondary,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.4,
                        color: AppThemes.textColorGrey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      file.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppThemes.textColorPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
          final changeBtn = TextButton(
            onPressed: _browse,
            child: Text(widget.changeFileLabel),
          );
          final removeBtn = IconButton(
            tooltip: widget.removeFileLabel,
            onPressed: () => _removeAt(0),
            icon: Icon(Icons.close, color: AppThemes.textColorGrey),
          );
          if (narrow) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                meta,
                const SizedBox(height: 8),
                Row(
                  children: [changeBtn, removeBtn],
                ),
              ],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: meta),
              changeBtn,
              removeBtn,
            ],
          );
        },
      ),
    );

    return box;
  }

  Widget _buildEmptyOrMulti(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      constraints: BoxConstraints(minHeight: widget.minHeightEmpty),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: AppThemes.surfaceColor.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _leadingIcon(filled: false),
            size: 40,
            color: AppThemes.textColorGrey.withValues(alpha: 0.85),
          ),
          const SizedBox(height: 12),
          Text(
            widget.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'serif',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppThemes.textColorPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.hint,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              height: 1.35,
              color: AppThemes.textColorGrey,
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: _browse,
            child: Text(widget.browseLabel),
          ),
          if (widget.maxFiles > 1 && _files.isNotEmpty) ...[
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (var i = 0; i < _files.length; i++)
                    InputChip(
                      label: Text(
                        _files[i].name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      onDeleted: () => _removeAt(i),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DashedRRectPainter extends CustomPainter {
  _DashedRRectPainter({
    required this.color,
    required this.strokeWidth,
    required this.radius,
  });

  final Color color;
  final double strokeWidth;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        strokeWidth / 2,
        strokeWidth / 2,
        size.width - strokeWidth,
        size.height - strokeWidth,
      ),
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        const dash = 7.0;
        const gap = 5.0;
        final end = math.min(distance + dash, metric.length);
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance = end + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRRectPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.radius != radius;
  }
}

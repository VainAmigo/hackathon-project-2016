import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:fpdart/fpdart.dart' hide State;

import 'package:project_temp/core/core.dart';
import 'package:project_temp/source/source.dart';

/// Портрет: локальный asset, затем загрузка по [ArchiveEntry.portraitImageName]
/// (GET /api/v1/files/images/{name} с Bearer), затем устаревший [portraitImageUrl], иначе заглушка.
class ArchiveEntryPortrait extends StatelessWidget {
  const ArchiveEntryPortrait({
    super.key,
    required this.entry,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  final ArchiveEntry entry;
  final double? width;
  final double? height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final asset = entry.portraitAssetPath;
    final apiName = entry.portraitImageName;
    final url = entry.portraitImageUrl;

    final iconSize = (width != null ? width!.clamp(40, 72) : 48.0).toDouble();
    final placeholder = ColoredBox(
      color: AppThemes.textColorGrey.withValues(alpha: 0.12),
      child: Center(
        child: Icon(
          Icons.person_outline,
          size: iconSize,
          color: AppThemes.textColorGrey,
        ),
      ),
    );

    Widget image;
    if (asset != null && asset.isNotEmpty) {
      image = Image.asset(
        asset,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (_, _, _) => placeholder,
      );
    } else if (apiName != null && apiName.isNotEmpty) {
      image = _PortraitFromFilesApi(
        key: ValueKey<String>(apiName),
        imageName: apiName,
        width: width,
        height: height,
        fit: fit,
        placeholder: placeholder,
      );
    } else if (url != null && url.isNotEmpty) {
      image = Image.network(
        url,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (_, _, _) => placeholder,
      );
    } else {
      image = placeholder;
    }

    if (width != null || height != null) {
      return SizedBox(width: width, height: height, child: image);
    }
    return image;
  }
}

class _PortraitFromFilesApi extends StatefulWidget {
  const _PortraitFromFilesApi({
    super.key,
    required this.imageName,
    required this.placeholder,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  final String imageName;
  final Widget placeholder;
  final double? width;
  final double? height;
  final BoxFit fit;

  @override
  State<_PortraitFromFilesApi> createState() => _PortraitFromFilesApiState();
}

class _PortraitFromFilesApiState extends State<_PortraitFromFilesApi> {
  late Future<Either<Failure, Uint8List>> _future;

  @override
  void initState() {
    super.initState();
    _future = sl<FilesRepository>().fetchBytes('images', widget.imageName);
  }

  @override
  void didUpdateWidget(covariant _PortraitFromFilesApi oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageName != widget.imageName) {
      _future = sl<FilesRepository>().fetchBytes('images', widget.imageName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Either<Failure, Uint8List>>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return ColoredBox(
            color: AppThemes.textColorGrey.withValues(alpha: 0.08),
            child: const Center(
              child: SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }
        final data = snap.data;
        if (data == null) return widget.placeholder;
        return data.fold(
          (_) => widget.placeholder,
          (bytes) => Image.memory(
            bytes,
            fit: widget.fit,
            width: widget.width,
            height: widget.height,
            gaplessPlayback: true,
            errorBuilder: (_, _, _) => widget.placeholder,
          ),
        );
      },
    );
  }
}

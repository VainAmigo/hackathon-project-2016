import 'dart:typed_data';

import 'package:share_plus/share_plus.dart';

Future<void> shareDownloadedBytes(Uint8List bytes, String fileName) async {
  await SharePlus.instance.share(
    ShareParams(
      files: [
        XFile.fromData(
          bytes,
          name: fileName,
          mimeType: _guessMime(fileName),
        ),
      ],
      subject: fileName,
    ),
  );
}

String? _guessMime(String name) {
  final lower = name.toLowerCase();
  if (lower.endsWith('.pdf')) return 'application/pdf';
  if (lower.endsWith('.md')) return 'text/markdown';
  if (lower.endsWith('.txt')) return 'text/plain';
  return null;
}

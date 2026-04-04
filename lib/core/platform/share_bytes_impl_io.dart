import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

Future<void> shareDownloadedBytes(Uint8List bytes, String fileName) async {
  final dir = await getTemporaryDirectory();
  final f = File('${dir.path}/$fileName');
  await f.writeAsBytes(bytes);
  await SharePlus.instance.share(
    ShareParams(
      files: [XFile(f.path)],
      subject: fileName,
    ),
  );
}

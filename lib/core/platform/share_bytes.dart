import 'dart:typed_data';

import 'package:project_temp/core/platform/share_bytes_impl_web.dart'
    if (dart.library.io) 'package:project_temp/core/platform/share_bytes_impl_io.dart'
    as share_impl;

/// Сохранение/шеринг бинарных данных источника (веб — из памяти, нативно — temp + share).
Future<void> shareDownloadedBytes(Uint8List bytes, String fileName) =>
    share_impl.shareDownloadedBytes(bytes, fileName);

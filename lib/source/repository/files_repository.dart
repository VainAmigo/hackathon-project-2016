import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';
import 'package:project_temp/source/error/failures.dart';

/// Бинарные ресурсы: GET /api/v1/files/images/{name}, /api/v1/files/files/{name}.
abstract class FilesRepository {
  /// [kind] только `images` или `files`; [resourceName] — имя файла в API.
  Future<Either<Failure, Uint8List>> fetchBytes(String kind, String resourceName);
}

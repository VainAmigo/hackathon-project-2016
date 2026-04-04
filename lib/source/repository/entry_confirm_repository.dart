import 'package:cross_file/cross_file.dart';
import 'package:fpdart/fpdart.dart';
import 'package:project_temp/source/source.dart';

abstract class EntryConfirmRepository {
  /// Multipart: `documentId`, `personData` (JSON-строка), опционально `file` (фото).
  Future<Either<Failure, Unit>> confirm({
    required int documentId,
    required Map<String, dynamic> personData,
    XFile? photo,
  });
}

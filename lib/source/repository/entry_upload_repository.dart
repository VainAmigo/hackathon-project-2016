import 'package:cross_file/cross_file.dart';
import 'package:fpdart/fpdart.dart';
import 'package:project_temp/source/source.dart';

abstract class EntryUploadRepository {
  /// Multipart `file` (PDF), авторизация Bearer.
  Future<Either<Failure, DocumentUploadResponse>> uploadPdf(XFile file);
}

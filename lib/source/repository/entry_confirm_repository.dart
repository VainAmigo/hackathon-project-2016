import 'package:cross_file/cross_file.dart';
import 'package:fpdart/fpdart.dart';
import 'package:project_temp/source/source.dart';

abstract class EntryConfirmRepository {
  /// POST `/api/v1/persons`: `application/json` — `{ "request": { ... }, "photo": "<base64>" }` (как в OpenAPI).
  Future<Either<Failure, Unit>> createPersonFromImport({
    required Map<String, dynamic> request,
    XFile? photo,
  });
}

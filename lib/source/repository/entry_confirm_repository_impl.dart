import 'dart:convert';

import 'package:cross_file/cross_file.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:project_temp/core/core.dart';
import 'package:project_temp/source/source.dart';

class EntryConfirmRepositoryImpl implements EntryConfirmRepository {
  EntryConfirmRepositoryImpl({required DioClient dioClient}) : _dio = dioClient;

  final DioClient _dio;

  @override
  Future<Either<Failure, Unit>> createPersonFromImport({
    required Map<String, dynamic> request,
    XFile? photo,
  }) async {
    try {
      // Контракт API: JSON { "request": { ... }, "photo": "<base64 или пустая строка>" }.
      final body = <String, dynamic>{
        'request': request,
        'photo': photo != null ? base64Encode(await photo.readAsBytes()) : '',
      };
      await _dio.authenticatedDio.post<void>(
        ApiEndpoints.persons,
        data: body,
      );
      return const Right(unit);
    } on DioException catch (e) {
      return Left(_mapDio(e));
    } on Object catch (e) {
      return Left(ExceptionToFailure.map(e));
    }
  }

  Failure _mapDio(DioException e) {
    final inner = e.error;
    if (inner is AppException) {
      return ExceptionToFailure.map(inner);
    }
    return ExceptionToFailure.map(DioExceptionMapper.map(e));
  }
}

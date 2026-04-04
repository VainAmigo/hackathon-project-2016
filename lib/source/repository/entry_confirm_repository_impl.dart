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
  Future<Either<Failure, Unit>> confirm({
    required int documentId,
    required Map<String, dynamic> personData,
    XFile? photo,
  }) async {
    try {
      final map = <String, dynamic>{
        'documentId': documentId.toString(),
        'personData': jsonEncode(personData),
      };
      if (photo != null) {
        map['file'] = await multipartFromXFile(photo);
      }
      final form = FormData.fromMap(map);
      await _dio.authenticatedDio.post<void>(
        ApiEndpoints.confirm,
        data: form,
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

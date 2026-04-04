import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:project_temp/core/core.dart';
import 'package:project_temp/source/source.dart';

class FilesRepositoryImpl implements FilesRepository {
  FilesRepositoryImpl({required DioClient dioClient}) : _dio = dioClient;

  final DioClient _dio;

  static const _allowedKinds = {'images', 'files'};

  @override
  Future<Either<Failure, Uint8List>> fetchBytes(
    String kind,
    String resourceName,
  ) async {
    final k = kind.trim();
    final name = resourceName.trim();
    if (!_allowedKinds.contains(k)) {
      return const Left(ValidationFailure('Недопустимый тип файла'));
    }
    if (name.isEmpty) {
      return const Left(ValidationFailure('Пустое имя файла'));
    }
    try {
      final path = ApiEndpoints.filesResourcePath(k, name);
      final response = await _dio.authenticatedDio.get<dynamic>(
        path,
        options: Options(
          responseType: ResponseType.bytes,
        ),
      );
      final raw = response.data;
      if (raw == null) {
        return const Left(ServerFailure('Пустой файл'));
      }
      if (raw is Uint8List) {
        if (raw.isEmpty) {
          return const Left(ServerFailure('Пустой файл'));
        }
        return Right(raw);
      }
      if (raw is List<int>) {
        if (raw.isEmpty) {
          return const Left(ServerFailure('Пустой файл'));
        }
        return Right(Uint8List.fromList(raw));
      }
      return const Left(ServerFailure('Некорректный ответ файла'));
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

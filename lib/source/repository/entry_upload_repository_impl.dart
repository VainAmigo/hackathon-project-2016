import 'package:cross_file/cross_file.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:project_temp/core/core.dart';
import 'package:project_temp/source/source.dart';

class EntryUploadRepositoryImpl implements EntryUploadRepository {
  EntryUploadRepositoryImpl({required DioClient dioClient}) : _dio = dioClient;

  final DioClient _dio;

  @override
  Future<Either<Failure, DocumentUploadResponse>> uploadPdf(XFile file) async {
    try {
      final multipart = await multipartFromXFile(file);
      final form = FormData.fromMap(<String, dynamic>{
        'file': multipart,
      });
      final response = await _dio.authenticatedDio.post<Map<String, dynamic>>(
        ApiEndpoints.upload,
        data: form,
      );
      final data = response.data;
      if (data == null) {
        return const Left(ServerFailure('Пустой ответ сервера'));
      }
      return Right(DocumentUploadResponse.fromJson(data));
    } on DioException catch (e) {
      return Left(_mapDio(e));
    } on FormatException catch (e) {
      return Left(ValidationFailure(e.message));
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

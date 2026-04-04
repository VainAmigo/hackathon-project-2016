import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:project_temp/core/core.dart';
import 'package:project_temp/source/source.dart';

class PersonsRepositoryImpl implements PersonsRepository {
  PersonsRepositoryImpl({required DioClient dioClient}) : _dio = dioClient;

  final DioClient _dio;

  @override
  Future<Either<Failure, PersonsPageResult>> listPersons(
    PersonsListQuery query,
  ) async {
    try {
      final response = await _dio.authenticatedDio.get<Map<String, dynamic>>(
        ApiEndpoints.persons,
        queryParameters: query.toQueryParameters(),
      );
      final data = response.data;
      if (data == null) {
        return const Left(ServerFailure('Пустой ответ сервера'));
      }
      return Right(_parsePage(data));
    } on DioException catch (e) {
      return Left(_mapDio(e));
    } on FormatException catch (e) {
      return Left(ValidationFailure(e.message));
    } on Object catch (e) {
      return Left(ExceptionToFailure.map(e));
    }
  }

  PersonsPageResult _parsePage(Map<String, dynamic> json) {
    final rawList = json['content'];
    final list = rawList is List
        ? rawList
            .whereType<Map>()
            .map((e) => PersonApiMapper.fromListItem(Map<String, dynamic>.from(e)))
            .toList()
        : <ArchiveEntry>[];

    int asInt(Object? v, [int fallback = 0]) {
      if (v is int) return v;
      if (v is num) return v.toInt();
      return int.tryParse(v?.toString() ?? '') ?? fallback;
    }

    bool asBool(Object? v, [bool fallback = false]) {
      if (v is bool) return v;
      return fallback;
    }

    return PersonsPageResult(
      content: list,
      totalElements: asInt(json['totalElements']),
      totalPages: asInt(json['totalPages'], 1).clamp(1, 1 << 30),
      number: asInt(json['number']),
      size: asInt(json['size'], 20),
      last: asBool(json['last'], true),
      first: asBool(json['first'], true),
    );
  }

  @override
  Future<Either<Failure, ArchiveEntry>> getPerson(String id) async {
    try {
      final path =
          '${ApiEndpoints.persons}/${Uri.encodeComponent(id.trim())}';
      final response = await _dio.authenticatedDio.get<Map<String, dynamic>>(
        path,
      );
      final data = response.data;
      if (data == null) {
        return const Left(ServerFailure('Пустой ответ сервера'));
      }
      return Right(PersonApiMapper.fromDetail(data));
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

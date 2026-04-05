import 'dart:typed_data';

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
  Future<Either<Failure, Uint8List>> fetchPersonAudio(
    String personId,
    String languageCode,
  ) async {
    final id = personId.trim();
    final lang = languageCode.trim().toLowerCase();
    if (id.isEmpty) {
      return const Left(ValidationFailure('Не указан идентификатор записи'));
    }
    if (lang.isEmpty) {
      return const Left(ValidationFailure('Не указан язык'));
    }
    try {
      final path = '${ApiEndpoints.persons}/${Uri.encodeComponent(id)}/audio';
      final response = await _dio.authenticatedDio.get<dynamic>(
        path,
        queryParameters: {'language': lang},
        options: Options(
          responseType: ResponseType.bytes,
        ),
      );
      final bytes = _parseResponseBytes(response.data);
      if (bytes == null || bytes.isEmpty) {
        return const Left(ServerFailure('Пустой аудиофайл'));
      }
      return Right(bytes);
    } on DioException catch (e) {
      return Left(_mapDio(e));
    } on Object catch (e) {
      return Left(ExceptionToFailure.map(e));
    }
  }

  static Uint8List? _parseResponseBytes(Object? raw) {
    if (raw == null) return null;
    if (raw is Uint8List) {
      return raw.isEmpty ? null : raw;
    }
    if (raw is List<int>) {
      return raw.isEmpty ? null : Uint8List.fromList(raw);
    }
    return null;
  }

  @override
  Future<Either<Failure, ArchiveEntry>> getPerson(
    String id, {
    required String languageCode,
  }) async {
    final langKey = languageCode.trim().toLowerCase();
    if (langKey.isEmpty) {
      return const Left(ValidationFailure('Не указан язык'));
    }
    try {
      final path =
          '${ApiEndpoints.persons}/${Uri.encodeComponent(id.trim())}';
      final response = await _dio.authenticatedDio.get<Map<String, dynamic>>(
        path,
        queryParameters: {'language': personsV1LanguageIndex(langKey)},
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

  @override
  Future<Either<Failure, Unit>> moderatePerson(
    String personId, {
    required bool approved,
  }) async {
    final id = personId.trim();
    if (id.isEmpty) {
      return const Left(ValidationFailure('Не указан идентификатор записи'));
    }
    try {
      final path = ApiEndpoints.moderatorPersonPath(id);
      await _dio.authenticatedDio.put<void>(
        path,
        queryParameters: {'approved': approved},
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

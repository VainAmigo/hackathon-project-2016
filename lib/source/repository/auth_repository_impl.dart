import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:project_temp/core/core.dart';
import 'package:project_temp/source/source.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required DioClient dioClient,
    required PreferencesService preferences,
  })  : _dio = dioClient,
        _preferences = preferences;

  final DioClient _dio;
  final PreferencesService _preferences;

  @override
  Future<Either<Failure, LoginResult>> login({
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final response = await _dio.publicDio.post<Map<String, dynamic>>(
        ApiEndpoints.login,
        data: {
          'phoneNumber': phoneNumber,
          'password': password,
        },
      );
      final data = response.data;
      if (data == null) {
        return const Left(ServerFailure('Пустой ответ сервера'));
      }
      final result = LoginResult.fromJson(data);
      if (result.accessToken.isEmpty) {
        return const Left(ValidationFailure('Сервер не вернул токен'));
      }
      await _preferences.saveAccessToken(result.accessToken);
      await _preferences.saveRefreshToken(
        result.refreshToken.isEmpty ? null : result.refreshToken,
      );
      return Right(result);
    } on DioException catch (e) {
      return Left(_mapDio(e));
    } on FormatException catch (e) {
      return Left(ValidationFailure(e.message));
    } on Object catch (e) {
      return Left(ExceptionToFailure.map(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      await _preferences.clearSession();
      return const Right(unit);
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

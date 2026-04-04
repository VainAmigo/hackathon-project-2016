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

  Future<void> _persistLogin(LoginResult result) async {
    await _preferences.saveAccessToken(result.accessToken);
    await _preferences.saveRefreshToken(
      result.refreshToken.isEmpty ? null : result.refreshToken,
    );
    await _preferences.saveAuthProfile(
      username: result.user.username,
      role: result.user.role,
    );
  }

  @override
  Future<Either<Failure, LoginResult>> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _dio.publicDio.post<Map<String, dynamic>>(
        ApiEndpoints.login,
        data: {
          'username': username.trim(),
          'password': password,
        },
      );
      final data = response.data;
      if (data == null) {
        return const Left(ServerFailure('Пустой ответ сервера'));
      }
      final result = LoginResult.fromJson(data);
      if (result.accessToken.isEmpty) {
        return const Left(ValidationFailure('Сервер не вернул accessToken'));
      }
      await _persistLogin(result);
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
  Future<Either<Failure, RegisterResult>> register({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _dio.publicDio.post<Map<String, dynamic>>(
        ApiEndpoints.register,
        data: {
          'username': username.trim(),
          'password': password,
        },
      );
      final data = response.data;
      if (data == null) {
        return const Left(ServerFailure('Пустой ответ сервера'));
      }
      final result = RegisterResult.fromJson(data);
      if (result.username.isEmpty) {
        return const Left(ValidationFailure('Сервер не вернул username'));
      }
      return Right(result);
    } on DioException catch (e) {
      return Left(_mapDio(e));
    } on Object catch (e) {
      return Left(ExceptionToFailure.map(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> refreshTokens() async {
    final refresh = await _preferences.getRefreshToken();
    if (refresh == null || refresh.isEmpty) {
      return const Left(ValidationFailure('Нет refresh-токена'));
    }
    try {
      final response = await _dio.publicDio.post<Map<String, dynamic>>(
        ApiEndpoints.refresh,
        data: {'refreshToken': refresh},
      );
      final data = response.data;
      if (data == null) {
        return const Left(ServerFailure('Пустой ответ сервера'));
      }
      final access = data['accessToken']?.toString() ?? '';
      final newRefresh = data['refreshToken']?.toString() ?? '';
      if (access.isEmpty) {
        return const Left(ValidationFailure('Сервер не вернул accessToken'));
      }
      await _preferences.saveAccessToken(access);
      if (newRefresh.isNotEmpty) {
        await _preferences.saveRefreshToken(newRefresh);
      }
      return const Right(unit);
    } on DioException catch (e) {
      return Left(_mapDio(e));
    } on Object catch (e) {
      return Left(ExceptionToFailure.map(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    final refresh = await _preferences.getRefreshToken();
    if (refresh != null && refresh.isNotEmpty) {
      try {
        await _dio.publicDio.post<Map<String, dynamic>>(
          ApiEndpoints.logout,
          data: {'refreshToken': refresh},
        );
      } on DioException catch (_) {
        // Локальную сессию всё равно сбрасываем.
      } on Object catch (_) {}
    }
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

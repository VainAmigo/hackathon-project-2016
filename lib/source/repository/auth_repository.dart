import 'package:fpdart/fpdart.dart';
import 'package:project_temp/source/source.dart';

abstract class AuthRepository {
  Future<Either<Failure, LoginResult>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, RegisterResult>> register({
    required String email,
    required String password,
  });

  /// Обновляет access/refresh по сохранённому refresh-токену.
  Future<Either<Failure, Unit>> refreshTokens();

  Future<Either<Failure, Unit>> logout();
}

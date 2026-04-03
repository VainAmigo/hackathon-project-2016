import 'package:fpdart/fpdart.dart';
import 'package:project_temp/source/source.dart';

abstract class AuthRepository {
  Future<Either<Failure, LoginResult>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, LoginResult>> register({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  });

  Future<Either<Failure, Unit>> logout();
}

import 'package:fpdart/fpdart.dart';
import 'package:project_temp/source/source.dart';

abstract class AuthRepository {
  Future<Either<Failure, LoginResult>> login({
    required String phoneNumber,
    required String password,
  });

  Future<Either<Failure, Unit>> logout();
}

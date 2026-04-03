
import 'package:project_temp/source/source.dart';

import 'app_exception.dart';

/// Единая точка: [AppException] → [Failure].
abstract final class ExceptionToFailure {
  static Failure map(Object error) {
    if (error is UnauthorizedException) {
      return UnauthorizedFailure(error.message);
    }
    if (error is NetworkException) {
      return NetworkFailure(error.message);
    }
    if (error is ServerException) {
      return ServerFailure(error.message);
    }
    if (error is CacheException) {
      return CacheFailure(error.message);
    }
    if (error is ValidationException) {
      return ValidationFailure(error.message);
    }
    if (error is AppException) {
      return UnknownFailure(error.message);
    }
    return UnknownFailure(error.toString());
  }
}

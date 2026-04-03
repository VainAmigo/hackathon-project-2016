/// Исключения data-слоя. Не используются в domain напрямую — маппятся в [Failure].
sealed class AppException implements Exception {
  const AppException(this.message, [this.code]);

  final String message;
  final int? code;

  @override
  String toString() => 'AppException: $message (code: $code)';
}

final class ServerException extends AppException {
  const ServerException(super.message, [super.code]);
}

final class NetworkException extends AppException {
  const NetworkException(super.message, [super.code]);
}

final class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = 'Unauthorized', super.code]);
}

final class CacheException extends AppException {
  const CacheException(super.message, [super.code]);
}

final class ValidationException extends AppException {
  const ValidationException(super.message, [super.code]);
}

final class UnknownException extends AppException {
  const UnknownException([super.message = 'Unknown error', super.code]);
}

import 'package:dio/dio.dart';

import 'app_exception.dart';

/// Централизованное преобразование [DioException] в [AppException].
abstract final class DioExceptionMapper {
  static AppException map(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException('Превышено время ожидания');
      case DioExceptionType.badCertificate:
        return const NetworkException('Ошибка сертификата');
      case DioExceptionType.connectionError:
        return const NetworkException('Ошибка подключения');
      case DioExceptionType.badResponse:
        return _fromResponse(e);
      case DioExceptionType.cancel:
        return const NetworkException('Запрос отменён');
      case DioExceptionType.unknown:
        if (e.error is AppException) {
          return e.error as AppException;
        }
        return UnknownException(e.message ?? 'Неизвестная ошибка');
    }
  }

  static AppException _fromResponse(DioException e) {
    final status = e.response?.statusCode;
    final data = e.response?.data;

    String message = 'Ошибка сервера';
    if (data is Map<String, dynamic>) {
      final m = data['message'] ?? data['error'] ?? data['detail'];
      if (m is String) message = m;
      if (m is List && m.isNotEmpty) message = m.first.toString();
    } else if (data is String && data.isNotEmpty) {
      message = data;
    }

    if (status == 401 || status == 403) {
      return UnauthorizedException(message, status);
    }
    if (status != null && status >= 400 && status < 500) {
      return ValidationException(message, status);
    }
    return ServerException(message, status);
  }
}

import 'package:dio/dio.dart';

import 'package:project_temp/core/core.dart';

/// Нормализует ошибки Dio в [AppException] для единообразной обработки выше по стеку.
final class ErrorMappingInterceptor extends Interceptor {
  ErrorMappingInterceptor(this._logger);

  final AppLogger _logger;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final mapped = DioExceptionMapper.map(err);
    _logger.e('Mapped Dio error → ${mapped.runtimeType}: ${mapped.message}');
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: mapped,
        message: mapped.message,
        stackTrace: err.stackTrace,
      ),
    );
  }
}

import 'package:dio/dio.dart';

import 'package:project_temp/core/core.dart';

/// Логирование запросов и ответов (тело + заголовки с маскировкой токена).
final class AppLoggingInterceptor extends Interceptor {
  AppLoggingInterceptor(this._logger);

  final AppLogger _logger;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logger.logRequest(
      options.method,
      options.uri.toString(),
      data: options.data,
      headers: options.headers.map((k, v) => MapEntry(k, v)),
    );
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _logger.logResponse(
      response.statusCode,
      response.requestOptions.uri.toString(),
      data: response.data,
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.logHttpError(
      '${err.requestOptions.method} ${err.requestOptions.uri}',
      error: err,
      stack: err.stackTrace,
    );
    handler.next(err);
  }
}

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Централизованный логгер: запросы, ответы, ошибки, отладка.
class AppLogger {
  AppLogger({Logger? logger})
      : _logger = logger ??
            Logger(
              filter: kReleaseMode ? ProductionFilter() : DevelopmentFilter(),
              printer: PrettyPrinter(
                methodCount: 0,
                errorMethodCount: 5,
                lineLength: 100,
                colors: true,
                printEmojis: true,
              ),
            );

  final Logger _logger;

  void d(String message, [dynamic error, StackTrace? stack]) {
    _logger.d(message, error: error, stackTrace: stack);
  }

  void i(String message, [dynamic error, StackTrace? stack]) {
    _logger.i(message, error: error, stackTrace: stack);
  }

  void w(String message, [dynamic error, StackTrace? stack]) {
    _logger.w(message, error: error, stackTrace: stack);
  }

  void e(String message, [dynamic error, StackTrace? stack]) {
    _logger.e(message, error: error, stackTrace: stack);
  }

  /// HTTP: исходящий запрос
  void logRequest(String method, String uri, {Object? data, Map<String, dynamic>? headers}) {
    final safeHeaders = _redactHeaders(headers);
    i('→ $method $uri\nheaders: $safeHeaders\ndata: $data');
  }

  /// HTTP: входящий ответ
  void logResponse(int? statusCode, String uri, {Object? data}) {
    i('← $statusCode $uri\ndata: $data');
  }

  /// HTTP: ошибка на уровне клиента
  void logHttpError(String message, {Object? error, StackTrace? stack}) {
    e('HTTP $message', error, stack);
  }

  static Map<String, dynamic>? _redactHeaders(Map<String, dynamic>? headers) {
    if (headers == null) return null;
    final copy = Map<String, dynamic>.from(headers);
    for (final key in copy.keys.toList()) {
      if (key.toLowerCase() == 'authorization') {
        copy[key] = '***';
      }
    }
    return copy;
  }
}

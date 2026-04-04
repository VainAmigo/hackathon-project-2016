import 'package:dio/dio.dart';

import 'package:project_temp/core/core.dart';

/// Два экземпляра Dio:
/// - [publicDio] — без Authorization (логин, публичные эндпоинты)
/// - [authenticatedDio] — с [AuthInterceptor]
class DioClient {
  DioClient({
    required PreferencesService preferencesService,
    required AppLogger logger,
  })  : _preferences = preferencesService,
        _logger = logger {
    _publicDio = _createDio(includeAuth: false);
    _authDio = _createDio(includeAuth: true);
  }

  final PreferencesService _preferences;
  final AppLogger _logger;

  late final Dio _publicDio;
  late final Dio _authDio;

  /// Публичные запросы (без токена).
  Dio get publicDio => _publicDio;

  /// Запросы с Bearer-токеном.
  Dio get authenticatedDio => _authDio;

  Dio _createDio({required bool includeAuth}) {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 15),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    dio.interceptors.addAll([
      AppLoggingInterceptor(_logger),
      ErrorMappingInterceptor(_logger),
      if (includeAuth) AuthInterceptor(_preferences),
      if (includeAuth)
        TokenRefreshInterceptor(
          preferences: _preferences,
          publicDio: _publicDio,
          authDio: dio,
        ),
    ]);

    return dio;
  }
}

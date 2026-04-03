import 'package:dio/dio.dart';

import 'package:project_temp/core/core.dart';

/// Добавляет `Authorization: Bearer <access_token>` для защищённых запросов.
final class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._preferences);

  final PreferencesService _preferences;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _preferences.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}

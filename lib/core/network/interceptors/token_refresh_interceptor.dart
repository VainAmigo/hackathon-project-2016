import 'package:dio/dio.dart';

import 'package:project_temp/core/network/api_endpoints.dart';
import 'package:project_temp/core/storage/preferences_service.dart';

/// При 401 на защищённом клиенте пробует POST /api/auth/refresh и повторяет запрос.
final class TokenRefreshInterceptor extends QueuedInterceptor {
  TokenRefreshInterceptor({
    required PreferencesService preferences,
    required Dio publicDio,
    required Dio authDio,
  })  : _prefs = preferences,
        _publicDio = publicDio,
        _authDio = authDio;

  final PreferencesService _prefs;
  final Dio _publicDio;
  final Dio _authDio;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401) {
      handler.next(err);
      return;
    }
    final path = err.requestOptions.path;
    if (path.contains(ApiEndpoints.refresh)) {
      handler.next(err);
      return;
    }
    final refresh = await _prefs.getRefreshToken();
    if (refresh == null || refresh.isEmpty) {
      handler.next(err);
      return;
    }
    try {
      final res = await _publicDio.post<Map<String, dynamic>>(
        ApiEndpoints.refresh,
        data: {'refreshToken': refresh},
      );
      final data = res.data;
      if (data == null) {
        throw StateError('empty refresh body');
      }
      final access = data['accessToken']?.toString() ?? '';
      final newRefresh = data['refreshToken']?.toString() ?? '';
      if (access.isEmpty) {
        throw StateError('no accessToken');
      }
      await _prefs.saveAccessToken(access);
      if (newRefresh.isNotEmpty) {
        await _prefs.saveRefreshToken(newRefresh);
      }
      final opts = err.requestOptions;
      opts.headers['Authorization'] = 'Bearer $access';
      final response = await _authDio.fetch(opts);
      handler.resolve(response);
    } on Object catch (_) {
      await _prefs.clearSession();
      handler.next(err);
    }
  }
}

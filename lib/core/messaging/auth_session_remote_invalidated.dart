import 'dart:async';

/// Сигнал из сетевого слоя (например, провал refresh в [TokenRefreshInterceptor]),
/// чтобы [AuthSessionCubit] сбросил UI-сессию и показал snackbar.
abstract final class AuthSessionRemoteInvalidated {
  static final _controller = StreamController<void>.broadcast();

  static Stream<void> get stream => _controller.stream;

  static void notify() {
    if (!_controller.isClosed) {
      _controller.add(null);
    }
  }
}

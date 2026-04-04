import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_temp/core/core.dart';
import 'package:project_temp/features/auth/cubit/auth_session_notice.dart';
import 'package:project_temp/features/auth/cubit/auth_session_state.dart';
import 'package:project_temp/source/source.dart';

class AuthSessionCubit extends Cubit<AuthSessionState> {
  AuthSessionCubit(this._prefs, this._auth) : super(const AuthSessionState());

  final PreferencesService _prefs;
  final AuthRepository _auth;

  Future<void> bootstrap() async {
    final access = await _prefs.getAccessToken();
    final refresh = await _prefs.getRefreshToken();
    var authed =
        (access != null && access.isNotEmpty) ||
        (refresh != null && refresh.isNotEmpty);

    if (!authed) {
      emit(const AuthSessionState(bootstrapped: true));
      return;
    }

    if (refresh != null && refresh.isNotEmpty) {
      final refreshed = await _auth.refreshTokens();
      if (refreshed.isLeft()) {
        await _auth.logout();
        emit(
          const AuthSessionState(
            bootstrapped: true,
            notice: AuthSessionNotice.refreshFailedOnStartup,
          ),
        );
        return;
      }
    }

    final token = await _prefs.getAccessToken();
    authed = token != null && token.isNotEmpty;
    User? user;
    if (authed) {
      final storedEmail = await _prefs.getStoredEmail();
      final role = await _prefs.getStoredRole();
      if (storedEmail != null && storedEmail.isNotEmpty) {
        user = User(email: storedEmail, role: role ?? '');
      }
    }
    emit(
      AuthSessionState(
        bootstrapped: true,
        isAuthenticated: authed,
        user: authed ? user : null,
      ),
    );
  }

  void setSession(User user) {
    emit(
      state.copyWith(
        isAuthenticated: true,
        user: user,
        notice: AuthSessionNotice.loginSuccess,
      ),
    );
  }

  void clearSession({AuthSessionNotice notice = AuthSessionNotice.none}) {
    emit(
      state.copyWith(isAuthenticated: false, clearUser: true, notice: notice),
    );
  }

  /// После [AuthSessionRemoteInvalidated.notify] (провал refresh при запросе).
  void markSessionExpiredByRefresh() {
    emit(
      state.copyWith(
        isAuthenticated: false,
        clearUser: true,
        notice: AuthSessionNotice.sessionExpiredRefresh,
      ),
    );
  }

  void clearNotice() {
    if (state.notice == AuthSessionNotice.none) return;
    emit(state.copyWith(clearNotice: true));
  }
}

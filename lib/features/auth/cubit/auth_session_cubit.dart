import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_temp/core/core.dart';
import 'package:project_temp/features/auth/cubit/auth_session_state.dart';
import 'package:project_temp/source/source.dart';

class AuthSessionCubit extends Cubit<AuthSessionState> {
  AuthSessionCubit(this._prefs, this._auth) : super(const AuthSessionState());

  final PreferencesService _prefs;
  final AuthRepository _auth;

  Future<void> bootstrap() async {
    final access = await _prefs.getAccessToken();
    final refresh = await _prefs.getRefreshToken();
    var authed = (access != null && access.isNotEmpty) ||
        (refresh != null && refresh.isNotEmpty);

    if (!authed) {
      emit(const AuthSessionState(bootstrapped: true));
      return;
    }

    if (refresh != null && refresh.isNotEmpty) {
      final refreshed = await _auth.refreshTokens();
      if (refreshed.isLeft()) {
        await _auth.logout();
        emit(const AuthSessionState(bootstrapped: true));
        return;
      }
    }

    final token = await _prefs.getAccessToken();
    authed = token != null && token.isNotEmpty;
    User? user;
    if (authed) {
      final name = await _prefs.getStoredUsername();
      final role = await _prefs.getStoredRole();
      if (name != null && name.isNotEmpty) {
        user = User(username: name, role: role ?? '');
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
      ),
    );
  }

  void clearSession() {
    emit(
      state.copyWith(
        isAuthenticated: false,
        clearUser: true,
      ),
    );
  }
}

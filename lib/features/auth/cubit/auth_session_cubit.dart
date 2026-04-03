import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_temp/core/core.dart';
import 'package:project_temp/features/auth/cubit/auth_session_state.dart';
import 'package:project_temp/source/source.dart';

class AuthSessionCubit extends Cubit<AuthSessionState> {
  AuthSessionCubit(this._prefs) : super(const AuthSessionState());

  final PreferencesService _prefs;

  Future<void> bootstrap() async {
    final token = await _prefs.getAccessToken();
    final authed = token != null && token.isNotEmpty;
    emit(state.copyWith(bootstrapped: true, isAuthenticated: authed));
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

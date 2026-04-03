import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_temp/features/auth/cubit/login_state.dart';
import 'package:project_temp/source/source.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._auth) : super(const LoginState());

  final AuthRepository _auth;

  Future<void> login({required String email, required String password}) async {
    emit(
      state.copyWith(
        isSubmitting: true,
        clearFailure: true,
        clearUser: true,
      ),
    );
    final result = await _auth.login(email: email, password: password);
    result.fold(
      (f) => emit(
        state.copyWith(
          isSubmitting: false,
          failureMessage: f.message,
        ),
      ),
      (res) => emit(
        LoginState(
          isSubmitting: false,
          user: res.user,
        ),
      ),
    );
  }
}

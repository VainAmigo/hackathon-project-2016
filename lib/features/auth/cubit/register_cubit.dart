import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_temp/features/auth/cubit/register_state.dart';
import 'package:project_temp/source/source.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this._auth) : super(const RegisterState());

  final AuthRepository _auth;

  Future<void> register({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  }) async {
    emit(
      state.copyWith(
        isSubmitting: true,
        clearFailure: true,
        clearUser: true,
      ),
    );
    final result = await _auth.register(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
    );
    result.fold(
      (f) => emit(
        state.copyWith(
          isSubmitting: false,
          failureMessage: f.message,
        ),
      ),
      (res) => emit(
        RegisterState(
          isSubmitting: false,
          user: res.user,
        ),
      ),
    );
  }
}

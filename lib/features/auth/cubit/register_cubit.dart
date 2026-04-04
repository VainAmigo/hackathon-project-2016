import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_temp/features/auth/cubit/register_state.dart';
import 'package:project_temp/source/source.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this._auth) : super(const RegisterState());

  final AuthRepository _auth;

  Future<void> register({
    required String username,
    required String password,
  }) async {
    emit(
      state.copyWith(
        isSubmitting: true,
        clearFailure: true,
        clearRegistration: true,
      ),
    );
    final result = await _auth.register(
      username: username,
      password: password,
    );
    result.fold(
      (f) => emit(
        state.copyWith(
          isSubmitting: false,
          failureMessage: f.message,
          clearRegistration: true,
        ),
      ),
      (res) => emit(
        RegisterState(
          isSubmitting: false,
          registration: res,
        ),
      ),
    );
  }
}

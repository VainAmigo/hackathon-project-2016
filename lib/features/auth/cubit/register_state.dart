import 'package:equatable/equatable.dart';
import 'package:project_temp/source/source.dart';

class RegisterState extends Equatable {
  const RegisterState({
    this.isSubmitting = false,
    this.failureMessage,
    this.user,
  });

  final bool isSubmitting;
  final String? failureMessage;
  final User? user;

  RegisterState copyWith({
    bool? isSubmitting,
    String? failureMessage,
    User? user,
    bool clearFailure = false,
    bool clearUser = false,
  }) {
    return RegisterState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      failureMessage:
          clearFailure ? null : (failureMessage ?? this.failureMessage),
      user: clearUser ? null : (user ?? this.user),
    );
  }

  @override
  List<Object?> get props => [isSubmitting, failureMessage, user];
}

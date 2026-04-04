import 'package:equatable/equatable.dart';
import 'package:project_temp/source/source.dart';

class RegisterState extends Equatable {
  const RegisterState({
    this.isSubmitting = false,
    this.failureMessage,
    this.registration,
  });

  final bool isSubmitting;
  final String? failureMessage;
  final RegisterResult? registration;

  RegisterState copyWith({
    bool? isSubmitting,
    String? failureMessage,
    RegisterResult? registration,
    bool clearFailure = false,
    bool clearRegistration = false,
  }) {
    return RegisterState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      failureMessage:
          clearFailure ? null : (failureMessage ?? this.failureMessage),
      registration: clearRegistration
          ? null
          : (registration ?? this.registration),
    );
  }

  @override
  List<Object?> get props => [isSubmitting, failureMessage, registration];
}

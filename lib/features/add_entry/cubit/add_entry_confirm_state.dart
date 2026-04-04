import 'package:equatable/equatable.dart';

class AddEntryConfirmState extends Equatable {
  const AddEntryConfirmState({
    this.isSubmitting = false,
    this.errorMessage,
    this.success = false,
  });

  final bool isSubmitting;
  final String? errorMessage;
  final bool success;

  AddEntryConfirmState copyWith({
    bool? isSubmitting,
    String? errorMessage,
    bool? success,
    bool clearError = false,
  }) {
    return AddEntryConfirmState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      success: success ?? this.success,
    );
  }

  @override
  List<Object?> get props => [isSubmitting, errorMessage, success];
}

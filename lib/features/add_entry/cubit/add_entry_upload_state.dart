import 'package:equatable/equatable.dart';
import 'package:project_temp/source/source.dart';

class AddEntryUploadState extends Equatable {
  const AddEntryUploadState({
    this.isUploading = false,
    this.errorMessage,
    this.result,
  });

  final bool isUploading;
  final String? errorMessage;
  final DocumentUploadResponse? result;

  AddEntryUploadState copyWith({
    bool? isUploading,
    String? errorMessage,
    DocumentUploadResponse? result,
    bool clearError = false,
    bool clearResult = false,
  }) {
    return AddEntryUploadState(
      isUploading: isUploading ?? this.isUploading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      result: clearResult ? null : (result ?? this.result),
    );
  }

  @override
  List<Object?> get props => [isUploading, errorMessage, result];
}

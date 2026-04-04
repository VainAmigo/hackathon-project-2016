import 'package:cross_file/cross_file.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_temp/features/add_entry/cubit/add_entry_upload_state.dart';
import 'package:project_temp/source/source.dart';

class AddEntryUploadCubit extends Cubit<AddEntryUploadState> {
  AddEntryUploadCubit(this._repo) : super(const AddEntryUploadState());

  final EntryUploadRepository _repo;

  Future<void> uploadPdf(XFile file) async {
    emit(
      state.copyWith(isUploading: true, clearError: true, clearResult: true),
    );
    final out = await _repo.uploadPdf(file);
    out.fold(
      (f) => emit(state.copyWith(isUploading: false, errorMessage: f.message)),
      (doc) => emit(AddEntryUploadState(isUploading: false, result: doc)),
    );
  }

  void clearError() => emit(state.copyWith(clearError: true));

  void clearResult() => emit(state.copyWith(clearResult: true));

  void reset() => emit(const AddEntryUploadState());
}

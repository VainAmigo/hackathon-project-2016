import 'package:cross_file/cross_file.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_temp/features/add_entry/cubit/add_entry_confirm_state.dart';
import 'package:project_temp/source/source.dart';

class AddEntryConfirmCubit extends Cubit<AddEntryConfirmState> {
  AddEntryConfirmCubit(this._repo) : super(const AddEntryConfirmState());

  final EntryConfirmRepository _repo;

  Future<void> submit({
    required int documentId,
    required Map<String, dynamic> personData,
    XFile? photo,
  }) async {
    emit(
      state.copyWith(
        isSubmitting: true,
        clearError: true,
        success: false,
      ),
    );
    final out = await _repo.confirm(
      documentId: documentId,
      personData: personData,
      photo: photo,
    );
    out.fold(
      (f) => emit(
        state.copyWith(
          isSubmitting: false,
          errorMessage: f.message,
        ),
      ),
      (_) => emit(
        const AddEntryConfirmState(
          isSubmitting: false,
          success: true,
        ),
      ),
    );
  }

  void clearError() => emit(state.copyWith(clearError: true));

  void clearSuccess() => emit(state.copyWith(success: false));

  void reset() => emit(const AddEntryConfirmState());
}

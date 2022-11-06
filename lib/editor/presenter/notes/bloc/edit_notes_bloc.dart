import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:psws_storage/editor/domain/model/directory_model.dart';
import 'package:psws_storage/editor/domain/usecase/get_directory_usecase.dart';
import 'package:psws_storage/editor/domain/usecase/update_directory_usecase.dart';

class EditNotesBloc extends Cubit<EditNotesModel> {
  final UpdateDirectoryUseCase updateDirectory;
  final GetDirectoryUseCase getDirectory;

  EditNotesBloc({
    required this.updateDirectory,
    required this.getDirectory,
  }) : super(EditNotesModel.initial());

  Future<void> getNoteData(int idHiveObject) async {
    final dfdf = await getDirectory(idHiveObject);
    emit(state.copyWith(note: dfdf));
  }

  Future<void> saveNote(String content) async {
    final DirectoryModel? note = state.note?.copyWith(content: content);
    if (note != null) {
      await updateDirectory(note);
    }
  }

  void updateEditMode(bool readOnly) {
    emit(state.copyWith(readOnly: readOnly));
  }
}

class EditNotesModel {
  final DirectoryModel? note;
  final bool readOnly;

  EditNotesModel({
    this.note,
    required this.readOnly,
  });

  EditNotesModel.initial()
      : note = null,
        readOnly = true;

  EditNotesModel copyWith({DirectoryModel? note, bool? readOnly}) =>
      EditNotesModel(
        note: note ?? this.note,
        readOnly: readOnly ?? this.readOnly,
      );
}

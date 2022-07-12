import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:psws_storage/domain/model/directory_model.dart';
import 'package:psws_storage/domain/usecase/get_directory_usecase.dart';
import 'package:psws_storage/domain/usecase/update_directory_usecase.dart';

class EditNotesBloc extends Cubit<EditNotesModel> {
  final UpdateDirectoryUseCase updateDirectory;
  final GetDirectoryUseCase getDirectory;

  EditNotesBloc({
    required this.updateDirectory,
    required this.getDirectory,
  }) : super(EditNotesModel.initial());

  Future<void> getNoteData(int idHiveObject) async {
    emit(state.copyWith(note: await getDirectory(idHiveObject)));
  }

  Future<void> saveNote(String content) async {
    final DirectoryModel? note = state.note?.copyWith(content: content);
    if (note != null) {
      await updateDirectory(note);
    }
  }
}

class EditNotesModel {
  final DirectoryModel? note;

  EditNotesModel({this.note});

  EditNotesModel.initial() : note = null;

  EditNotesModel copyWith({DirectoryModel? note}) =>
      EditNotesModel(note: note ?? this.note);
}

import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:psws_storage/editor/domain/model/directory_model.dart';
import 'package:psws_storage/editor/domain/usecase/get_directory_usecase.dart';
import 'package:psws_storage/editor/domain/usecase/update_directory_usecase.dart';
import 'package:psws_storage/editor/presenter/main/const/constants.dart';

class EditNotesBloc extends Cubit<EditNotesModel> {
  final UpdateDirectoryUseCase updateDirectory;
  final GetDirectoryUseCase getDirectory;

  EditNotesBloc({
    required this.updateDirectory,
    required this.getDirectory,
  }) : super(EditNotesModel.initial());

  Future<void> getNoteData(
    int idHiveObject, {
    required List<DirectoryModel> directories,
  }) async {
    final note = await getDirectory(idHiveObject);

    emit(state.copyWith(
      note: note,
      directories: directories,
    ));
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
  final List<DirectoryModel> directories;
  final bool readOnly;

  EditNotesModel({
    this.note,
    required this.readOnly,
    required this.directories,
  });

  EditNotesModel.initial()
      : note = null,
        directories = [],
        readOnly = true;

  EditNotesModel copyWith({
    DirectoryModel? note,
    bool? readOnly,
    List<DirectoryModel>? directories,
  }) =>
      EditNotesModel(
        note: note ?? this.note,
        readOnly: readOnly ?? this.readOnly,
        directories: directories ?? this.directories,
      );

  List<DirectoryModel> get allNotesWithoutCurrent {
    if (directories.isEmpty) {
      return directories;
    }

    return directories
        .where((element) => !element.isFolder && element.id != note?.id)
        .toList();
  }

  List<String>? _getPathByParentId(DirectoryModel? choosingDirectory) {
    if (choosingDirectory == null) return null;

    List<String> path = [choosingDirectory.name];
    String searchParentId = choosingDirectory.parentId;
    while (searchParentId != rootDirectoryId) {
      final parentDirectory = directories
          .firstWhereOrNull((element) => element.id == searchParentId);
      if (parentDirectory != null) {
        path.add(parentDirectory.name);
        searchParentId = parentDirectory.parentId;
      } else {
        searchParentId = rootDirectoryId;
      }
    }

    return path.reversed.toList();
  }

  String? getPath(DirectoryModel? choosingDirectory) {
    final listPath = _getPathByParentId(choosingDirectory);
    if (listPath == null) return null;

    String pathString = '..';
    for (String element in listPath) {
      pathString += '/$element';
    }
    return pathString;
  }

  DirectoryModel? getDirectoryById(String? id) {
    if (id == null) return null;

    return directories.firstWhereOrNull((element) => element.id == id);
  }
}

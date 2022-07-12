import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:psws_storage/domain/model/directory_model.dart';
import 'package:psws_storage/domain/usecase/add_file_usecase.dart';
import 'package:psws_storage/domain/usecase/delete_directory_usecase.dart';
import 'package:psws_storage/domain/usecase/delete_list_directories_usecase.dart';
import 'package:psws_storage/domain/usecase/get_list_directories_usecase.dart';
import 'package:psws_storage/presenter/main/bloc/main_model.dart';
import 'package:psws_storage/presenter/main/const/constants.dart';
import 'package:uuid_type/uuid_type.dart';

class MainBloc extends Cubit<MainModelState> {
  final AddFileUseCase _addFileUseCase;
  final GetListDirectoriesUseCase _getListDirectories;
  final DeleteDirectoryUseCase _deleteDirectoryUseCase;
  final DeleteListDirectoriesUseCase _deleteListDirectories;

  MainBloc({
    required AddFileUseCase addFileUseCase,
    required GetListDirectoriesUseCase getListDirectoriesUseCase,
    required DeleteDirectoryUseCase deleteDirectoryUseCase,
    required DeleteListDirectoriesUseCase deleteListDirectories,
  })  : _addFileUseCase = addFileUseCase,
        _getListDirectories = getListDirectoriesUseCase,
        _deleteDirectoryUseCase = deleteDirectoryUseCase,
        _deleteListDirectories = deleteListDirectories,
        super(MainModelState.empty());

  void initBloc() async {
    final directories = await _getListDirectories();
    emit(state.copyWith(directories: directories));
  }

  void openFolder(DirectoryModel directory) {
    emit(state.copyWith(parentId: directory.id));
  }

  void closeFolder() {
    final DirectoryModel? parentDirectory = state.directories.firstWhereOrNull(
          (element) => element.id == state.parentId,
    );

    if (parentDirectory != null && state.parentId != rootDirectory) {
      emit(state.copyWith(parentId: parentDirectory.parentId));
    }
  }

  void addFolder(String folderName) async {
    final directories = await _addFileUseCase(_getDirectory(name: folderName));

    emit(state.copyWith(
      directories: directories,
    ));
  }

  void addFile(String fileName) async {
    final directories =
    await _addFileUseCase(_getDirectory(name: fileName, isFolder: false));

    emit(state.copyWith(
      directories: directories,
    ));
  }

  void deleteFile(DirectoryModel model) async {
    if (model.isFolder) {
      final List<int> keys = state
          .getListAttachedFiles(model.id)
          .map((e) => e.idHiveObject)
          .toList();
      await _deleteListDirectories(keys);
    }
    emit(state.copyWith(
      directories: await _deleteDirectoryUseCase(model),
    ));
  }

  Future<void> changeCurrentBackPressTime(DateTime currentBackPressTime) async {
    return emit(state.copyWith(currentBackPressTime: currentBackPressTime));
  }

  DirectoryModel _getDirectory({bool isFolder = true, required String name, String content = ''}) =>
      DirectoryModel(
        isFolder: isFolder,
        id: TimeUuidGenerator().generate().toString(),
        parentId: state.parentId,
        createdDate: DateTime.now(),
        name: name,
        content: content,
        idHiveObject: -1,
      );
}

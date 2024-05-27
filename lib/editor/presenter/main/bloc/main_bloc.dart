import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:psws_storage/app/domain/entity/environment.dart';
import 'package:psws_storage/editor/domain/model/directory_model.dart';
import 'package:psws_storage/editor/domain/usecase/add_file_usecase.dart';
import 'package:psws_storage/editor/domain/usecase/delete_directory_usecase.dart';
import 'package:psws_storage/editor/domain/usecase/delete_list_directories_usecase.dart';
import 'package:psws_storage/editor/domain/usecase/get_directory_usecase.dart';
import 'package:psws_storage/editor/domain/usecase/get_list_directories_usecase.dart';
import 'package:psws_storage/editor/domain/usecase/update_directory_usecase.dart';
import 'package:psws_storage/editor/presenter/main/bloc/main_model.dart';
import 'package:psws_storage/editor/presenter/main/const/constants.dart';
import 'package:uuid_type/uuid_type.dart';

class MainBloc extends Cubit<MainModelState> {
  final AddFileUseCase _addFileUseCase;
  final GetListDirectoriesUseCase _getListDirectories;
  final DeleteDirectoryUseCase _deleteDirectoryUseCase;
  final DeleteListDirectoriesUseCase _deleteListDirectories;
  final UpdateDirectoryUseCase _updateDirectory;
  final GetDirectoryUseCase _getDirectoryUseCase;
  final Sort _sort;

  MainBloc({
    required AddFileUseCase addFileUseCase,
    required GetListDirectoriesUseCase getListDirectoriesUseCase,
    required DeleteDirectoryUseCase deleteDirectoryUseCase,
    required DeleteListDirectoriesUseCase deleteListDirectories,
    required UpdateDirectoryUseCase updateDirectory,
    required GetDirectoryUseCase getDirectory,
    required Sort sort,
  })  : _addFileUseCase = addFileUseCase,
        _getListDirectories = getListDirectoriesUseCase,
        _deleteDirectoryUseCase = deleteDirectoryUseCase,
        _deleteListDirectories = deleteListDirectories,
        _updateDirectory = updateDirectory,
        _getDirectoryUseCase = getDirectory,
        _sort = sort,
        super(MainModelState.empty(sort));

  void initBloc() async {
    final directories = await _getListDirectories();
    emit(state.copyWith(directories: directories));
  }

  Future<void> changeToDefaultState() async {
    final directories = await _getListDirectories();
    final defaultState = MainModelState.empty(_sort);
    emit(
      defaultState.copyWith(directories: directories),
    );
  }

  void openFolder(DirectoryModel directory) {
    List<String> path = state.path..add(directory.name);

    emit(state.copyWith(parentId: directory.id, path: path));
  }

  void openFolderFromSearch(DirectoryModel directory) {
    List<String> path = state.getPathByParentId(directory);

    emit(state.copyWith(parentId: directory.id, path: path));
  }

  Future<void> changeParentId(
      {required DirectoryModel directory,
      required String destinationId}) async {
    final updatedDirectory = directory.copyWith(
      parentId: destinationId,
    );

    emit(
      state.copyWith(
        directories: await _updateDirectory(updatedDirectory),
      ),
    );
  }

  void closeFolder() {
    final DirectoryModel? parentDirectory = state.directories.firstWhereOrNull(
      (element) => element.id == state.parentId,
    );

    if (parentDirectory != null && state.parentId != rootDirectoryId) {
      List<String> path = state.path..removeLast();

      emit(state.copyWith(parentId: parentDirectory.parentId, path: path));
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

  Future<void> updateName(
      {required DirectoryModel model, required String newName}) async {
    final directory = await _getDirectoryUseCase(model.idHiveObject);
    if (directory != null) {
      emit(state.copyWith(
          directories:
              await _updateDirectory(directory.copyWith(name: newName))));
    }
  }

  Future<void> changeCurrentBackPressTime(DateTime currentBackPressTime) async {
    return emit(state.copyWith(currentBackPressTime: currentBackPressTime));
  }

  Future<void> updatedSortList(Sort sort) async {
    return emit(state.copyWith(
      sort: sort,
    ));
  }

  Future<void> updateDirectoryAfterChanging(int hiveId) async {
    final directory = await _getDirectoryUseCase(hiveId);

    if(directory != null){
      final dir = List<DirectoryModel>.from(state.directories);
      final index = state.directories.indexOf(directory);

      if(index != -1){
        dir[index] = directory;

        emit(state.copyWith(directories: dir));
      }

    }
  }

  DirectoryModel _getDirectory(
          {bool isFolder = true, required String name, String content = ''}) =>
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

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:psws_storage/domain/model/directory_model.dart';
import 'package:psws_storage/domain/usecase/add_file_usecase.dart';
import 'package:psws_storage/domain/usecase/delete_directory_usecase.dart';
import 'package:psws_storage/domain/usecase/get_list_directories_usecase.dart';
import 'package:psws_storage/presenter/main/bloc/main_model.dart';
import 'package:uuid_type/uuid_type.dart';

class MainBloc extends Cubit<MainModel> {
  final AddFileUseCase _addFileUseCase;
  final GetListDirectoriesUseCase _getListDirectories;
  final DeleteDirectoryUseCase _deleteDirectoryUseCase;

  MainBloc({
    required AddFileUseCase addFileUseCase,
    required GetListDirectoriesUseCase getListDirectoriesUseCase,
    required DeleteDirectoryUseCase deleteDirectoryUseCase,
  })  : _addFileUseCase = addFileUseCase,
        _getListDirectories = getListDirectoriesUseCase,
        _deleteDirectoryUseCase = deleteDirectoryUseCase,
        super(MainModel.empty());

  void initBloc() async {
    final directories = await _getListDirectories();
    emit(state.copyWith(directories: directories));
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
    emit(state.copyWith(
      directories: await _deleteDirectoryUseCase(model),
    ));
  }

  DirectoryModel _getDirectory(
          {bool isFolder = true, required String name, String content = ''}) =>
      DirectoryModel(
        isFolder: isFolder,
        id: TimeUuidGenerator().generate().toString(),
        parentId: state.currentDirectory,
        createdDate: DateTime.now(),
        name: name,
        content: content,
      );
}

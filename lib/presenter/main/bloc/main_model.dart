import 'package:psws_storage/domain/model/directory_model.dart';
import 'package:psws_storage/presenter/main/const/constants.dart';

class MainModel {
  final String currentDirectory;
  final List<DirectoryModel> directories;

  MainModel({required this.currentDirectory, required this.directories});

  MainModel.empty()
      : currentDirectory = rootDirectory,
        directories = [];

  MainModel copyWith({
    String? currentDirectory,
    List<DirectoryModel>? directories,
  }) {
    return MainModel(
      currentDirectory: currentDirectory ?? this.currentDirectory,
      directories: directories ?? this.directories,
    );
  }

  List<DirectoryModel> get sortedList {
    if (directories.isEmpty) {
      return directories;
    }

    final folders = directories.where((element) => element.isFolder);
    final files = directories.where((element) => !element.isFolder);

    return [...folders, ...files];
  }
}

enum ThemeType { light, dark }

import 'package:psws_storage/domain/model/directory_model.dart';
import 'package:psws_storage/presenter/main/const/constants.dart';

class MainModelState {
  final String parentId;
  final List<DirectoryModel> directories;
  final DateTime currentBackPressTime;

  MainModelState({
    required this.directories,
    required this.currentBackPressTime,
    required this.parentId,
  });

  MainModelState.empty()
      : parentId = rootDirectory,
        currentBackPressTime = DateTime(1980),
        directories = [];

  MainModelState copyWith({
    String? parentId,
    List<DirectoryModel>? directories,
    DateTime? currentBackPressTime,
  }) {
    return MainModelState(
      parentId: parentId ?? this.parentId,
      currentBackPressTime: currentBackPressTime ?? this.currentBackPressTime,
      directories: directories ?? this.directories,
    );
  }

  List<DirectoryModel> getChildren(String parentId) {
    return directories
        .where(
          (element) => element.parentId == parentId,
        )
        .toList();
  }

  List<DirectoryModel> get sortedList {
    if (directories.isEmpty) {
      return directories;
    }

    final List<DirectoryModel> sortedDirectory = getChildren(parentId);

    final folders = sortedDirectory.where((element) => element.isFolder);
    final files = sortedDirectory.where((element) => !element.isFolder);

    return [
      ...folders,
      ...files,
    ];
  }
}

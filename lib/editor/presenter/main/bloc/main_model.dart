import 'package:collection/collection.dart';
import 'package:psws_storage/editor/domain/model/directory_model.dart';
import 'package:psws_storage/editor/presenter/main/const/constants.dart';

class MainModelState {
  final String parentId;
  final List<DirectoryModel> directories;
  final List<String> path;
  final DateTime currentBackPressTime;

  MainModelState({
    required this.directories,
    required this.currentBackPressTime,
    required this.parentId,
    required this.path,
  });

  MainModelState.empty()
      : parentId = rootDirectory,
        currentBackPressTime = DateTime(1980),
        path = [],
        directories = [];

  MainModelState copyWith({
    String? parentId,
    List<DirectoryModel>? directories,
    List<String>? path,
    DateTime? currentBackPressTime,
  }) {
    return MainModelState(
      parentId: parentId ?? this.parentId,
      currentBackPressTime: currentBackPressTime ?? this.currentBackPressTime,
      path: path ?? this.path,
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

  String getPathString() {
    String pathString = '..';
    for (String element in path) {
      pathString += '/$element';
    }
    return pathString;
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

  List<String> getPathByParentId(DirectoryModel choosingDirectory) {
    List<String> path = [choosingDirectory.name];
    String searchParentId = choosingDirectory.parentId;
    while (searchParentId != rootDirectory) {
      final parentDirectory = directories.firstWhereOrNull((element) => element.id == searchParentId);
      if (parentDirectory != null) {
        path.add(parentDirectory.name);
        searchParentId = parentDirectory.parentId;
      } else {
        searchParentId = rootDirectory;
      }
    }

    return path.reversed.toList();
  }

  List<DirectoryModel> getListAttachedFiles(String parentId) {
    List<DirectoryModel> _getSubFolders(List<DirectoryModel> input) {
      final List<DirectoryModel> subFolders = [];
      for (final element in input) {
        final listChildren = getChildren(element.id);
        if (listChildren.isEmpty) {
          subFolders.add(element);
        } else {
          subFolders.add(element);
          subFolders.addAll(_getSubFolders(listChildren));
        }
      }

      return subFolders;
    }

    final List<DirectoryModel> childrenFolders = getChildren(parentId);

    return _getSubFolders(childrenFolders);
  }
}

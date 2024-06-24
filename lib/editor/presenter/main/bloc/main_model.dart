import 'package:collection/collection.dart';
import 'package:psws_storage/app/domain/entity/environment.dart';
import 'package:psws_storage/editor/domain/model/directory_model.dart';
import 'package:psws_storage/editor/presenter/main/const/constants.dart';

class MainModelState {
  final String parentId;
  final List<DirectoryModel> directories;
  final List<String> path;
  final DateTime currentBackPressTime;
  final Sort sort;

  MainModelState({
    required this.directories,
    required this.currentBackPressTime,
    required this.parentId,
    required this.path,
    required this.sort,
  });

  MainModelState.empty(this.sort)
      : parentId = rootDirectoryId,
        currentBackPressTime = DateTime(1980),
        path = [],
        directories = [];

  List<DirectoryModel> _getChildren(String parentId) {
    return directories
        .where(
          (element) => element.parentId == parentId,
        )
        .toList();
  }

  List<DirectoryModel> get directoriesWithoutLink =>
      directories.where((element) => element.destinationId == null).toList();

  String getPathString() {
    return convertListToPathText(path);
  }

  String convertListToPathText(List<String> path) {
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

    final List<DirectoryModel> sortedDirectory = _getChildren(parentId);

    return [
      ..._getFolders(sortedDirectory),
      ..._getFiles(sortedDirectory),
    ];
  }

  List<DirectoryModel> _getFolders(List<DirectoryModel> sortedListByParentId) {
    List<DirectoryModel> folders =
        sortedListByParentId.where((element) => element.isFolder).toList();
    if (sort.folderInclude) {
      final ascending = sort.sortType == SortType.asc;
      folders = sort.sortBy == SortBy.name
          ? _sortAlphabetic(folders, ascending)
          : _sortByDate(folders, ascending);
    }
    return folders;
  }

  List<DirectoryModel> _getFiles(List<DirectoryModel> sortedListByParentId) {
    List<DirectoryModel> files =
        sortedListByParentId.where((element) => !element.isFolder).toList();
    final ascending = sort.sortType == SortType.asc;
    files = sort.sortBy == SortBy.name
        ? _sortAlphabetic(files, ascending)
        : _sortByDate(files, ascending);

    return files;
  }

  List<DirectoryModel> _sortAlphabetic(
    List<DirectoryModel> list,
    bool ascending,
  ) {
    if (ascending) {
      list.sort((a, b) {
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });
    } else {
      list.sort((a, b) {
        return b.name.toLowerCase().compareTo(a.name.toLowerCase());
      });
    }

    return list;
  }

  List<DirectoryModel> _sortByDate(
    List<DirectoryModel> list,
    bool ascending,
  ) {
    if (ascending) {
      list.sort((a, b) {
        return a.createdDate.compareTo(b.createdDate);
      });
    } else {
      list.sort((a, b) {
        return b.createdDate.compareTo(a.createdDate);
      });
    }

    return list;
  }

  List<DirectoryModel> get allFolders {
    if (directories.isEmpty) {
      return directories;
    }

    return directories
        .where((element) => element.isFolder && element.destinationId == null)
        .toList();
  }

  List<String> getPathByParentId(DirectoryModel choosingDirectory) {
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

  List<DirectoryModel> getListAttachedFiles(String parentId) {
    List<DirectoryModel> getSubFolders(List<DirectoryModel> input) {
      final List<DirectoryModel> subFolders = [];
      for (final element in input) {
        final listChildren = _getChildren(element.id);
        if (listChildren.isEmpty) {
          subFolders.add(element);
        } else {
          subFolders.add(element);
          subFolders.addAll(getSubFolders(listChildren));
        }
      }

      return subFolders;
    }

    final List<DirectoryModel> childrenFolders = _getChildren(parentId);

    return getSubFolders(childrenFolders);
  }

  bool isChild(String sourceId, String targetId) {
    final listAttachedFiles = getListAttachedFiles(sourceId);

    return listAttachedFiles
            .firstWhereOrNull((element) => element.id == targetId) !=
        null;
  }

  MainModelState copyWith({
    String? parentId,
    List<DirectoryModel>? directories,
    List<String>? path,
    DateTime? currentBackPressTime,
    Sort? sort,
  }) {
    return MainModelState(
      parentId: parentId ?? this.parentId,
      directories: directories ?? this.directories,
      path: path ?? this.path,
      currentBackPressTime: currentBackPressTime ?? this.currentBackPressTime,
      sort: sort ?? this.sort,
    );
  }
}

import 'package:collection/collection.dart';
import 'package:psws_storage/editor/domain/model/directory_model.dart';
import 'package:psws_storage/editor/presenter/main/const/constants.dart';
import 'package:uuid_type/uuid_type.dart';

const _splitContent = '<note_content>';
const _splitName = '[NAME]';
const rootId = rootDirectoryId;

class PathImporter {
  final String sourceText;

  PathImporter(this.sourceText);

  List<DirectoryModel> convert() {
    List<String> text = sourceText.split(_splitContent);
    final list = _preparedList(text);

    return _createDirectories(list);
  }

  List<DirectoryModel> _createDirectories(List<First> lst) {
    List<DirectoryModel> drc = [];
    for (var element in lst) {
      final content = element.content;
      if (content.isEmpty) {
      } else {
        element.path.forEachIndexed((index, item) {
          if (index == element.path.length - 1) {
            drc.add(DirectoryModel(
                isFolder: false,
                name: item,
                createdDate: DateTime.now(),
                idHiveObject: -1,
                content: content,
                id: _getRandomId,
                parentId: _getParentId(currentIndexPath: index, path: element.path, drc: drc)));
          } else {
            final folder = drc.firstWhereOrNull((element) => element.name == item && element.isFolder);
            if (folder == null) {
              drc.add(DirectoryModel(
                  isFolder: true,
                  name: item,
                  content: '',
                  createdDate: DateTime.now(),
                  idHiveObject: -1,
                  id: _getRandomId,
                  parentId: _getParentId(currentIndexPath: index, path: element.path, drc: drc)));
            }
          }
        });
      }
    }

    return drc;
  }

  String _getParentId({
    required int currentIndexPath,
    required List<String> path,
    required List<DirectoryModel> drc,
  }) {
    if (path.isEmpty || path.length == 1 || currentIndexPath == 0) {
      return rootId;
    } else {
      final folder = drc.firstWhereOrNull((element) => element.name == path[currentIndexPath - 1]);
      if (folder != null) {
        return folder.id;
      } else {
        throw UnimplementedError('Some Error');
      }
    }
  }

  String get _getRandomId => RandomUuidGenerator().generate().toString();

  List<First> _preparedList(List<String> text) {
    List<First> lst = [];
    for (var element in text) {
      final myLst = element.split(_splitName);
      final path = myLst.length > 2 ? myLst[myLst.length - 2] : myLst.first;
      lst.add(First(path: _createListPath(path), content: myLst.last));
    }
    return lst;
  }

  List<String> _createListPath(String path) => path.split('\\').removeSpaces;
}

class First {
  final List<String> path;
  final String content;

  const First({
    required this.path,
    required this.content,
  });

  @override
  String toString() {
    return 'First{path: $path, content: $content}';
  }
}

extension on List<String> {
  List<String> get removeSpaces {
    List<String> finalList = [];
    for (var element in this) {
      final newElement = element.trim();
      if (newElement.isNotEmpty) {
        finalList.add(newElement);
      }
    }
    return finalList;
  }
}

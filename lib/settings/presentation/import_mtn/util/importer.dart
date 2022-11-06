import 'package:collection/collection.dart';
import 'package:psws_storage/editor/domain/model/directory_model.dart';
import 'package:psws_storage/editor/presenter/main/const/constants.dart';
import 'package:uuid_type/uuid_type.dart';

const _splitContent = '<note_content>';
const _splitName = '[NAME]';

class Importer {
  final String sourceText;

  Importer(this.sourceText);

  List<DirectoryModel> convert() {
    List<String> text = sourceText.split(_splitContent).removeSpaces;
    final List<_First> list = _preparedList(text);

    return _createDirectories(list);
  }

  List<DirectoryModel> _createDirectories(List<_First> lst) {
    List<DirectoryModel> drc = [];
    String rootId = rootDirectory;
    lst.forEachIndexed((indexRoot, directories) {
      List<DirectoryModel> elementsDrc = [];
      directories.content.forEachIndexed((index, element) {
        final id = _getRandomId;
        final length = directories.content.length;
        final isFolder = length > 2 && index < length - 2;
        final parentId = _getParentId(first: directories, elementsDrc: elementsDrc, currentName: element);
        if (index < length - 1) {
          elementsDrc.add(DirectoryModel(
            isFolder: isFolder,
            id: id,
            parentId: parentId ?? rootId,
            createdDate: DateTime.now(),
            name: element,
            content: isFolder ? '' : directories.content.last,
            idHiveObject: -1,
          ));
        }

        if (indexRoot == 0 && index == 0) {
          rootId = id;
        }
      });
      drc.addAll(elementsDrc);
    });

    return drc;
  }

  String? _getParentId({
    required _First first,
    required List<DirectoryModel> elementsDrc,
    required String currentName,
  }) {
    String? parentId;

    first.content.forEachIndexed((index, element) {
      if (currentName == element && element != first.content.first && element != first.content.last) {
        parentId = elementsDrc.firstWhereOrNull((element) => element.name == currentName && element.isFolder)?.id;
      }
    });

    return parentId;
  }

  String get _getRandomId => RandomUuidGenerator().generate().toString();

  List<_First> _preparedList(List<String> text) {
    List<_First> lst = [];
    for (var element in text) {
      final myLst = element.split(_splitName).removeSpaces;
      lst.add(_First(content: myLst));
    }
    return lst;
  }
}

class _First {
  final List<String> content;

  const _First({
    required this.content,
  });

  @override
  String toString() {
    return 'First{ content: $content}';
  }
}

extension on List<String> {
  List<String> get removeSpaces {
    List<String> finalList = [];
    for (var element in this) {
      String newElement = element.trim();
      if (newElement.isNotEmpty) {
        newElement = _removeNewLine(newElement);
        finalList.add(newElement);
      }
    }
    return finalList;
  }

  String _removeNewLine(String source) {
    String updatedText = source;
    if (updatedText.isNotEmpty) {
      if (updatedText[0] == '\n') updatedText = updatedText.substring(1, updatedText.length - 1);
      if (updatedText[updatedText.length - 1] == '\n') updatedText = updatedText.substring(0, updatedText.length - 2);
    }

    return updatedText;
  }
}

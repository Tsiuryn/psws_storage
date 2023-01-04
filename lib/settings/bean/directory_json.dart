import 'package:json_annotation/json_annotation.dart';
import 'package:psws_storage/editor/data/bean/directory_bean.dart';

part 'directory_json.g.dart';

@JsonSerializable()
class DirectoryJson {
  @JsonKey(name: 'isFolder')
  final bool isFolder;

  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'parentId')
  final String parentId;

  @JsonKey(name: 'createdDate')
  final DateTime createdDate;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'content')
  final String content;

  @JsonKey(name: 'idHiveObject')
  final int? idHiveObject;

  const DirectoryJson({
    required this.isFolder,
    required this.id,
    required this.parentId,
    required this.createdDate,
    required this.name,
    required this.content,
    this.idHiveObject,
  });

  DirectoryJson updateIdHiveObject(int idHiveObject) => DirectoryJson(
        isFolder: isFolder,
        id: id,
        parentId: parentId,
        createdDate: createdDate,
        name: name,
        content: content,
        idHiveObject: idHiveObject,
      );

  factory DirectoryJson.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$DirectoryJsonFromJson(json);

  Map<String, dynamic> toJson() => _$DirectoryJsonToJson(this);
}

extension DirectoryJsonExt on DirectoryJson {
  DirectoryBean mapToDataBase({bool isRewrite = false}) => DirectoryBean(
        isFolder: isFolder,
        id: id,
        parentId: parentId,
        createdDate: createdDate,
        name: name,
        content: content,
        idHiveObject: isRewrite ? idHiveObject : null,
      );
}

extension DirectoryBeanExt on DirectoryBean {
  DirectoryJson mapToJson() => DirectoryJson(
        isFolder: isFolder,
        id: id,
        parentId: parentId,
        createdDate: createdDate,
        name: name,
        content: content,
        idHiveObject: idHiveObject,
      );
}

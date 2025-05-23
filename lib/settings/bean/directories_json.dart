import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:psws_storage/editor/data/bean/directory_bean.dart';

part 'directories_json.g.dart';

@immutable
@JsonSerializable()
class DirectoriesJson {
  @JsonKey(name: 'directories')
  final List<DirectoryJson> directories;

  const DirectoriesJson(this.directories);

  factory DirectoriesJson.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$DirectoriesJsonFromJson(json);

  Map<String, dynamic> toJson() => _$DirectoriesJsonToJson(this);
}

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

  @JsonKey(name: 'destinationId')
  final String? destinationId;

  const DirectoryJson({
    required this.isFolder,
    required this.id,
    required this.parentId,
    required this.createdDate,
    required this.name,
    required this.content,
    required this.idHiveObject,
    required this.destinationId,
  });

  DirectoryJson updateIdHiveObject(int idHiveObject) => DirectoryJson(
        isFolder: isFolder,
        id: id,
        parentId: parentId,
        createdDate: createdDate,
        name: name,
        content: content,
        idHiveObject: idHiveObject,
        destinationId: destinationId,
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
        destinationId: destinationId,
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
        destinationId: destinationId,
      );
}

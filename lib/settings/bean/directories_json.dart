import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:psws_storage/settings/bean/directory_json.dart';

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

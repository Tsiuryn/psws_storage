import 'package:hive/hive.dart';
import 'package:psws_storage/editor/domain/model/directory_model.dart';

part 'directory_bean.g.dart';

@HiveType(typeId: 0)
class DirectoryBean extends HiveObject {
  @HiveField(0)
  final bool isFolder;

  @HiveField(1)
  final String id;

  @HiveField(2)
  final String parentId;

  @HiveField(3)
  final DateTime createdDate;

  @HiveField(4)
  final String name;

  @HiveField(5)
  final String content;

  @HiveField(6)
  final int? idHiveObject;

  @HiveField(7)
  final String? destinationId;

  DirectoryBean({
    required this.isFolder,
    required this.id,
    required this.parentId,
    required this.createdDate,
    required this.name,
    required this.content,
    this.idHiveObject,
    this.destinationId,
  });
}

extension DirectoryBeanExt on DirectoryBean {
  DirectoryModel toDomain() => DirectoryModel(
        isFolder: isFolder,
        id: id,
        parentId: parentId,
        createdDate: createdDate,
        name: name,
        content: content,
        idHiveObject: idHiveObject ?? -1,
        destinationId: destinationId,
      );
}

extension DirectoryModelExt on DirectoryModel {
  DirectoryBean toBean() => DirectoryBean(
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

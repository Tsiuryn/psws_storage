class DirectoryModel {
  final bool isFolder;
  final String id;
  final String parentId;
  final DateTime createdDate;
  final String name;
  final String content;
  final int? idHiveObject;

  DirectoryModel({
    required this.isFolder,
    required this.id,
    required this.parentId,
    required this.createdDate,
    required this.name,
    required this.content,
    this.idHiveObject,
  });

  DirectoryModel copyWith({
    bool? isFolder,
    String? id,
    String? parentId,
    DateTime? createdDate,
    String? name,
    String? content,
    int? idHiveObject,
  }) =>
      DirectoryModel(
        isFolder: isFolder ?? this.isFolder,
        id: id ?? this.id,
        parentId: parentId ?? this.parentId,
        createdDate: createdDate ?? this.createdDate,
        name: name ?? this.name,
        content: content ?? this.content,
        idHiveObject: idHiveObject ?? this.idHiveObject,
      );

  @override
  String toString() {
    return 'DirectoryModel{isFolder: $isFolder, id: $id, parentId: $parentId, createdDate: $createdDate, name: $name, content: $content, idHiveObject: $idHiveObject}';
  }
}

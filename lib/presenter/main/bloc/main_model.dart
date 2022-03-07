class MainModel {
  final String id;

  MainModel({required this.id});

  MainModel.empty() : id = '';

  MainModel copyWith({
    String? id,
  }) {
    return MainModel(
      id: id ?? this.id,
    );
  }
}

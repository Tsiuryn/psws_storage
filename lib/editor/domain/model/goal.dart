// ignore_for_file: public_member_api_docs, sort_constructors_first
class Goal {
  final int rowId;
  final String id;
  final DateTime createdDate;
  final String title;
  final String description;
  final List<Task> tasks;

  Goal({
    required this.rowId,
    required this.id,
    required this.createdDate,
    required this.title,
    required this.description,
    required this.tasks,
  });

  Goal copyWith({
    int? rowId,
    String? id,
    DateTime? createdDate,
    String? title,
    String? description,
    List<Task>? tasks,
  }) {
    return Goal(
      rowId: rowId ?? this.rowId,
      id: id ?? this.id,
      createdDate: createdDate ?? this.createdDate,
      title: title ?? this.title,
      description: description ?? this.description,
      tasks: tasks ?? this.tasks,
    );
  }
}

class Task {
  final int rowId;
  final String id;
  final String parentId;
  final DateTime createdDate;
  final String title;
  final String description;
  final bool isFinished;

  Task({
    required this.rowId,
    required this.id,
    required this.parentId,
    required this.createdDate,
    required this.title,
    required this.description,
    required this.isFinished,
  });

  Task copyWith({
    int? rowId,
    String? id,
    String? parentId,
    DateTime? createdDate,
    String? title,
    String? description,
    bool? isFinished,
  }) {
    return Task(
      rowId: rowId ?? this.rowId,
      id: id ?? this.id,
      parentId: parentId ?? this.parentId,
      createdDate: createdDate ?? this.createdDate,
      title: title ?? this.title,
      description: description ?? this.description,
      isFinished: isFinished ?? this.isFinished,
    );
  }
}

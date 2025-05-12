// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';
import 'package:psws_storage/goals/domain/models/goal.dart';

part 'goals_json.g.dart';

@JsonSerializable()
class GoalsJson {
  @JsonKey(name: 'goals')
  final List<GoalJson> goals;

  const GoalsJson({
    required this.goals,
  });

  factory GoalsJson.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$GoalsJsonFromJson(json);

  Map<String, dynamic> toJson() => _$GoalsJsonToJson(this);
}

@JsonSerializable()
class GoalJson {
  @JsonKey(name: 'rowId')
  final int rowId;
  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'created')
  final DateTime createdDate;
  @JsonKey(name: 'title')
  final String title;
  @JsonKey(name: 'description')
  final String description;
  @JsonKey(name: 'tasks')
  final List<TaskJson> tasks;

  GoalJson({
    required this.rowId,
    required this.id,
    required this.createdDate,
    required this.title,
    required this.description,
    required this.tasks,
  });

  factory GoalJson.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$GoalJsonFromJson(json);

  Map<String, dynamic> toJson() => _$GoalJsonToJson(this);
}

@JsonSerializable()
class TaskJson {
  @JsonKey(name: 'rowId')
  final int rowId;
  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'parentId')
  final String parentId;
  @JsonKey(name: 'created')
  final DateTime createdDate;
  @JsonKey(name: 'title')
  final String title;
  @JsonKey(name: 'description')
  final String description;
  @JsonKey(name: 'isFinished')
  final bool isFinished;

  TaskJson({
    required this.rowId,
    required this.id,
    required this.parentId,
    required this.createdDate,
    required this.title,
    required this.description,
    required this.isFinished,
  });

  factory TaskJson.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$TaskJsonFromJson(json);

  Map<String, dynamic> toJson() => _$TaskJsonToJson(this);
}

extension GoalsJsonExtension on GoalsJson {
  List<Goal> getListDBGoals() =>
      goals.map((value) => value.toDBModel()).toList();
}

extension GoalJsonExtension on GoalJson {
  Goal toDBModel() => Goal(
        rowId: rowId,
        id: id,
        createdDate: createdDate,
        title: title,
        description: description,
        tasks: tasks.map((value) => value.toDBModel()).toList(),
      );
}

extension GoalsExtension on List<Goal> {
  GoalsJson getJson() => GoalsJson(
        goals: map((value) => value.toJson()).toList(),
      );
}

extension GoalExtension on Goal {
  GoalJson toJson() => GoalJson(
        rowId: rowId,
        id: id,
        createdDate: createdDate,
        title: title,
        description: description,
        tasks: tasks.map((value) => value.toJson()).toList(),
      );
}

extension TaskJsonExtension on TaskJson {
  Task toDBModel() => Task(
        rowId: rowId,
        id: id,
        parentId: parentId,
        createdDate: createdDate,
        title: title,
        description: description,
        isFinished: isFinished,
      );
}

extension TaskExtension on Task {
  TaskJson toJson() => TaskJson(
        rowId: rowId,
        id: id,
        parentId: parentId,
        createdDate: createdDate,
        title: title,
        description: description,
        isFinished: isFinished,
      );
}

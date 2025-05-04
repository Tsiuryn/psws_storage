import 'package:psws_storage/editor/data/source/local/db/goals_database.dart';
import 'package:psws_storage/editor/domain/model/goal.dart';

extension TaskExtension on Task {
  TaskBeanCompanion get toTaskCompanion => TaskBeanCompanion.insert(
        id: id,
        parentId: parentId,
        title: title,
        description: description,
      );

  TaskBeanData get toTaskBeanData => TaskBeanData(
        tableId: rowId,
        id: id,
        parentId: parentId,
        createdDate: createdDate,
        title: title,
        description: description,
        isFinished: isFinished,
      );
}

extension TaskBeanDataExtension on TaskBeanData {
  Task get toTask => Task(
        rowId: tableId,
        id: id,
        parentId: parentId,
        createdDate: createdDate,
        title: title,
        description: description,
        isFinished: isFinished,
      );
}

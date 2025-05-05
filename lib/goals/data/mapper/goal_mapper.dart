import 'package:psws_storage/goals/data/source/local/db/goals_database.dart';
import 'package:psws_storage/goals/domain/models/goal.dart';

extension GoalExtension on Goal {
  GoalBeanCompanion get toGoalCompanion => GoalBeanCompanion.insert(
        id: id,
        title: title,
        description: description,
      );

  GoalBeanData get toGoalBeanData => GoalBeanData(
        tableId: rowId,
        id: id,
        title: title,
        description: description,
        createdDate: createdDate,
      );
}

extension GoalBeanDataExtension on GoalBeanData {
  Goal get toGoal => Goal(
        rowId: tableId,
        id: id,
        createdDate: createdDate,
        title: title,
        description: description,
        tasks: [],
      );
}

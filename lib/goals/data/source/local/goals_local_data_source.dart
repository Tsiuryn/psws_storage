import 'package:psws_storage/goals/data/mapper/goal_mapper.dart';
import 'package:psws_storage/goals/data/mapper/task_mapper.dart';
import 'package:psws_storage/goals/data/source/goals_data_source.dart';
import 'package:psws_storage/goals/data/source/local/db/goals_database.dart';
import 'package:psws_storage/goals/domain/models/goal.dart';

class GoalsLocalDataSource implements GoalsDataSource {
  final GoalsDatabase database;

  const GoalsLocalDataSource(this.database);

  @override
  Future<void> addGoal(Goal goal) async {
    await database.addGoal(goal.toGoalCompanion);
  }

  @override
  Future<void> addTask(Task task) async {
    await database.addTask(task.toTaskCompanion);
  }

  @override
  Future<void> deleteGoal(Goal goal) async {
    await database.deleteGoal(goal.id);
  }

  @override
  Future<void> deleteTask(Task task) async {
    await database.deleteTask(task.id);
  }

  @override
  Future<List<Goal>> getGoals() async {
    final list = await database.getAllGoal();

    final goals = await Future.wait(
      list.map((bean) async {
        final goal = bean.toGoal;
        final tasks = await database
            .getAllTasksById(goal.id)
            .then((element) => element.map((t) => t.toTask).toList());

        return goal.copyWith(tasks: tasks);
      }),
    );

    return goals;
  }

  @override
  Future<void> updateGoal(Goal goal) async {
    await database.updateGoal(goal.toGoalBeanData);
  }

  @override
  Future<void> updateTask(Task task) async {
    await database.updateTask(task.toTaskBeanData);
  }

  @override
  Future<Task> getTaskById(String id) {
    return database.getTaskById(id).then((element) => element.toTask);
  }
}

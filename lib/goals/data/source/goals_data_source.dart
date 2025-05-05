import 'package:psws_storage/goals/domain/models/goal.dart';

abstract interface class GoalsDataSource {
  Future<void> addGoal(Goal goal);

  Future<void> addTask(Task task);

  Future<void> updateGoal(Goal goal);

  Future<void> updateTask(Task task);

  Future<void> deleteGoal(Goal goal);

  Future<void> deleteTask(Task task);

  Future<List<Goal>> getGoals();

  Future<Task> getTaskById(String id);
}

import 'package:psws_storage/editor/data/source/goals_data_source.dart';
import 'package:psws_storage/editor/domain/model/goal.dart';
import 'package:psws_storage/editor/domain/repo/goal_repo.dart';

class GoalRepoImpl implements GoalRepo {
  final GoalsDataSource source;

  const GoalRepoImpl(this.source);

  @override
  Future<void> addGoal(Goal goal) {
    return source.addGoal(goal);
  }

  @override
  Future<void> deleteGoal(Goal goal) {
    return source.deleteGoal(goal);
  }

  @override
  Future<List<Goal>> getGoals() {
    return source.getGoals();
  }

  @override
  Future<void> updateGoal(Goal goal) {
    return source.updateGoal(goal);
  }

  @override
  Future<void> addTask(Task task) {
    return source.addTask(task);
  }

  @override
  Future<void> deleteTask(Task task) {
    return source.deleteTask(task);
  }

  @override
  Future<void> updateTask(Task task) {
    return source.updateTask(task);
  }

  @override
  Future<Task> getTaskById(String id) {
    return source.getTaskById(id);
  }
}

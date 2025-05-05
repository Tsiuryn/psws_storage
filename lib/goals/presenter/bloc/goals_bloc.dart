import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:psws_storage/app/utils/uuid_generator.dart';
import 'package:psws_storage/goals/domain/models/goal.dart';
import 'package:psws_storage/goals/domain/repo/goal_repo.dart';

part 'goals_state.dart';
part 'goals_bloc_model.dart';

class GoalsBloc extends Cubit<GoalsState> {
  final GoalRepo repo;
  GoalsBloc({
    required this.repo,
  }) : super(GoalsState.initial()) {
    _fetchGoals();
  }

  Future<void> _fetchGoals() async {
    emit(
      GoalsState.updatePage(
        state.model.copyWith(
          goals: await repo.getGoals(),
        ),
      ),
    );
  }

  Future<void> addGoal(String title) async {
    final goal = Goal(
      rowId: -1,
      id: UuidGenerator.stringId(),
      createdDate: DateTime.now(),
      title: title,
      description: '',
      tasks: [],
    );

    await repo.addGoal(goal);

    _fetchGoals();
  }

  Future<void> addTask(Task task) async {
    await repo.addTask(task);

    _fetchGoals();
  }

  Future<void> updateGoal(Goal goal) async {
    await repo.updateGoal(goal);

    _fetchGoals();
  }

  Future<void> updateTask(Task task) async {
    await repo.updateTask(task);

    _fetchGoals();
  }

  Future<void> deleteGoal(Goal goal) async {
    await repo.deleteGoal(goal);
    _fetchGoals();
  }

  Future<Task> getTaskById(String id) async {
    return repo.getTaskById(id);
  }

  Future<void> deleteTask(Task task) async {
    await repo.deleteTask(task);

    _fetchGoals();
  }
}

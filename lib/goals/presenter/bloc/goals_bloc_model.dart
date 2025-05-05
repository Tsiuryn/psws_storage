part of 'goals_bloc.dart';

class GoalsBlocModel {
  final List<Goal> goals;

  const GoalsBlocModel({
    required this.goals,
  });

  const GoalsBlocModel.empty() : goals = const [];

  List<Goal> get finishedGoals {
    return goals.where((goal) {
      final tasks = goal.tasks;
      if (goal.tasks.isEmpty) return false;
      final finishedTask = tasks.where((task) => task.isFinished);

      return finishedTask.length == tasks.length;
    }).toList();
  }

  List<Goal> get currentGoals {
    return goals.where((goal) {
      final tasks = goal.tasks;
      if (goal.tasks.isEmpty) return true;
      final finishedTask = tasks.where((task) => task.isFinished);

      return finishedTask.length != tasks.length;
    }).toList();
  }

  GoalsBlocModel copyWith({
    List<Goal>? goals,
  }) {
    return GoalsBlocModel(
      goals: goals ?? this.goals,
    );
  }
}

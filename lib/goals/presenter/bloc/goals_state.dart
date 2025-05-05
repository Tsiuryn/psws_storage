part of 'goals_bloc.dart';

sealed class GoalsState {
  final GoalsBlocModel model;

  const GoalsState(this.model);

  factory GoalsState.initial() => const InitialState(GoalsBlocModel.empty());

  const factory GoalsState.updatePage(GoalsBlocModel model) = UpdatePage;
}

class InitialState extends GoalsState {
  const InitialState(super.model);
}

class UpdatePage extends GoalsState {
  const UpdatePage(super.model);
}

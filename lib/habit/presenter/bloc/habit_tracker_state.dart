part of 'habit_tracker_bloc.dart';

class HabitTrackerState {
  final TrackerState state;
  final List<Habit> habits;
  final Map<DateTime, int> statistics;
  final List<Habit>? statisticHabits;

  const HabitTrackerState(
      {required this.state,
      required this.habits,
      required this.statistics,
      this.statisticHabits});

  const HabitTrackerState.init()
      : state = TrackerState.initial,
        habits = const [],
        statistics = const {},
        statisticHabits = null;

  DateTime getStartDate() {
    if (statistics.isEmpty) return DateTime.now().subtract(Duration(days: 1));

    var date = statistics.keys.first;

    for (var currentDate in statistics.keys) {
      if (currentDate.isBefore(date)) {
        date = currentDate;
      }
    }

    return date;
  }

  HabitTrackerState copyWith({
    TrackerState? state,
    List<Habit>? habits,
    Map<DateTime, int>? statistics,
    List<Habit>? statisticHabits,
  }) {
    return HabitTrackerState(
      state: state ?? TrackerState.update,
      habits: habits ?? this.habits,
      statistics: statistics ?? this.statistics,
      statisticHabits: statisticHabits ?? this.statisticHabits,
    );
  }
}

enum TrackerState { initial, update, showStatisticDialog }

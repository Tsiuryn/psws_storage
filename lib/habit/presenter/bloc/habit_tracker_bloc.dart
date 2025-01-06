import 'package:bloc/bloc.dart';
import 'package:psws_storage/habit/domain/entity/habit.dart';
import 'package:psws_storage/habit/domain/repo/habit_repository.dart';
import 'package:psws_storage/habit/domain/repo/statistics_repository.dart';
import 'package:uuid_type/uuid_type.dart';

part 'habit_tracker_state.dart';

class HabitTrackerBloc extends Cubit<HabitTrackerState> {
  final HabitRepository _habitRepository;
  final StatisticsRepository _statisticsRepository;

  HabitTrackerBloc({
    required HabitRepository habitRepository,
    required StatisticsRepository statisticsRepository,
  })  : _habitRepository = habitRepository,
        _statisticsRepository = statisticsRepository,
        super(HabitTrackerState.init()) {
    _handleChanges();
  }

  void _handleChanges() {
    _statisticsRepository.updatedStatisticsDB().listen((_) {
      updateFlow();
    });
  }

  Future<void> updateFlow() async {
    emit(state.copyWith(
      habits: await _statisticsRepository.getDailyHabits(),
      statistics: await _statisticsRepository.getStatistics(),
      state: TrackerState.update,
    ));
  }

  Future<void> addHabit(String title) async {
    await _habitRepository.updateHabit(Habit(
      id: TimeUuidGenerator().generate().toString(),
      startDate: DateTime.now(),
      title: title,
      period: [],
      completed: false,
    ));
  }

  Future<void> updateHabit(Habit habit) async {
    await _habitRepository.updateHabit(habit);
  }

  Future<void> deleteHabit(String habitId) async {
    await _habitRepository.removeHabit(habitId);
  }

  Future<void> showStatisticDialog(DateTime date) async {
    emit(state.copyWith(
      statisticHabits: await _statisticsRepository.getStatisticData(date),
      state: TrackerState.showStatisticDialog,
    ));
  }
}

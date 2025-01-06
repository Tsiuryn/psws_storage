import 'package:collection/collection.dart';
import 'package:encrypt/encrypt.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:psws_storage/habit/data/bean/daily_habits.dart';
import 'package:psws_storage/habit/data/bean/habit_bean.dart';
import 'package:psws_storage/habit/domain/entity/habit.dart';
import 'package:psws_storage/habit/domain/repo/statistics_repository.dart';

final _dateFormatter = DateFormat('dd-MM-yyyy');

class StatisticsRepositoryImpl implements StatisticsRepository {
  final Box<DailyHabits> statisticsDB;
  final Box<HabitBean> sourceHabitsDB;

  StatisticsRepositoryImpl({
    required this.statisticsDB,
    required this.sourceHabitsDB,
  }) {
    _handleChanges();
    _setUpStatistics();
  }

  void _handleChanges() {
    sourceHabitsDB.watch().listen((event) async {
      final dateKey = _dateFormatter.format(DateTime.now());
      if (event.deleted) {
        final habits = statisticsDB.get(dateKey)?.habits ?? [];
        statisticsDB.put(
            dateKey, DailyHabits(_removeHabitById(habits, event.key)));
        return;
      }
      final habit = (event.value as HabitBean).toDomain();
      final dailyChanges = await getDailyHabits();
      final changedHabit = dailyChanges.indexed
          .firstWhereOrNull((value) => value.$2.id == event.key);
      if (changedHabit == null) {
        dailyChanges.add(habit);
      } else {
        dailyChanges[changedHabit.$1] = habit;
      }
      statisticsDB.put(
        dateKey,
        DailyHabits(dailyChanges.map((value) => value.fromDomain()).toList()),
      );
    });
  }

  void _setUpStatistics() {
    final dateKey = _dateFormatter.format(DateTime.now());
    final dailyHabits = statisticsDB.get(dateKey);
    if (dailyHabits == null) {
      statisticsDB.put(
        dateKey,
        DailyHabits(sourceHabitsDB.values
            .map((value) => value.copyWith(completed: false))
            .toList()),
      );
    }
  }

  @override
  Future<Map<DateTime, int>> getStatistics() async {
    return {
      for (var v in statisticsDB.keys)
        _dateFormatter.parse(v): _getPercent(statisticsDB.get(v)?.habits ?? [])
    };
  }

  int _getPercent(List<HabitBean> habits) {
    if (habits.isEmpty) return 0;

    final completed = habits.where((value) => value.completed);

    return (completed.length / habits.length * 10).toInt();
  }

  List<HabitBean> _removeHabitById(List<HabitBean> habits, String id) {
    return habits.where((habit) => habit.id != id).toList();
  }

  @override
  Future<List<Habit>> getDailyHabits() async {
    final dateKey = _dateFormatter.format(DateTime.now());
    final dailyHabits =
        statisticsDB.get(dateKey)?.habits.map((v) => v.toDomain()).toList();
    return dailyHabits ?? [];
  }

  @override
  Stream<void> updatedStatisticsDB() {
    return statisticsDB.watch();
  }

  @override
  Future<List<Habit>?> getStatisticData(DateTime date) async {
    final dateKey = _dateFormatter.format(date);
    return statisticsDB
        .get(dateKey)
        ?.habits
        ?.map((value) => value.toDomain())
        .toList();
  }
}

import 'package:psws_storage/habit/domain/entity/habit.dart';

abstract interface class StatisticsRepository {
  Future<Map<DateTime, int>> getStatistics();
  Future<List<Habit>> getDailyHabits();
  Stream<void> updatedStatisticsDB();
  Future<List<Habit>?> getStatisticData(DateTime date);
}

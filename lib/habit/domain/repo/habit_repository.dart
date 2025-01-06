import 'package:psws_storage/habit/domain/entity/habit.dart';

abstract interface class HabitRepository {
  Future<List<Habit>> getAllHabits();

  Future<void> updateHabit(Habit habit);

  Future<void> removeHabit(String habitId);
}

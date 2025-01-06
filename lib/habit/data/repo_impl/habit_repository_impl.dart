import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:psws_storage/habit/data/bean/habit_bean.dart';
import 'package:psws_storage/habit/domain/entity/habit.dart';
import 'package:psws_storage/habit/domain/repo/habit_repository.dart';

final _dateFormatter = DateFormat('dd-MM-yyyy');

class HabitRepositoryImpl implements HabitRepository {
  final Box<HabitBean> sourceHabitsDB;

  const HabitRepositoryImpl({
    required this.sourceHabitsDB,
  });

  @override
  Future<void> updateHabit(Habit habit) async {
    await sourceHabitsDB.put(habit.id, habit.fromDomain());
  }

  @override
  Future<List<Habit>> getAllHabits() async {
    return sourceHabitsDB.values.map((value) => value.toDomain()).toList();
  }

  @override
  Future<void> removeHabit(String habitId) async {
    await sourceHabitsDB.delete(habitId);
  }
}

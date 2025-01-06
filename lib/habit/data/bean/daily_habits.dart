import 'package:hive/hive.dart';
import 'package:psws_storage/habit/data/bean/habit_bean.dart';

part 'daily_habits.g.dart';

@HiveType(typeId: 2)
class DailyHabits extends HiveObject {
  @HiveField(0)
  final List<HabitBean> habits;

  DailyHabits(this.habits);
}

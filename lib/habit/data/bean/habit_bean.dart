import 'package:collection/collection.dart';
import 'package:hive/hive.dart';
import 'package:psws_storage/habit/domain/entity/habit.dart';

part 'habit_bean.g.dart';

@HiveType(typeId: 1)
class HabitBean extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime startDate;

  @HiveField(2)
  final DateTime? finishDate;

  @HiveField(3)
  final String title;

  @HiveField(4)
  final List<String> period;

  @HiveField(5)
  final bool completed;

  HabitBean({
    required this.id,
    required this.startDate,
    this.finishDate,
    required this.title,
    required this.period,
    required this.completed,
  });

  HabitBean copyWith({
    String? id,
    DateTime? startDate,
    DateTime? finishDate,
    String? title,
    List<String>? period,
    bool? completed,
  }) {
    return HabitBean(
      id: id ?? this.id,
      startDate: startDate ?? this.startDate,
      finishDate: finishDate ?? this.finishDate,
      title: title ?? this.title,
      period: period ?? this.period,
      completed: completed ?? this.completed,
    );
  }
}

extension HabitExtension on Habit {
  HabitBean fromDomain() => HabitBean(
        id: id,
        startDate: startDate,
        finishDate: finishDate,
        title: title,
        period: period.map((value) => value.name).toList(),
        completed: completed,
      );
}

extension HabitBeanExtension on HabitBean {
  Habit toDomain() => Habit(
        id: id,
        startDate: startDate,
        title: title,
        period: period
            .map((value) => PeriodDate.values
                .firstWhereOrNull((period) => period.name == value))
            .whereNotNull()
            .toList(),
        completed: completed,
      );
}

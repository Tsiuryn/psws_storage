class Habit {
  final String id;
  final DateTime startDate;
  final DateTime? finishDate;
  final String title;
  final List<PeriodDate> period;
  final bool completed;

  const Habit({
    required this.id,
    required this.startDate,
    required this.title,
    required this.period,
    required this.completed,
    this.finishDate,
  });

  Habit copyWith({
    String? id,
    DateTime? startDate,
    DateTime? finishDate,
    String? title,
    List<PeriodDate>? period,
    bool? completed,
  }) {
    return Habit(
      id: id ?? this.id,
      startDate: startDate ?? this.startDate,
      finishDate: finishDate ?? this.finishDate,
      title: title ?? this.title,
      period: period ?? this.period,
      completed: completed ?? this.completed,
    );
  }
}

enum PeriodDate { mon, tue, wed, thu, fri, sat, sun }

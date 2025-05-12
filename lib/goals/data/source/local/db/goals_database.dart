import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'goals_database.g.dart';

class GoalBean extends Table {
  IntColumn get tableId => integer().autoIncrement()();
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  DateTimeColumn get createdDate =>
      dateTime().withDefault(currentDateAndTime)();
}

class TaskBean extends Table {
  IntColumn get tableId => integer().autoIncrement()();
  TextColumn get id => text()();
  TextColumn get parentId => text().references(GoalBean, #id)();
  DateTimeColumn get createdDate =>
      dateTime().withDefault(currentDateAndTime)();
  TextColumn get title => text()();
  TextColumn get description => text()();
  BoolColumn get isFinished => boolean()();
}

@DriftDatabase(tables: [GoalBean, TaskBean])
class GoalsDatabase extends _$GoalsDatabase {
  GoalsDatabase() : super(driftDatabase(name: 'psws_goals'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(beforeOpen: (details) async {});
  }

  Future<int> addGoal(GoalBeanCompanion goalCompanion) async {
    final id = await into(goalBean).insert(goalCompanion);
    return id;
  }

  Future<int> addTask(TaskBeanCompanion taskCompanion) async {
    final id = await into(taskBean).insert(taskCompanion);
    return id;
  }

  Future<bool> updateGoal(GoalBeanData goal) async {
    return await update(goalBean).replace(goal);
  }

  Future<bool> updateTask(TaskBeanData task) async {
    return await update(taskBean).replace(task);
  }

  Future<List<GoalBeanData>> getAllGoal() {
    return (select(goalBean)
          ..orderBy([(t) => OrderingTerm.desc(t.createdDate)]))
        .get();
  }

  Future<List<TaskBeanData>> getAllTasks() {
    return (select(taskBean)
          ..orderBy([(t) => OrderingTerm.desc(t.createdDate)]))
        .get();
  }

  Future<List<TaskBeanData>> getAllTasksById(String parentId) {
    return (select(taskBean)
          ..where((t) => t.parentId.equals(parentId))
          ..orderBy([(t) => OrderingTerm.desc(t.createdDate)]))
        .get();
  }

  Future<TaskBeanData> getTaskById(String taskId) {
    return (select(taskBean)..where((t) => t.id.equals(taskId)))
        .get()
        .then((tasks) => tasks.first);
  }

  Future<int> deleteGoal(String goalId) async {
    await (delete(taskBean)..where((t) => t.parentId.equals(goalId))).go();
    final result =
        await (delete(goalBean)..where((t) => t.id.equals(goalId))).go();
    return result;
  }

  Future<int> deleteTask(String taskId) async {
    final result =
        await (delete(taskBean)..where((t) => t.id.equals(taskId))).go();
    return result;
  }

  Future<void> clearAllData() async {
    await taskBean.deleteAll();
    await goalBean.deleteAll();
  }
}

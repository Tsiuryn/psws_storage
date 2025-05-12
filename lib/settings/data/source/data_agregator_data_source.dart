// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:collection/collection.dart';
import 'package:hive/hive.dart';
import 'package:psws_storage/app/utils/uuid_generator.dart';

import 'package:psws_storage/editor/data/bean/directory_bean.dart';
import 'package:psws_storage/goals/data/source/goals_data_source.dart';
import 'package:psws_storage/goals/domain/models/goal.dart';
import 'package:psws_storage/settings/bean/directories_json.dart';
import 'package:psws_storage/settings/bean/goals_json.dart';
import 'package:psws_storage/settings/presentation/import_export/bloc/import_export_bloc.dart';

class DataAgregatorDataSource {
  final Future<Box<DirectoryBean>> Function() futureBox;
  final GoalsDataSource goalsDataSource;

  DataAgregatorDataSource({
    required this.futureBox,
    required this.goalsDataSource,
  });

  Future<DirectoriesJson> getDirectories() async {
    var box = (await futureBox()).values;
    return DirectoriesJson(box.map((e) => e.mapToJson()).toList());
  }

  Future<GoalsJson> getGoals() async {
    final goals = await goalsDataSource.getGoals();
    return goals.getJson();
  }

  Future<void> setDirectories(
      ImportType type, DirectoriesJson directories) async {
    final directoriesBean =
        directories.directories.map((e) => e.mapToDataBase()).toList();
    final box = await futureBox();

    final List<int> idHiveObject = [];

    if (type == ImportType.rewrite) {
      await box.clear();
    }

    idHiveObject.addAll(await box.addAll(directoriesBean));

    idHiveObject.forEachIndexed((index, idHiveObject) async {
      final directory = directories.directories[index]
          .updateIdHiveObject(idHiveObject)
          .mapToDataBase(isRewrite: true);
      await box.put(idHiveObject, directory);
    });

    await box.close();
  }

  Future<void> setGoals(ImportType type, GoalsJson goals) async {
    final List<Goal> goalDb = goals.getListDBGoals();

    if (type == ImportType.rewrite) {
      await goalsDataSource.clearAllData();
    }

    final tasks = <Task>[];

    for (var goal in goalDb) {
      if (type == ImportType.add) {
        final id = UuidGenerator.stringId();
        final tasks =
            goal.tasks.map((task) => task.copyWith(parentId: id)).toList();
        goal = goal.copyWith(id: id, tasks: tasks);
      }
      tasks.addAll(goal.tasks);
      await goalsDataSource.addGoal(goal);
    }

    for (var task in tasks) {
      if (type == ImportType.add) {
        task = task.copyWith(id: UuidGenerator.stringId());
      }
      await goalsDataSource.addTask(task);
    }
  }
}

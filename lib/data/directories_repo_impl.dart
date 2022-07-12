import 'package:hive/hive.dart';
import 'package:psws_storage/data/bean/directory_bean.dart';
import 'package:psws_storage/domain/model/directory_model.dart';
import 'package:psws_storage/domain/repo/directories_repo.dart';

const String _idStorage = 'PSWS_STORAGE_ID';

class DirectoriesRepoImpl implements DirectoriesRepo {
  @override
  Future<List<DirectoryModel>> getDirectories() async {
    final box = await _openBox();
    final directories = _getDirectories(box);
    await box.close();

    return directories;
  }

  @override
  Future<List<DirectoryModel>> addDirectory(DirectoryModel model) async {
    final box = await _openBox();
    DirectoryBean data = model.toBean();
    int idHiveObject = await box.add(data);
    var updatedData = model.copyWith(idHiveObject: idHiveObject).toBean();
    await box.put(idHiveObject, updatedData);
    final updatedListDirectory = _getDirectories(box);
    await box.close();

    return updatedListDirectory;
  }

  @override
  Future<List<DirectoryModel>> deleteDirectory(DirectoryModel model) async {
    final box = await _openBox();
    await box.delete(model.idHiveObject);
    final updatedListDirectory = _getDirectories(box);
    await box.close();

    return updatedListDirectory;
  }

  Future<Box<DirectoryBean>> _openBox() {
    return Hive.openBox(_idStorage);
  }

  List<DirectoryModel> _getDirectories(Box<DirectoryBean> box) =>
      box.values.map((e) => e.toDomain()).toList();

  @override
  Future<List<DirectoryModel>> deleteDirectories(Iterable<int> keys) async {
    final box = await _openBox();
    await box.deleteAll(keys);
    final updatedListDirectory = _getDirectories(box);
    await box.close();

    return updatedListDirectory;
  }

  @override
  Future<List<DirectoryModel>> updateDirectory(DirectoryModel value) async {
    final box = await _openBox();
    DirectoryBean data = value.toBean();
    await box.put(value.idHiveObject, data);
    final updatedListDirectory = _getDirectories(box);
    await box.close();

    return updatedListDirectory;
  }

  @override
  Future<DirectoryModel?> getDirectory(int idHiveObject) async {
    final box = await _openBox();
    final DirectoryBean? bean = box.get(idHiveObject);
    await box.close();

    return bean?.toDomain();
  }
}

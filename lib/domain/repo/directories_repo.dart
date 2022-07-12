import 'package:psws_storage/domain/model/directory_model.dart';

abstract class DirectoriesRepo {
  Future<List<DirectoryModel>> addDirectory(DirectoryModel model);

  Future<List<DirectoryModel>> getDirectories();

  Future<List<DirectoryModel>> deleteDirectory(DirectoryModel model);

  Future<List<DirectoryModel>> deleteDirectories(Iterable<int> keys);

  Future<List<DirectoryModel>> updateDirectory(DirectoryModel value);

  Future<DirectoryModel?> getDirectory(int idHiveObject);
}

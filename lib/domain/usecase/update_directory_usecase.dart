import 'package:psws_storage/domain/model/directory_model.dart';
import 'package:psws_storage/domain/repo/directories_repo.dart';

class UpdateDirectoryUseCase {
  final DirectoriesRepo directoriesRepo;

  UpdateDirectoryUseCase(this.directoriesRepo);

  Future<List<DirectoryModel>> call(DirectoryModel model) {
    final int key = model.idHiveObject ?? 0;

    return directoriesRepo.updateDirectory(key: key, value: model);
  }
}

import 'package:psws_storage/editor/domain/model/directory_model.dart';
import 'package:psws_storage/editor/domain/repo/directories_repo.dart';

class DeleteListDirectoriesUseCase {
  final DirectoriesRepo directoriesRepo;

  DeleteListDirectoriesUseCase(this.directoriesRepo);

  Future<List<DirectoryModel>> call(List<int> keys) {
    return directoriesRepo.deleteDirectories(keys);
  }
}

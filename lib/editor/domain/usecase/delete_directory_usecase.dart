import 'package:psws_storage/editor/domain/model/directory_model.dart';
import 'package:psws_storage/editor/domain/repo/directories_repo.dart';

class DeleteDirectoryUseCase {
  final DirectoriesRepo directoriesRepo;

  DeleteDirectoryUseCase(this.directoriesRepo);

  Future<List<DirectoryModel>> call(DirectoryModel directoryModel) {
    return directoriesRepo.deleteDirectory(directoryModel);
  }
}

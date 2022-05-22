import 'package:psws_storage/domain/model/directory_model.dart';
import 'package:psws_storage/domain/repo/directories_repo.dart';

class DeleteDirectoryUseCase{
  final DirectoriesRepo directoriesRepo;

  DeleteDirectoryUseCase(this.directoriesRepo);

  Future<List<DirectoryModel>> call(DirectoryModel directoryModel){
    return directoriesRepo.deleteDirectory(directoryModel);
  }
}
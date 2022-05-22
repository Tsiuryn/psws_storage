import 'package:psws_storage/domain/model/directory_model.dart';
import 'package:psws_storage/domain/repo/directories_repo.dart';

class GetListDirectoriesUseCase{
  final DirectoriesRepo directoriesRepo;

  GetListDirectoriesUseCase(this.directoriesRepo);

  Future<List<DirectoryModel>> call(){
    return directoriesRepo.getDirectories();
  }
}
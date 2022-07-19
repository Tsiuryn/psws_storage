import 'package:psws_storage/editor/domain/model/directory_model.dart';
import 'package:psws_storage/editor/domain/repo/directories_repo.dart';

class GetDirectoryUseCase {
  final DirectoriesRepo directoriesRepo;

  GetDirectoryUseCase(this.directoriesRepo);

  Future<DirectoryModel?> call(int idHiveObject) {
    return directoriesRepo.getDirectory(idHiveObject);
  }
}

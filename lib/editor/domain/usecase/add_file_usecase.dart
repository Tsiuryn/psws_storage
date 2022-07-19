import 'package:psws_storage/editor/domain/model/directory_model.dart';
import 'package:psws_storage/editor/domain/repo/directories_repo.dart';

class AddFileUseCase {
  final DirectoriesRepo directoriesRepo;

  AddFileUseCase(this.directoriesRepo);

  Future<List<DirectoryModel>> call(DirectoryModel model) {
    return directoriesRepo.addDirectory(model);
  }
}

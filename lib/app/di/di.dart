import 'package:get_it/get_it.dart';
import 'package:psws_storage/data/directories_repo_impl.dart';
import 'package:psws_storage/domain/repo/directories_repo.dart';
import 'package:psws_storage/domain/usecase/add_file_usecase.dart';
import 'package:psws_storage/domain/usecase/delete_directory_usecase.dart';
import 'package:psws_storage/domain/usecase/get_list_directories_usecase.dart';
import 'package:psws_storage/presenter/main/bloc/main_bloc.dart';

GetIt getIt = GetIt.instance;

void initDi(){

  // Repository
  getIt.registerSingleton<DirectoriesRepo>(DirectoriesRepoImpl());

  //UseCase
  getIt.registerFactory<AddFileUseCase>(() => AddFileUseCase(getIt.get<DirectoriesRepo>()));
  getIt.registerFactory<GetListDirectoriesUseCase>(() => GetListDirectoriesUseCase(getIt.get<DirectoriesRepo>()));
  getIt.registerFactory<DeleteDirectoryUseCase>(() => DeleteDirectoryUseCase(getIt.get<DirectoriesRepo>()));

  //Bloc
  getIt.registerFactory<MainBloc>(() => MainBloc(
    addFileUseCase: getIt.get<AddFileUseCase>(),
    getListDirectoriesUseCase: getIt.get<GetListDirectoriesUseCase>(),
    deleteDirectoryUseCase: getIt.get<DeleteDirectoryUseCase>(),
  ));
}

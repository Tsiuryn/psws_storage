import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:psws_storage/app/app_bloc/app_bloc.dart';
import 'package:psws_storage/data/directories_repo_impl.dart';
import 'package:psws_storage/domain/repo/directories_repo.dart';
import 'package:psws_storage/domain/usecase/add_file_usecase.dart';
import 'package:psws_storage/domain/usecase/delete_directory_usecase.dart';
import 'package:psws_storage/domain/usecase/delete_list_directories_usecase.dart';
import 'package:psws_storage/domain/usecase/get_directory_usecase.dart';
import 'package:psws_storage/domain/usecase/get_list_directories_usecase.dart';
import 'package:psws_storage/domain/usecase/update_directory_usecase.dart';
import 'package:psws_storage/presenter/main/bloc/main_bloc.dart';
import 'package:psws_storage/presenter/notes/bloc/edit_notes_bloc.dart';
import 'package:psws_storage/presenter/pin/data/pin_repo_impl.dart';
import 'package:psws_storage/presenter/pin/domain/pin_repo.dart';
import 'package:psws_storage/presenter/pin/domain/usecase/read_registration_pin_usecase.dart';
import 'package:psws_storage/presenter/pin/domain/usecase/write_registration_pin_usecase.dart';
import 'package:psws_storage/presenter/pin/presentation/bloc/pin_bloc.dart';

GetIt getIt = GetIt.instance;
const _idSecureStorage = '_idSecureStorage';

void initDi() {
  //SecureStorage
  getIt.registerLazySingleton<FlutterSecureStorage>(
      () => const FlutterSecureStorage(),
      instanceName: _idSecureStorage);

  // Repository
  getIt.registerSingleton<DirectoriesRepo>(DirectoriesRepoImpl());
  getIt.registerSingleton<PinRepo>(PinRepoImpl(
      getIt.get<FlutterSecureStorage>(instanceName: _idSecureStorage)));

  //UseCase
  getIt.registerFactory<AddFileUseCase>(
      () => AddFileUseCase(getIt.get<DirectoriesRepo>()));
  getIt.registerFactory<GetListDirectoriesUseCase>(
      () => GetListDirectoriesUseCase(getIt.get<DirectoriesRepo>()));
  getIt.registerFactory<GetDirectoryUseCase>(
      () => GetDirectoryUseCase(getIt.get<DirectoriesRepo>()));
  getIt.registerFactory<DeleteDirectoryUseCase>(
      () => DeleteDirectoryUseCase(getIt.get<DirectoriesRepo>()));
  getIt.registerFactory<DeleteListDirectoriesUseCase>(
      () => DeleteListDirectoriesUseCase(getIt.get<DirectoriesRepo>()));
  getIt.registerFactory<UpdateDirectoryUseCase>(
      () => UpdateDirectoryUseCase(getIt.get<DirectoriesRepo>()));

  getIt.registerFactory<ReadRegistrationPinUseCase>(
      () => ReadRegistrationPinUseCase(getIt.get<PinRepo>()));
  getIt.registerFactory<WriteRegistrationPinUseCase>(
      () => WriteRegistrationPinUseCase(getIt.get<PinRepo>()));

  //Bloc
  getIt.registerSingleton<AppBloc>(AppBloc());

  getIt.registerFactory<MainBloc>(() => MainBloc(
        addFileUseCase: getIt.get<AddFileUseCase>(),
        getListDirectoriesUseCase: getIt.get<GetListDirectoriesUseCase>(),
        deleteDirectoryUseCase: getIt.get<DeleteDirectoryUseCase>(),
        deleteListDirectories: getIt.get<DeleteListDirectoriesUseCase>(),
      ));

  getIt.registerFactory(() => EditNotesBloc(
        updateDirectory: getIt.get<UpdateDirectoryUseCase>(),
        getDirectory: getIt.get<GetDirectoryUseCase>(),
      ));

  getIt.registerFactory<PinBloc>(() =>
      PinBloc(
        readRegistrationPin: getIt.get<ReadRegistrationPinUseCase>(),
        writeRegistrationPin: getIt.get<WriteRegistrationPinUseCase>(),
      ));
}

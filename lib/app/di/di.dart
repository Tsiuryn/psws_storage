import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:psws_storage/app/app_bloc/app_bloc.dart';
import 'package:psws_storage/app/data/settings_gateway_impl.dart';
import 'package:psws_storage/app/domain/settings_gateway.dart';
import 'package:psws_storage/app/domain/usecase/get_environment_usecase.dart';
import 'package:psws_storage/app/domain/usecase/save_environment.dart';
import 'package:psws_storage/editor/data/directories_repo_impl.dart';
import 'package:psws_storage/editor/domain/repo/directories_repo.dart';
import 'package:psws_storage/editor/domain/usecase/add_file_usecase.dart';
import 'package:psws_storage/editor/domain/usecase/delete_directory_usecase.dart';
import 'package:psws_storage/editor/domain/usecase/delete_list_directories_usecase.dart';
import 'package:psws_storage/editor/domain/usecase/get_directory_usecase.dart';
import 'package:psws_storage/editor/domain/usecase/get_list_directories_usecase.dart';
import 'package:psws_storage/editor/domain/usecase/update_directory_usecase.dart';
import 'package:psws_storage/editor/presenter/main/bloc/main_bloc.dart';
import 'package:psws_storage/editor/presenter/notes/bloc/edit_notes_bloc.dart';
import 'package:psws_storage/pin/data/pin_repo_impl.dart';
import 'package:psws_storage/pin/domain/pin_repo.dart';
import 'package:psws_storage/pin/domain/usecase/read_registration_pin_usecase.dart';
import 'package:psws_storage/pin/domain/usecase/write_registration_pin_usecase.dart';
import 'package:psws_storage/pin/presentation/bloc/pin_bloc.dart';

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
  getIt.registerSingleton<SettingsGateway>(SettingsGatewayImpl(
      getIt.get<FlutterSecureStorage>(instanceName: _idSecureStorage)));

  //UseCase
  getIt.registerFactory<GetEnvironmentUseCase>(
      () => GetEnvironmentUseCase(getIt.get<SettingsGateway>()));
  getIt.registerFactory<SaveEnvironmentUseCase>(
      () => SaveEnvironmentUseCase(getIt.get<SettingsGateway>()));

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
  getIt.registerSingleton<AppBloc>(AppBloc(
    getEnvironment: getIt.get<GetEnvironmentUseCase>(),
    saveEnvironment: getIt.get<SaveEnvironmentUseCase>(),
  ));

  getIt.registerFactory<MainBloc>(() =>
      MainBloc(
        addFileUseCase: getIt.get<AddFileUseCase>(),
        getListDirectoriesUseCase: getIt.get<GetListDirectoriesUseCase>(),
        deleteDirectoryUseCase: getIt.get<DeleteDirectoryUseCase>(),
        deleteListDirectories: getIt.get<DeleteListDirectoriesUseCase>(),
      ));

  getIt.registerFactory(() =>
      EditNotesBloc(
        updateDirectory: getIt.get<UpdateDirectoryUseCase>(),
        getDirectory: getIt.get<GetDirectoryUseCase>(),
      ));

  getIt.registerFactory<PinBloc>(() =>
      PinBloc(
        readRegistrationPin: getIt.get<ReadRegistrationPinUseCase>(),
        writeRegistrationPin: getIt.get<WriteRegistrationPinUseCase>(),
      ));
}

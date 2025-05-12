import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:psws_storage/app/app_bloc/app_bloc.dart';
import 'package:psws_storage/app/data/settings_gateway_impl.dart';
import 'package:psws_storage/app/domain/settings_gateway.dart';
import 'package:psws_storage/app/domain/usecase/get_environment_usecase.dart';
import 'package:psws_storage/app/domain/usecase/save_environment.dart';
import 'package:psws_storage/editor/data/bean/directory_bean.dart';
import 'package:psws_storage/editor/data/directories_repo_impl.dart';
import 'package:psws_storage/goals/data/repo/goal_repo_impl.dart';
import 'package:psws_storage/goals/data/source/goals_data_source.dart';
import 'package:psws_storage/goals/data/source/local/db/goals_database.dart';
import 'package:psws_storage/goals/data/source/local/goals_local_data_source.dart';
import 'package:psws_storage/editor/domain/repo/directories_repo.dart';
import 'package:psws_storage/goals/domain/repo/goal_repo.dart';
import 'package:psws_storage/editor/domain/usecase/add_file_usecase.dart';
import 'package:psws_storage/editor/domain/usecase/delete_directory_usecase.dart';
import 'package:psws_storage/editor/domain/usecase/delete_list_directories_usecase.dart';
import 'package:psws_storage/editor/domain/usecase/get_directory_usecase.dart';
import 'package:psws_storage/editor/domain/usecase/get_list_directories_usecase.dart';
import 'package:psws_storage/editor/domain/usecase/update_directory_usecase.dart';
import 'package:psws_storage/goals/presenter/bloc/goals_bloc.dart';
import 'package:psws_storage/editor/presenter/main/bloc/main_bloc.dart';
import 'package:psws_storage/editor/presenter/notes/bloc/edit_notes_bloc.dart';
import 'package:psws_storage/pin/data/pin_repo_impl.dart';
import 'package:psws_storage/pin/domain/pin_repo.dart';
import 'package:psws_storage/pin/domain/usecase/read_registration_pin_usecase.dart';
import 'package:psws_storage/pin/domain/usecase/write_registration_pin_usecase.dart';
import 'package:psws_storage/pin/presentation/bloc/pin_bloc.dart';
import 'package:psws_storage/settings/data/import_export_gateway_impl.dart';
import 'package:psws_storage/settings/data/source/archive_data_source.dart';
import 'package:psws_storage/settings/data/source/data_agregator_data_source.dart';
import 'package:psws_storage/settings/data/source/text_encrypter_data_source.dart';
import 'package:psws_storage/settings/domain/gateway/import_export_gateway.dart';
import 'package:psws_storage/settings/domain/usecase/export_database_usecase.dart';
import 'package:psws_storage/settings/domain/usecase/import_database_usecase.dart';
import 'package:psws_storage/settings/presentation/bloc/settings_bloc.dart';
import 'package:psws_storage/settings/presentation/change_psw/change_psw_bloc.dart';
import 'package:psws_storage/settings/presentation/import_export/bloc/import_export_bloc.dart';

GetIt getIt = GetIt.instance;
const String databaseName = 'PSWS_Database';
const String habitDatabaseName = 'PSWS_habitDatabaseName';
const String statisticsDatabaseName = 'PSWS_statisticsDatabaseName';
const _idSecureStorage = '_idSecureStorage';
const String _idDatabase = 'PSWS_STORAGE_ID';
const String _encryptionKey = 'encryptionKey';
const aOptions = AndroidOptions(encryptedSharedPreferences: true);

Future<void> initDi(GoalsDatabase db) async {
  //SecureStorage
  getIt.registerSingleton<FlutterSecureStorage>(const FlutterSecureStorage(),
      instanceName: _idSecureStorage);

  getIt.registerSingleton<GoalsDatabase>(db);

  // initialize DataBase
  await _initDB(
    getIt.get<FlutterSecureStorage>(
      instanceName: _idSecureStorage,
    ),
  );

  //DataSource
  getIt.registerSingleton<GoalsDataSource>(
      GoalsLocalDataSource(getIt.get<GoalsDatabase>()));

  // Repository
  getIt.registerSingleton<GoalRepo>(GoalRepoImpl(getIt.get<GoalsDataSource>()));

  getIt.registerSingleton<DirectoriesRepo>(DirectoriesRepoImpl());

  getIt.registerSingleton<PinRepo>(PinRepoImpl(
    secureStorage:
        getIt.get<FlutterSecureStorage>(instanceName: _idSecureStorage),
    androidOptions: aOptions,
  ));
  getIt.registerSingleton<SettingsGateway>(SettingsGatewayImpl(
    secureStorage:
        getIt.get<FlutterSecureStorage>(instanceName: _idSecureStorage),
    androidOptions: aOptions,
  ));
  getIt.registerFactory<DataAgregatorDataSource>(
    () => DataAgregatorDataSource(
      futureBox: () =>
          getIt.get<Future<Box<DirectoryBean>>>(instanceName: databaseName),
      goalsDataSource: getIt.get<GoalsDataSource>(),
    ),
  );
  getIt.registerFactory<TextEncrypterDataSource>(
      () => TextEncrypterDataSource());
  getIt.registerFactory<ArchiveDataSource>(() => ArchiveDataSource());
  getIt.registerSingleton<ImportExportGateway>(
    ImportExportGatewayImpl(
      dataAgregator: getIt.get<DataAgregatorDataSource>(),
      textEncrypter: getIt.get<TextEncrypterDataSource>(),
      archiveDataSource: getIt.get<ArchiveDataSource>(),
    ),
  );

  //UseCase
  getIt.registerFactory<GetEnvironmentUseCase>(
      () => GetEnvironmentUseCase(getIt.get<SettingsGateway>()));
  getIt.registerFactory<SaveEnvironmentUseCase>(
      () => SaveEnvironmentUseCase(getIt.get<SettingsGateway>()));
  getIt.registerFactory<ExportDatabaseUseCase>(
      () => ExportDatabaseUseCase(getIt.get<ImportExportGateway>()));
  getIt.registerFactory<ImportDatabaseUseCase>(
      () => ImportDatabaseUseCase(getIt.get<ImportExportGateway>()));

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
  getIt.registerSingleton<AppBloc>(
    AppBloc(
      environment: await getIt.get<GetEnvironmentUseCase>().call(),
      saveEnvironment: getIt.get<SaveEnvironmentUseCase>(),
    ),
  );

  getIt.registerLazySingleton<MainBloc>(
    () => MainBloc(
      addFileUseCase: getIt.get<AddFileUseCase>(),
      getListDirectoriesUseCase: getIt.get<GetListDirectoriesUseCase>(),
      deleteDirectoryUseCase: getIt.get<DeleteDirectoryUseCase>(),
      deleteListDirectories: getIt.get<DeleteListDirectoriesUseCase>(),
      updateDirectory: getIt.get<UpdateDirectoryUseCase>(),
      getDirectory: getIt.get<GetDirectoryUseCase>(),
      sort: getIt.get<AppBloc>().state.sort,
    ),
  );

  getIt.registerFactory(
    () => EditNotesBloc(
      updateDirectory: getIt.get<UpdateDirectoryUseCase>(),
      getDirectory: getIt.get<GetDirectoryUseCase>(),
    ),
  );

  getIt.registerFactory<PinBloc>(
    () => PinBloc(
      readRegistrationPin: getIt.get<ReadRegistrationPinUseCase>(),
      writeRegistrationPin: getIt.get<WriteRegistrationPinUseCase>(),
      getEnvironmentUseCase: getIt.get<GetEnvironmentUseCase>(),
    ),
  );

  getIt.registerFactory<SettingsBloc>(() => SettingsBloc());

  getIt.registerFactory<ChangePswBloc>(() => ChangePswBloc(
        readRegistrationPin: getIt.get<ReadRegistrationPinUseCase>(),
        writeRegistrationPin: getIt.get<WriteRegistrationPinUseCase>(),
      ));

  getIt.registerFactory<ImportExportBloc>(
    () => ImportExportBloc(
      exportDatabaseUseCase: getIt.get<ExportDatabaseUseCase>(),
      importDatabaseUseCase: getIt.get<ImportDatabaseUseCase>(),
    ),
  );

  getIt.registerFactory<GoalsBloc>(
    () => GoalsBloc(
      repo: getIt.get<GoalRepo>(),
    ),
  );
}

Future<void> _initDB(FlutterSecureStorage secureStorage) async {
  bool containsEncryptionKey = await secureStorage.containsKey(
    key: _encryptionKey,
    aOptions: aOptions,
  );
  if (!containsEncryptionKey) {
    List<int> hiveKey = Hive.generateSecureKey();
    await secureStorage.write(
      key: _encryptionKey,
      value: base64UrlEncode(hiveKey),
      aOptions: aOptions,
    );
  }

  final key = await secureStorage.read(key: _encryptionKey, aOptions: aOptions);

  if (key != null) {
    Uint8List encryptionKey = base64Url.decode(key);

    getIt.registerFactory<Future<Box<DirectoryBean>>>(
      () async => await Hive.openBox(
        _idDatabase,
        encryptionCipher: HiveAesCipher(encryptionKey),
      ),
      instanceName: databaseName,
    );
  }
}

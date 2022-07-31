import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:permission_handler/permission_handler.dart';

part 'import_export_bloc_model.dart';

part 'import_export_event.dart';

part 'import_export_state.dart';

class ImportExportBloc extends Bloc<ImportExportEvent, ImportExportState> {
  ImportExportBloc() : super(ImportExportState.initial()) {
    on<ImportExportCheckPermissionEvent>(_onCheckPermissionEvent);
  }

  Future<void> _onCheckPermissionEvent(
    ImportExportCheckPermissionEvent event,
    Emitter<ImportExportState> emit,
  ) async {
    if (kIsWeb) {
      emit(ImportExportState.success(state.model));
    }
    if (Platform.isIOS) {
      emit(ImportExportState.success(state.model));
    } else {
      var writeStorageStatus = await Permission.storage.status;
      if (writeStorageStatus.isGranted) {
        emit(ImportExportState.success(state.model));
      } else {
        final requestWriteStorageStatus = await Permission.storage.request();
        if (requestWriteStorageStatus.isPermanentlyDenied) {
          emit(ImportExportState.showSettings(state.model));
        } else {
          emit(ImportExportState.showPermissionDialog(state.model));
        }
      }
    }
  }

  Future<void> exportDB() async {
    // final bool statusWriteStorage = await _checkStatusWriteStoragePermission();
    // if (statusWriteStorage) {
    //   if (kIsWeb) {
    //     return;
    //   }
    //   final String? path = Platform.isIOS
    //       ? await getApplicationDocumentsDirectory()
    //       : await getExternalStorageDirectory();
    //   final File file = File('$path/example.txt');
    //   file.writeAsStringSync('Hello world');
    //   print(path);
    // }
    // emit(environment);
  }
}

Future<String> getApplicationDocumentsDirectory() {
  return path_provider.getApplicationDocumentsDirectory().then(
        (directory) => directory.path,
      );
}

Future<String?> getExternalStorageDirectory() {
  return path_provider.getExternalStorageDirectory().then(
        (directory) => directory?.path,
      );
}

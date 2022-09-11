import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:psws_storage/settings/import_export/import_export_page.dart';

import 'settings_state.dart';

class SettingsBloc extends Cubit<SettingsState> {
  SettingsBloc() : super(SettingsState.initial());

  Future<void> checkPermission(ImportExportPageType type) async {
    if (state is! UpdatePage) {
      emit(SettingsState.updatePage(state.model));
    }
    if (kIsWeb || Platform.isIOS) {
      emit(SettingsState.permissionGranted(state.model, type));
    } else {
      final writeStorageStatus = await _checkPermissionWriteStorage();
      if (writeStorageStatus == AppStoragePermissionStatus.granted) {
        emit(SettingsState.permissionGranted(state.model, type));
      } else {
        if (writeStorageStatus ==
            AppStoragePermissionStatus.permanentlyDenied) {
          emit(SettingsState.showSettings(state.model));
        } else {
          emit(SettingsState.showPermissionDialog(state.model, type));
        }
      }
    }
  }

  Future<AppStoragePermissionStatus> _checkPermissionWriteStorage() async {
    final List<PermissionStatus> statuses = [
      await Permission.storage.request(),
      await Permission.accessMediaLocation.request(),
      await Permission.manageExternalStorage.request(),
    ];

    if (statuses.contains(PermissionStatus.permanentlyDenied)) {
      return AppStoragePermissionStatus.permanentlyDenied;
    }

    if (statuses.firstWhereOrNull((element) => [
              PermissionStatus.denied,
              PermissionStatus.limited,
              PermissionStatus.permanentlyDenied,
            ].contains(element)) ==
        null) {
      return AppStoragePermissionStatus.granted;
    } else {
      return AppStoragePermissionStatus.denied;
    }
  }
}

enum AppStoragePermissionStatus { denied, granted, permanentlyDenied }

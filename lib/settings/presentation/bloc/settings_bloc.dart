import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:psws_storage/settings/presentation/import_export/import_export_page.dart';

import 'settings_state.dart';

class SettingsBloc extends Cubit<SettingsState> {
  SettingsBloc() : super(SettingsState.initial()) {
    _initialSettings();
  }

  Future<void> _initialSettings() async {
    final LocalAuthentication auth = LocalAuthentication();
    final List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();
    if (availableBiometrics.isNotEmpty) {
      emit(SettingsState.updatePage(state.model.copyWith(
        showBiometrics: true,
      )));
    }
  }

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
      }
      else {
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
    final status = await Permission.storage.request();

    if (status == PermissionStatus.permanentlyDenied) {
      return AppStoragePermissionStatus.permanentlyDenied;
    }

    if ([
      PermissionStatus.denied,
      PermissionStatus.limited,
      PermissionStatus.permanentlyDenied,
    ].contains(status)) {
      return AppStoragePermissionStatus.denied;
    } else {
      return AppStoragePermissionStatus.granted;
    }
  }
}

enum AppStoragePermissionStatus { denied, granted, permanentlyDenied }

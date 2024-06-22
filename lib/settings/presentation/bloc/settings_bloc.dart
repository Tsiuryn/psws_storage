import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
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
    emit(SettingsState.permissionGranted(state.model, type));
  }
}

enum AppStoragePermissionStatus { denied, granted, permanentlyDenied }

import 'package:psws_storage/settings/presentation/import_export/import_export_page.dart';

abstract class SettingsState {
  final SettingsModel model;

  SettingsState(this.model);

  factory SettingsState.initial() =>
      InitialSettings(const SettingsModel.empty());

  factory SettingsState.updatePage(SettingsModel model) = UpdatePage;

  factory SettingsState.permissionGranted(
          SettingsModel model, ImportExportPageType type) =
      StoragePermissionGranted;

  factory SettingsState.showPermissionDialog(
    SettingsModel model,
    ImportExportPageType type,
  ) = ShowPermissionDialog;
}

class InitialSettings extends SettingsState {
  InitialSettings(SettingsModel model) : super(model);
}

class StoragePermissionGranted extends SettingsState {
  final ImportExportPageType type;

  StoragePermissionGranted(SettingsModel model, this.type) : super(model);
}

class UpdatePage extends SettingsState {
  UpdatePage(SettingsModel model) : super(model);
}

class ShowPermissionDialog extends SettingsState {
  final ImportExportPageType type;

  ShowPermissionDialog(
    SettingsModel model,
    this.type,
  ) : super(model);
}

class SettingsModel {
  final bool showBiometrics;

  const SettingsModel.empty() : showBiometrics = false;

  const SettingsModel({
    required this.showBiometrics,
  });

  SettingsModel copyWith({
    bool? showBiometrics,
  }) =>
      SettingsModel(
        showBiometrics: showBiometrics ?? this.showBiometrics,
      );
}

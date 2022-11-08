import 'package:psws_storage/settings/presentation/import_export/import_export_page.dart';

abstract class SettingsState {
  final SettingsModel model;

  SettingsState(this.model);

  factory SettingsState.initial() => InitialSettings(const SettingsModel.empty());

  factory SettingsState.updatePage(SettingsModel model) = UpdatePage;

  factory SettingsState.permissionGranted(SettingsModel model, ImportExportPageType type) = StoragePermissionGranted;

  factory SettingsState.showSettings(SettingsModel model) = ShowSettings;

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

class ShowSettings extends SettingsState {
  ShowSettings(SettingsModel model) : super(model);
}

class ShowPermissionDialog extends SettingsState {
  final ImportExportPageType type;

  ShowPermissionDialog(
    SettingsModel model,
    this.type,
  ) : super(model);
}

class SettingsModel {
  final bool showMtnImport;

  const SettingsModel.empty() : showMtnImport = false;

  const SettingsModel({
    required this.showMtnImport,
  });

  SettingsModel copyWith({
    bool? showMtnImport,
  }) =>
      SettingsModel(
        showMtnImport: showMtnImport ?? this.showMtnImport,
      );
}

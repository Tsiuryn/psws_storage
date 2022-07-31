part of 'import_export_bloc.dart';

abstract class ImportExportState {
  final ImportExportBlocModel model;

  const ImportExportState(this.model);

  factory ImportExportState.initial() =>
      const ImportExportInitialState(ImportExportBlocModel.empty());

  const factory ImportExportState.loading(ImportExportBlocModel model) =
      ImportExportLoadingState;

  const factory ImportExportState.success(ImportExportBlocModel model) =
      ImportExportSuccessState;

  const factory ImportExportState.showPermissionDialog(
      ImportExportBlocModel model) = ImportExportShowPermissionDialogState;

  const factory ImportExportState.showSettings(ImportExportBlocModel model) =
      ImportExportShowSettingsState;
}

class ImportExportInitialState extends ImportExportState {
  const ImportExportInitialState(ImportExportBlocModel model) : super(model);
}

class ImportExportLoadingState extends ImportExportState {
  const ImportExportLoadingState(ImportExportBlocModel model) : super(model);
}

class ImportExportSuccessState extends ImportExportState {
  const ImportExportSuccessState(ImportExportBlocModel model) : super(model);
}

class ImportExportShowPermissionDialogState extends ImportExportState {
  const ImportExportShowPermissionDialogState(ImportExportBlocModel model)
      : super(model);
}

class ImportExportShowSettingsState extends ImportExportState {
  const ImportExportShowSettingsState(ImportExportBlocModel model)
      : super(model);
}

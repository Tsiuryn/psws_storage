part of 'import_export_bloc.dart';

abstract class ImportExportEvent {
  const ImportExportEvent();

  factory ImportExportEvent.initial() = ImportExportInitialEvent;

  factory ImportExportEvent.checkPermission() =
      ImportExportCheckPermissionEvent;
}

class ImportExportInitialEvent extends ImportExportEvent {
  const ImportExportInitialEvent() : super();
}

class ImportExportCheckPermissionEvent extends ImportExportEvent {
  const ImportExportCheckPermissionEvent() : super();
}

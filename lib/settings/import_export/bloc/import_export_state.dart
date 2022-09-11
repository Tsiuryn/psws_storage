part of 'import_export_bloc.dart';

class ImportExportState {
  final ImportExportStateType type;
  final String? pathToFileOrFolder;

  const ImportExportState({required this.type, this.pathToFileOrFolder});

  ImportExportState.empty()
      : type = ImportExportStateType.initial,
        pathToFileOrFolder = null;

  ImportExportState copyWith({
    ImportExportStateType? type,
    String? pathToFileOrFolder,
  }) =>
      ImportExportState(
        type: type ?? this.type,
        pathToFileOrFolder: pathToFileOrFolder ?? this.pathToFileOrFolder,
      );
}

enum ImportExportStateType { initial, update, success }

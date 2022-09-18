part of 'import_export_bloc.dart';

class ImportExportState {
  final ImportExportStateType type;
  final ImportType importType;
  final String? pathToFileOrFolder;
  final String? error;

  const ImportExportState(
      {required this.type,
      required this.importType,
      this.pathToFileOrFolder,
      this.error});

  ImportExportState.empty()
      : type = ImportExportStateType.initial,
        importType = ImportType.add,
        error = null,
        pathToFileOrFolder = null;

  ImportExportState copyWith({
    ImportExportStateType? type,
    ImportType? importType,
    String? pathToFileOrFolder,
    String? error,
  }) =>
      ImportExportState(
        type: type ?? this.type,
        importType: importType ?? this.importType,
        pathToFileOrFolder: pathToFileOrFolder ?? this.pathToFileOrFolder,
        error: error ?? this.error,
      );
}

enum ImportExportStateType {
  initial,
  loading,
  update,
  exportSuccess,
  importSuccess,
  error,
}

enum ImportType { rewrite, add }

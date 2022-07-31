part of 'import_export_bloc.dart';

class ImportExportBlocModel {
  final String exportPath;

  const ImportExportBlocModel({
    required this.exportPath,
  });

  ImportExportBlocModel copyWith({
    String? exportPath,
  }) =>
      ImportExportBlocModel(
        exportPath: exportPath ?? this.exportPath,
      );

  const ImportExportBlocModel.empty() : exportPath = '';
}

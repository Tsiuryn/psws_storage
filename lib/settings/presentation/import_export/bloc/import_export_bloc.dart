import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:psws_storage/settings/domain/entity/export_config.dart';
import 'package:psws_storage/settings/domain/entity/import_config.dart';
import 'package:psws_storage/settings/domain/usecase/export_database_usecase.dart';
import 'package:psws_storage/settings/domain/usecase/import_database_usecase.dart';

part 'import_export_state.dart';

class ImportExportBloc extends Cubit<ImportExportState> {
  final ExportDatabaseUseCase exportDatabaseUseCase;
  final ImportDatabaseUseCase importDatabaseUseCase;

  ImportExportBloc({
    required this.exportDatabaseUseCase,
    required this.importDatabaseUseCase,
  }) : super(ImportExportState.empty());

  Future<void> exportDatabase(ExportConfig exportConfig) async {
    try {
      emit(state.copyWith(type: ImportExportStateType.loading));
      await exportDatabaseUseCase(exportConfig);
      emit(state.copyWith(type: ImportExportStateType.exportSuccess));
    } catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(
          type: ImportExportStateType.error, error: e.toString()));
    }
  }

  Future<void> getFolderPath() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory != null) {
      debugPrint(selectedDirectory);
      emit(state.copyWith(pathToFileOrFolder: selectedDirectory));
    }
  }

  Future<void> getFilePath() async {
    FilePickerResult? selectedFile = await FilePicker.platform.pickFiles();

    if (selectedFile != null && selectedFile.files.isNotEmpty) {
      debugPrint(selectedFile.toString());
      final file = selectedFile.files[0];

      emit(state.copyWith(pathToFileOrFolder: file.path));
    }
  }

  Future<void> changeImportType(ImportType importType) async {
    emit(state.copyWith(importType: importType));
  }

  Future<void> importDatabase(ImportConfig importConfig) async {
    try {
      emit(state.copyWith(type: ImportExportStateType.loading));
      await importDatabaseUseCase(importConfig);
      emit(state.copyWith(type: ImportExportStateType.importSuccess));
    } catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(
          type: ImportExportStateType.error, error: e.toString()));
    }
  }
}

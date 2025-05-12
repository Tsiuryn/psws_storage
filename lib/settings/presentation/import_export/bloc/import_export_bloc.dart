import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:psws_storage/settings/domain/entity/export_config.dart';
import 'package:psws_storage/settings/domain/entity/import_config.dart';
import 'package:psws_storage/settings/domain/usecase/export_database_usecase.dart';
import 'package:psws_storage/settings/domain/usecase/import_database_usecase.dart';
import 'package:share_plus/share_plus.dart';

part 'import_export_state.dart';

class ImportExportBloc extends Cubit<ImportExportState> {
  final ExportDatabaseUseCase exportDatabaseUseCase;
  final ImportDatabaseUseCase importDatabaseUseCase;

  ImportExportBloc({
    required this.exportDatabaseUseCase,
    required this.importDatabaseUseCase,
  }) : super(ImportExportState.empty());

  Future<void> getPathDirectory() async {
    List<Directory>? directories = await getExternalStorageDirectories();
    if (directories != null && directories.isNotEmpty) {
      emit(state.copyWith(pathToFileOrFolder: directories[0].path));
    }
  }

  Future<void> exportDatabase(ExportConfig exportConfig) async {
    try {
      emit(state.copyWith(type: ImportExportStateType.loading));
      await exportDatabaseUseCase(exportConfig);
      final fullPath =
          '${state.pathToFileOrFolder}/${exportConfig.fileName}.psws';
      Share.shareXFiles([
        XFile(
          fullPath,
        )
      ]).then((value) {
        emit(state.copyWith(
          type: ImportExportStateType.exportSuccess,
        ));
      });
    } catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(
          type: ImportExportStateType.error, error: e.toString()));
      rethrow;
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
      emit(
        state.copyWith(
          type: ImportExportStateType.error,
          error: e.toString(),
        ),
      );
      rethrow;
    }
  }
}

import 'dart:io';

import 'package:flutter_archive/flutter_archive.dart';
import 'package:path_provider/path_provider.dart';

class ArchiveDataSource {
  Future<void> createZip(
      {required String dirPath,
      required List<File> files,
      required String zipFileName}) async {
    final sourceDir = Directory(dirPath);
    final zipFile = File('$dirPath/$zipFileName.psws');

    await ZipFile.createFromFiles(
      sourceDir: sourceDir,
      files: files,
      zipFile: zipFile,
    );
  }

  Future<String?> extractZip(String zipFilePath) async {
    final zipFile = File(zipFilePath);
    final externalStoragePath = await _getExternalStoragePath();
    if (externalStoragePath == null) return null;

    final dirName = zipFile.path
      ..replaceAll(zipFile.parent.path, '')
      ..replaceAll('psws', '');

    final destinationDir = Directory('$externalStoragePath/$dirName');
    try {
      await ZipFile.extractToDirectory(
          zipFile: zipFile, destinationDir: destinationDir);
      return destinationDir.path;
    } catch (e) {
      return null;
    }
  }

  Future<String?> _getExternalStoragePath() async {
    List<Directory>? directories = await getExternalStorageDirectories();
    if (directories != null && directories.isNotEmpty) {
      return directories[0].path;
    }

    return null;
  }
}

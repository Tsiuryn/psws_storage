import 'dart:convert';
import 'dart:io';
import 'package:psws_storage/settings/bean/directories_json.dart';
import 'package:psws_storage/settings/bean/goals_json.dart';
import 'package:psws_storage/settings/data/source/archive_data_source.dart';
import 'package:psws_storage/settings/data/source/data_agregator_data_source.dart';
import 'package:psws_storage/settings/data/source/text_encrypter_data_source.dart';
import 'package:psws_storage/settings/domain/entity/export_config.dart';
import 'package:psws_storage/settings/domain/entity/import_config.dart';
import 'package:psws_storage/settings/domain/gateway/import_export_gateway.dart';

class ImportExportGatewayImpl extends ImportExportGateway {
  final DataAgregatorDataSource dataAgregator;
  final TextEncrypterDataSource textEncrypter;
  final ArchiveDataSource archiveDataSource;

  ImportExportGatewayImpl({
    required this.dataAgregator,
    required this.textEncrypter,
    required this.archiveDataSource,
  });

  @override
  Future<void> exportDataBase(ExportConfig config) async {
    final directories = await dataAgregator.getDirectories();
    final String textDirectories = jsonEncode(directories.toJson());

    final dirContent = File('${_getFullPath(config)}.dir');
    await dirContent.writeAsString(
      textEncrypter.encrypt(
        psw: config.password,
        plainText: textDirectories,
      ),
    );

    final goals = await dataAgregator.getGoals();
    final textGoals = jsonEncode(goals.toJson());

    final goalContent = File('${_getFullPath(config)}.goal');
    await goalContent.writeAsString(
      textEncrypter.encrypt(
        psw: config.password,
        plainText: textGoals,
      ),
    );

    await archiveDataSource.createZip(
      dirPath: config.path,
      files: [
        dirContent,
        goalContent,
      ],
      zipFileName: config.fileName,
    );

    dirContent.delete();
    goalContent.delete();
  }

  String _getFullPath(ExportConfig config) {
    return '${config.path}/${config.fileName}';
  }

  @override
  Future<void> importDataBase(ImportConfig config) async {
    final dirPath = await archiveDataSource.extractZip(config.path);
    if (dirPath != null) {
      final dir = Directory(dirPath);
      final List<FileSystemEntity> files = dir.listSync();
      File? goalFile;
      File? pswsFile;
      for (var file in files) {
        if (file.path.endsWith('.goal')) {
          goalFile = File(file.path);
        }
        if (file.path.endsWith('.dir')) {
          pswsFile = File(file.path);
        }
      }
      if (goalFile != null) {
        _writeGoalToDB(config, goalFile);
      }
      if (pswsFile != null) {
        await _writeDirToDB(config, pswsFile);
      }
      dir.delete(recursive: true);
    } else {
      final file = File(config.path);
      await _writeDirToDB(config, file);
    }
  }

  Future<void> _writeDirToDB(ImportConfig config, File file) async {
    final jsonString = textEncrypter.decrypt(
      psw: config.password,
      encryptedText: await file.readAsString(),
    );
    final directories = DirectoriesJson.fromJson(jsonDecode(jsonString));

    await dataAgregator.setDirectories(config.type, directories);
  }

  Future<void> _writeGoalToDB(ImportConfig config, File file) async {
    final jsonString = textEncrypter.decrypt(
      psw: config.password,
      encryptedText: await file.readAsString(),
    );

    final goals = GoalsJson.fromJson(jsonDecode(jsonString));

    await dataAgregator.setGoals(config.type, goals);
  }
}

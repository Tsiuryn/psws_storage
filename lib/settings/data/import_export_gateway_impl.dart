import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:psws_storage/app/di/di.dart';
import 'package:psws_storage/editor/data/bean/directory_bean.dart';
import 'package:psws_storage/settings/bean/directories_json.dart';
import 'package:psws_storage/settings/bean/directory_json.dart';
import 'package:psws_storage/settings/domain/entity/export_config.dart';
import 'package:psws_storage/settings/domain/entity/import_config.dart';
import 'package:psws_storage/settings/domain/gateway/import_export_gateway.dart';
import 'package:psws_storage/settings/presentation/import_export/bloc/import_export_bloc.dart';

class ImportExportGatewayImpl extends ImportExportGateway {
  @override
  Future<void> exportDataBase(ExportConfig config) async {
    final Iterable<DirectoryBean> box = (await _openBox()).values;
    final DirectoriesJson directories =
        DirectoriesJson(box.map((e) => e.mapToJson()).toList());
    final String textDirectories = jsonEncode(directories.toJson());

    final file = File(_getFullPath(config));
    await file.writeAsString(_encryptText(
      psw: config.password,
      plainText: textDirectories,
    ));
  }

  String _getFullPath(ExportConfig config) {
    return '${config.path}/${config.fileName}.psws';
  }

  String _encryptText({
    required String psw,
    required String plainText,
  }) {
    List<int> bytes = utf8.encode(psw);
    Digest hash = md5.convert(bytes);
    final key = Key.fromUtf8(hash.toString());
    final iv = IV.fromLength(16); // max: 16

    return Encrypter(AES(key)).encrypt(plainText, iv: iv).base64;
  }

  String _decryptText({
    required String psw,
    required String encryptedText,
  }) {
    List<int> bytes = utf8.encode(psw);
    Digest hash = md5.convert(bytes);
    final key = Key.fromUtf8(hash.toString());
    final iv = IV.fromLength(16); // max: 16

    return Encrypter(AES(key))
        .decrypt(Encrypted.fromBase64(encryptedText), iv: iv);
  }

  Future<Box<DirectoryBean>> _openBox() {
    return getIt.get(instanceName: databaseName);
  }

  @override
  Future<void> importDataBase(ImportConfig config) async {
    final file = File(config.path);
    final jsonString = _decryptText(
      psw: config.password,
      encryptedText: await file.readAsString(),
    );
    final directories = DirectoriesJson.fromJson(jsonDecode(jsonString));
    final directoriesBean =
        directories.directories.map((e) => e.mapToDataBase()).toList();
    final box = await _openBox();

    final List<int> idHiveObject = [];

    switch (config.type) {
      case ImportType.rewrite:
        await box.clear();
        idHiveObject.addAll(await box.addAll(directoriesBean));
        break;
      case ImportType.add:
        idHiveObject.addAll(await box.addAll(directoriesBean));
        break;
    }

    idHiveObject.forEachIndexed((index, idHiveObject) async {
      final directory = directories.directories[index]
          .updateIdHiveObject(idHiveObject)
          .mapToDataBase(isRewrite: true);
      await box.put(idHiveObject, directory);
    });

    await box.close();
  }
}

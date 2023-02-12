import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:psws_storage/app/data/model/environment_bean.dart';
import 'package:psws_storage/app/domain/entity/environment.dart';
import 'package:psws_storage/app/domain/settings_gateway.dart';

class SettingsGatewayImpl extends SettingsGateway {
  final FlutterSecureStorage secureStorage;
  final AndroidOptions androidOptions;

  SettingsGatewayImpl({
    required this.secureStorage,
    required this.androidOptions,
  });

  static const _environmentKey = '_environmentKey';

  @override
  Future<Environment> getEnvironment() async {
    final String? json = await secureStorage.read(key: _environmentKey, aOptions: androidOptions);

    try {
      return EnvironmentBean.fromJson(jsonDecode(json!)).fromBean();
    } catch (e) {
      return Environment.empty();
    }
  }

  @override
  Future<void> saveEnvironment(Environment environment) async {
    await secureStorage.write(
      key: _environmentKey,
      value: jsonEncode(environment.toBean().toJson()),
      aOptions: androidOptions,
    );
  }
}

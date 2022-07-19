import 'package:psws_storage/app/domain/entity/environment.dart';

abstract class SettingsGateway {
  Future<Environment> getEnvironment();

  Future<void> saveEnvironment(Environment environment);
}

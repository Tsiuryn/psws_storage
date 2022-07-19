import 'package:psws_storage/app/domain/entity/environment.dart';
import 'package:psws_storage/app/domain/settings_gateway.dart';

class SaveEnvironmentUseCase {
  final SettingsGateway settingsGateway;

  SaveEnvironmentUseCase(this.settingsGateway);

  Future<void> call(Environment environment) {
    return settingsGateway.saveEnvironment(environment);
  }
}

import 'package:psws_storage/app/domain/entity/environment.dart';
import 'package:psws_storage/app/domain/settings_gateway.dart';

class GetEnvironmentUseCase {
  final SettingsGateway settingsGateway;

  GetEnvironmentUseCase(this.settingsGateway);

  Future<Environment> call() {
    return settingsGateway.getEnvironment();
  }
}

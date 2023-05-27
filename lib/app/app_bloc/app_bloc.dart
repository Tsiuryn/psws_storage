import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:psws_storage/app/domain/entity/environment.dart';
import 'package:psws_storage/app/domain/usecase/save_environment.dart';

class AppBloc extends Cubit<Environment> {
  final SaveEnvironmentUseCase saveEnvironment;

  AppBloc({
    required this.saveEnvironment,
    required Environment environment,
  }) : super(environment);

  Future<void> changeLocale(AppLocale locale) async {
    final environment = state.copyWith(appLocale: locale);
    await saveEnvironment(environment);
    emit(environment);
  }

  Future<void> changeTheme(ThemeType theme) async {
    final environment = state.copyWith(themeType: theme);
    await saveEnvironment(environment);
    emit(environment);
  }

  Future<void> changeBiometrics(LocalAuth localAuth) async {
    final environment = state.copyWith(localAuth: localAuth);
    await saveEnvironment(environment);
    emit(environment);
  }

  Future<void> changeHideScreenParams(HideScreen hideScreen) async {
    final environment = state.copyWith(hideScreen: hideScreen);
    await saveEnvironment(environment);
    emit(environment);
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:psws_storage/app/domain/entity/environment.dart';
import 'package:psws_storage/app/domain/usecase/get_environment_usecase.dart';
import 'package:psws_storage/app/domain/usecase/save_environment.dart';

class AppBloc extends Cubit<Environment> {
  final GetEnvironmentUseCase getEnvironment;
  final SaveEnvironmentUseCase saveEnvironment;

  AppBloc({required this.saveEnvironment, required this.getEnvironment})
      : super(Environment.empty());

  Future<void> init() async {
    emit(await getEnvironment());
  }

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
}

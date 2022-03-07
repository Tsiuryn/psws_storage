import 'package:get_it/get_it.dart';
import 'package:psws_storage/presenter/main/bloc/main_bloc.dart';

GetIt getIt = GetIt.instance;

void initDi(){

  getIt.registerFactory<MainBloc>(() => MainBloc());

}
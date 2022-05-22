import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:psws_storage/app/app_bloc/environment.dart';

class AppBloc extends Cubit<Environment> {

  AppBloc() : super(Environment.empty());

  void init(){
    emit(state);
  }

}



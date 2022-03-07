import 'package:flutter_bloc/flutter_bloc.dart';

import 'main_model.dart';

class MainBloc extends Cubit<MainModel> {

  MainBloc() : super(MainModel.empty());

  void init(){
    emit(state);
  }

}



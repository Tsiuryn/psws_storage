import 'package:flutter/material.dart';
import 'package:psws_storage/app/common/base_page.dart';
import 'package:psws_storage/app/di/di.dart';
import 'package:psws_storage/presenter/main/bloc/main_bloc.dart';
import 'package:psws_storage/presenter/main/bloc/main_model.dart';
import 'package:psws_storage/presenter/main/widgets/main_appbar.dart';

class MainPage
    extends StatelessBasePage<MainBloc, MainModel> {

  const MainPage({Key? key}) : super(key: key);

  @override
  MainBloc createBloc(BuildContext context) {

    return getIt.get<MainBloc>();
  }

  @override
  bool onBackButtonPressed(BuildContext context, MainModel state) {
    return false;
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context, MainModel state) {
    return const MainAppBar();
  }

  @override
  Widget buildBody(BuildContext context, MainModel state) {
      return const Center(
        child: CircularProgressIndicator(),
      );
  }

  
}

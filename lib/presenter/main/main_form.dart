import 'dart:developer';
import 'dart:io';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:psws_storage/app/common/base_page.dart';
import 'package:psws_storage/app/di/di.dart';
import 'package:psws_storage/app/ui_kit/snack_bar.dart';
import 'package:psws_storage/domain/model/directory_model.dart';
import 'package:psws_storage/presenter/main/bloc/main_bloc.dart';
import 'package:psws_storage/presenter/main/bloc/main_model.dart';
import 'package:psws_storage/presenter/main/const/constants.dart';
import 'package:psws_storage/presenter/main/widgets/item_widget.dart';
import 'package:psws_storage/presenter/main/widgets/main_appbar.dart';

class MainForm extends StatelessBasePage<MainBloc, MainModelState>
    with PswsSnackBar {
  const MainForm({Key? key}) : super(key: key);

  @override
  MainBloc createBloc(BuildContext context) {
    return getIt.get<MainBloc>()..initBloc();
  }

  @override
  bool onBackButtonPressed(BuildContext context, MainModelState state) {
    if (state.parentId == rootDirectory) {
      onWillPop(context, state: state);
    } else {
      context.read<MainBloc>().closeFolder();
    }

    return true;
  }

  void onWillPop(BuildContext context, {required MainModelState state}) {
    DateTime now = DateTime.now();
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final MainBloc bloc = context.read<MainBloc>();
    if (now.difference(state.currentBackPressTime) >
        const Duration(seconds: 2)) {
      bloc.changeCurrentBackPressTime(now);
      showRequestSnackBar(
        context,
        message: l10n.app_snack_exit,
      );
    } else {
      exit(0);
    }
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context, MainModelState state) {
    return const MainAppBar();
  }

  @override
  Widget buildBody(BuildContext context, MainModelState state) {
    final listDirectories = state.sortedList;
    final bloc = context.read<MainBloc>();

    return ListView.builder(
        itemCount: listDirectories.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return UpFolder(state: state,);
          } else {
            final DirectoryModel currentDir = listDirectories[index - 1];
            return ItemWidget(
              id: index,
              model: currentDir,
              onTap: () {
                bloc.openFolder(currentDir);
              },
              onDelete: () {
                bloc.deleteFile(currentDir);
              },
            );
          }
        });
  }
}

class UpFolder extends StatelessWidget {
  final MainModelState state;
  const UpFolder({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: state.parentId != rootDirectory,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Icon(Icons.undo_sharp),
              Text('...'),
              
            ],
          ),
          Divider(),
        ],
      ),
    );
  }
}

import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:psws_storage/app/common/base_page.dart';
import 'package:psws_storage/app/di/di.dart';
import 'package:psws_storage/app/dimens/app_dim.dart';
import 'package:psws_storage/app/router/app_router.gr.dart';
import 'package:psws_storage/app/theme/app_colors_ext.dart';
import 'package:psws_storage/app/ui_kit/psws_dialogs.dart';
import 'package:psws_storage/app/ui_kit/snack_bar.dart';
import 'package:psws_storage/editor/domain/model/directory_model.dart';
import 'package:psws_storage/editor/presenter/main/bloc/main_bloc.dart';
import 'package:psws_storage/editor/presenter/main/bloc/main_model.dart';
import 'package:psws_storage/editor/presenter/main/const/constants.dart';
import 'package:psws_storage/editor/presenter/main/widgets/item_widget.dart';
import 'package:psws_storage/editor/presenter/main/widgets/main_appbar.dart';
import 'package:psws_storage/res/resources.dart';

class MainForm extends StatelessBasePage<MainBloc, MainModelState>
    with PswsSnackBar, PswsDialogs {
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
      closeApp();
    }
  }

  void closeApp() {
    if (Platform.isAndroid) {
      SystemNavigator.pop();
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
    final l10n = AppLocalizations.of(context)!;

    return ListView.builder(
        itemCount: listDirectories.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return UpFolder(
              state: state,
            );
          } else {
            final DirectoryModel currentDir = listDirectories[index - 1];
            return ItemWidget(
              id: index,
              model: currentDir,
              onTap: () {
                if (currentDir.isFolder) {
                  bloc.openFolder(currentDir);
                } else {
                  context.router
                      .push(EditNotesRoute(idHive: currentDir.idHiveObject));
                }
              },
              onEdit: () {
                createFileDialog(context,
                    title: currentDir.isFolder
                        ? l10n.main_page__dialog_rename_folder_title
                        : l10n.main_page__dialog_rename_file_title,
                    isFolder: currentDir.isFolder, value: (value) {
                  context.read<MainBloc>().updateName(
                        model: currentDir,
                        newName: value,
                      );
                });
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
    final AppColorsExt? appColors = Theme.of(context).extension<AppColorsExt>();

    return Visibility(
      visible: state.parentId != rootDirectory,
      child: InkWell(
        onTap: () {
          context.read<MainBloc>().closeFolder();
        },
        child: SizedBox(
          height: AppDim.thirtyTwo * 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(state.getPathString()),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(
                      width: AppDim.sixteen,
                    ),
                    SvgPicture.asset(
                      AppIcons.icUp,
                      color: appColors?.textColor,
                    ),
                    const SizedBox(
                      width: AppDim.thirtyTwo,
                    ),
                    SvgPicture.asset(
                      AppIcons.icPoints,
                      color: appColors?.textColor,
                    ),
                  ],
                ),
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:psws_storage/app/theme/app_theme.dart';
import 'package:psws_storage/res/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:psws_storage/app/common/base_page.dart';
import 'package:psws_storage/app/di/di.dart';
import 'package:psws_storage/app/dimens/app_dim.dart';
import 'package:psws_storage/app/router/app_router.dart';
import 'package:psws_storage/app/theme/app_colors_ext.dart';
import 'package:psws_storage/app/ui_kit/psws_dialogs.dart';
import 'package:psws_storage/app/ui_kit/snack_bar.dart';
import 'package:psws_storage/editor/domain/model/directory_model.dart';
import 'package:psws_storage/editor/presenter/main/bloc/main_bloc.dart';
import 'package:psws_storage/editor/presenter/main/bloc/main_model.dart';
import 'package:psws_storage/editor/presenter/main/const/constants.dart';
import 'package:psws_storage/editor/presenter/main/pages/search_directory_page.dart';
import 'package:psws_storage/editor/presenter/main/widgets/item_widget.dart';
import 'package:psws_storage/editor/presenter/main/widgets/expandable_fab_widget.dart';
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
    if (state.parentId == rootDirectoryId) {
      onWillPop(context, state: state);
    } else {
      context.read<MainBloc>().closeFolder();
    }

    return true;
  }

  void onWillPop(BuildContext context, {required MainModelState state}) {
    DateTime now = DateTime.now();
    final AppLocalizations l10n = AppLocalizations.of(context);
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
  Widget? buildFloatingAction(BuildContext context, MainModelState state) {
    return ExpandableFABWidget(state: state);
  }

  @override
  Widget buildBody(BuildContext context, MainModelState state) {
    final listDirectories = state.sortedList;
    final bloc = context.read<MainBloc>();
    final l10n = AppLocalizations.of(context);

    return PopScope(
      canPop: false,
      child: ListView.separated(
        itemCount: listDirectories.length + 1,
        padding: EdgeInsets.only(
          bottom: 72,
        ),
        separatorBuilder: (context, index) {
          if (state.parentId == rootDirectoryId && index == 0) {
            return const SizedBox();
          }

          return const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppDim.sixteen,
            ),
            child: Divider(),
          );
        },
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
              canSwipe: false,
              showPopUpMenuButton: true,
              onTap: () {
                if (currentDir.destinationId != null) {
                  onTapLink(context, currentDir: currentDir, state: state);
                  return;
                } else if (currentDir.isFolder) {
                  bloc.openFolder(currentDir);
                } else {
                  openFile(context, dir: currentDir, state: state);
                }
              },
              onEdit: () {
                createFileDialog(
                  context,
                  initialTextValue: currentDir.name,
                  title: currentDir.isFolder
                      ? l10n.main_page__dialog_rename_folder_title
                      : l10n.main_page__dialog_rename_file_title,
                  isFolder: currentDir.isFolder,
                  value: (value) {
                    context.read<MainBloc>().updateName(
                          model: currentDir,
                          newName: value,
                        );
                  },
                );
              },
              onDelete: () {
                createOkDialog(
                  context,
                  title: currentDir.isFolder
                      ? l10n.main_page__dialog_delete_folder_title
                      : l10n.main_page__dialog_delete_file_title,
                  message: currentDir.isFolder
                      ? l10n.main_page__dialog_delete_folder_description(
                          currentDir.name)
                      : l10n.main_page__dialog_delete_file_description(
                          currentDir.name),
                  tapOk: () {
                    bloc.deleteFile(currentDir);
                  },
                  tapNo: () {},
                );
              },
              onMove: () {
                final folders = state.allFolders;
                if (folders.isNotEmpty) {
                  context.router
                      .push(SearchDirectoryRoute(
                    directories: state.allFolders,
                    searchDestination: SearchDestination.move,
                  ))
                      .then((destinationDirectory) {
                    if (destinationDirectory != null &&
                        destinationDirectory is DirectoryModel) {
                      final isChildDestinationFolder =
                          state.isChild(currentDir.id, destinationDirectory.id);
                      if (!isChildDestinationFolder &&
                          destinationDirectory.id != currentDir.id &&
                          destinationDirectory.parentId != currentDir.id) {
                        context.read<MainBloc>().changeParentId(
                              directory: currentDir,
                              destinationId: destinationDirectory.id,
                            );
                      } else {
                        showRequestSnackBar(context,
                            message: l10n
                                .search_directory__cant_be_destination_folder_message);
                      }
                    }
                  });
                } else {
                  showRequestSnackBar(context,
                      message: l10n.search_directory__no_folders_message);
                }
              },
            );
          }
        },
      ),
    );
  }

  void onTapLink(
    BuildContext context, {
    required DirectoryModel currentDir,
    required MainModelState state,
  }) {
    final bloc = context.read<MainBloc>();
    final l10n = AppLocalizations.of(context);
    final destDirectory = state.directories
        .firstWhereOrNull((element) => element.id == currentDir.destinationId);
    if (destDirectory == null) {
      showRequestSnackBar(
        context,
        message: l10n.main_page__not_found_directory,
      );
    } else if (destDirectory.isFolder) {
      bloc.openFolderFromSearch(destDirectory);
    } else {
      openFile(
        context,
        dir: destDirectory,
        state: state,
      );
    }
  }

  void openFile(
    BuildContext context, {
    required DirectoryModel dir,
    required MainModelState state,
  }) {
    final path = state.convertListToPathText(state.getPathByParentId(dir));
    context.router
        .push(EditNotesRoute(
      idHive: dir.idHiveObject,
      path: path,
      directories: state.directories,
    ))
        .then((value) {
      context.read<MainBloc>().updateDirectoryAfterChanging(dir.idHiveObject);
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
      visible: state.parentId != rootDirectoryId,
      child: InkWell(
        onTap: () {
          context.read<MainBloc>().closeFolder();
        },
        child: SizedBox(
          height: AppDim.thirtyTwo * 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      state.getPathString(),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
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
            ],
          ),
        ),
      ),
    );
  }
}

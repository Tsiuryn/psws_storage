import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:psws_storage/app/app_bloc/app_bloc.dart';
import 'package:psws_storage/app/di/di.dart';
import 'package:psws_storage/app/dimens/app_dim.dart';
import 'package:psws_storage/app/router/app_router.dart';
import 'package:psws_storage/app/theme/app_colors_ext.dart';
import 'package:psws_storage/app/theme/app_theme.dart';
import 'package:psws_storage/app/ui_kit/psws_dialogs.dart';
import 'package:psws_storage/app/ui_kit/snack_bar.dart';
import 'package:psws_storage/editor/domain/model/directory_model.dart';
import 'package:psws_storage/editor/presenter/main/bloc/main_bloc.dart';
import 'package:psws_storage/editor/presenter/main/bloc/main_model.dart';
import 'package:psws_storage/editor/presenter/main/widgets/sort_dialog_content.dart';
import 'package:psws_storage/res/resources.dart';

class MainAppBar extends StatelessWidget
    with PswsSnackBar, PswsDialogs
    implements PreferredSizeWidget {
  final MainModelState state;

  const MainAppBar({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MainBloc>();
    final l10n = AppLocalizations.of(context);
    final folderName = l10n?.main_appbar_dialog_folder ?? '';
    final fileName = l10n?.main_appbar_dialog_note ?? '';
    final AppColorsExt? appColors = Theme.of(context).extension<AppColorsExt>();

    return AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: AppDim.zero,
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(),
      ),
      title: Row(children: [
        const SizedBox(
          width: AppDim.eight,
        ),
        IconButton(
            onPressed: () {
              createFileDialog(context, title: fileName, isFolder: false,
                  value: (fileName) {
                bloc.addFile(fileName).then((value) {
                  if (value.$2.idHiveObject != -1) {
                    context.pushRoute(EditNotesRoute(
                        idHive: value.$2.idHiveObject,
                        path: state.getPathString(),
                        directories: value.$1));
                  }
                });
              });
            },
            icon: SvgPicture.asset(
              AppIcons.icFile,
              color: appColors?.textColor,
            )),
        IconButton(
          onPressed: () {
            createFileDialog(context, title: folderName, value: (folderName) {
              bloc.addFolder(folderName).then((value){
                bloc.openFolder(value.$2);
              });
            });
          },
          icon: SvgPicture.asset(
            AppIcons.icFolder,
            color: appColors?.textColor,
          ),
        ),
        const Expanded(
          child: SizedBox(),
        ),
        IconButton(
            onPressed: () {
              showSortDialog(context);
            },
            icon: Icon(
              Icons.sort,
              color: appColors?.textColor,
              size: AppDim.thirtyTwo,
            )),
        IconButton(
          onPressed: () async {
            context.router
                .push(SearchDirectoryRoute(directories: state.directories))
                .then((directory) {
              if (directory != null && directory is DirectoryModel) {
                if (directory.isFolder) {
                  context.read<MainBloc>().openFolderFromSearch(directory);
                } else {
                  final path = state.convertListToPathText(
                      state.getPathByParentId(directory));
                  context
                      .pushRoute(EditNotesRoute(
                        idHive: directory.idHiveObject,
                        path: path,
                        directories: state.directories,
                      ))
                      .then((value) => context
                          .read<MainBloc>()
                          .updateDirectoryAfterChanging(
                              directory.idHiveObject));
                }
              }
            });
          },
          icon: Icon(
            Icons.search_rounded,
            color: appColors?.textColor,
            size: AppDim.thirtyTwo,
          ),
        ),
        IconButton(
          onPressed: () {
            context.router.push(const SettingsRoute());
          },
          icon: SvgPicture.asset(
            AppIcons.icSettings,
            color: appColors?.textColor,
          ),
        ),
        const SizedBox(
          width: AppDim.eight,
        )
      ]),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);

  void showSortDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final appColors = AppTheme(context).appColors;
    final appTextStyles = AppTheme(context).appTextStyles;
    final appBloc = getIt.get<AppBloc>();
    final mainBloc = context.read<MainBloc>();
    final key = GlobalKey<SortDialogContentState>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.sort_dialog__title),
        content: SortDialogContent(
          key: key,
          sort: appBloc.state.sort,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              l10n.common_dialog_cancel,
              style: TextStyle(
                color: appColors?.textColor,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              final sort = key.currentState?.changedSort;
              if (sort != null) {
                appBloc.changeSort(sort);
                mainBloc.updatedSortList(sort);
              }
              Navigator.of(context).pop();
            },
            child: Text(
              l10n.common_dialog_confirm,
              style: appTextStyles?.titleMedium?.copyWith(
                color: appColors?.textColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}

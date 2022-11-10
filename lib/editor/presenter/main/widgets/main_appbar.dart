import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:psws_storage/app/dimens/app_dim.dart';
import 'package:psws_storage/app/router/app_router.gr.dart';
import 'package:psws_storage/app/theme/app_colors_ext.dart';
import 'package:psws_storage/app/ui_kit/psws_dialogs.dart';
import 'package:psws_storage/app/ui_kit/snack_bar.dart';
import 'package:psws_storage/editor/domain/model/directory_model.dart';
import 'package:psws_storage/editor/presenter/main/bloc/main_bloc.dart';
import 'package:psws_storage/res/resources.dart';

class MainAppBar extends StatelessWidget
    with PreferredSizeWidget, PswsSnackBar, PswsDialogs
    implements PreferredSizeWidget {
  final List<DirectoryModel> directories;

  const MainAppBar({
    Key? key,
    required this.directories,
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
        child: Divider(),
        preferredSize: Size.fromHeight(1),
      ),
      title: Row(children: [
        const SizedBox(
          width: AppDim.eight,
        ),
        IconButton(
            onPressed: () {
              createFileDialog(context, title: fileName, isFolder: false, value: (value) {
                bloc.addFile(value);
              });
            },
            icon: SvgPicture.asset(
              AppIcons.icFile,
              color: appColors?.textColor,
            )),
        IconButton(
          onPressed: () {
            createFileDialog(context, title: folderName, value: (value) {
              bloc.addFolder(value);
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
          onPressed: () async {
            context.router.push(SearchDirectoryRoute(directories: directories)).then((directory) {
              if (directory != null && directory is DirectoryModel) {
                if (directory.isFolder) {
                  context.read<MainBloc>().openFolderFromSearch(directory);
                } else {
                  context.pushRoute(EditNotesRoute(idHive: directory.idHiveObject));
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
}

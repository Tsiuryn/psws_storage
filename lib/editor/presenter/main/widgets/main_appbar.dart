import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:psws_storage/app/dimens/app_dim.dart';
import 'package:psws_storage/app/theme/app_colors_ext.dart';
import 'package:psws_storage/app/ui_kit/psws_dialogs.dart';
import 'package:psws_storage/app/ui_kit/snack_bar.dart';
import 'package:psws_storage/editor/presenter/main/bloc/main_bloc.dart';
import 'package:psws_storage/settings/settings_page.dart';

class MainAppBar extends StatelessWidget
    with PreferredSizeWidget, PswsSnackBar, PswsDialogs {
  const MainAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MainBloc>();
    final l10n = AppLocalizations.of(context);
    final folderName = l10n?.main_appbar_dialog_folder ?? '';
    final fileName = l10n?.main_appbar_dialog_note ?? '';
    final AppColorsExt? appColors = Theme.of(context).extension<AppColorsExt>();

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: appColors?.appBarColor,
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
              createFileDialog(context, title: fileName, isFolder: false,
                  value: (value) {
                bloc.addFile(value);
              });
            },
            icon: SvgPicture.asset(
              'assets/icons/ic_file.svg',
              color: appColors?.textColor,
            )),
        IconButton(
          onPressed: () {
            createFileDialog(context, title: folderName, value: (value) {
              bloc.addFolder(value);
            });
          },
          icon: SvgPicture.asset(
            'assets/icons/ic_folder.svg',
            color: appColors?.textColor,
          ),
        ),
        const Expanded(
          child: SizedBox(),
        ),
        IconButton(
          onPressed: () {
            showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) {
                  return const SettingsPage();
                });
          },
          icon: SvgPicture.asset(
            'assets/icons/ic_settings.svg',
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

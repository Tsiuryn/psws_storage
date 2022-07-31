import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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

    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(children: [
        IconButton(
            onPressed: () {
              createFileDialog(context, title: fileName, isFolder: false,
                  value: (value) {
                bloc.addFile(value);
              });
            },
            icon: const Icon(
              Icons.add,
            )),
        const SizedBox(
          width: 20,
        ),
        IconButton(
            onPressed: () {
              createFileDialog(context, title: folderName, value: (value) {
                bloc.addFolder(value);
              });
            },
            icon: const Icon(
              Icons.folder,
            )),
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
          icon: const Icon(
            Icons.menu,
          ),
          alignment: AlignmentDirectional.centerEnd,
        )
      ]),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

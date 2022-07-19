import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:psws_storage/app/app_bloc/app_bloc.dart';
import 'package:psws_storage/app/app_bloc/environment.dart';
import 'package:psws_storage/app/di/di.dart';
import 'package:psws_storage/app/ui_kit/psws_dialogs.dart';
import 'package:psws_storage/app/ui_kit/snack_bar.dart';
import 'package:psws_storage/editor/presenter/main/bloc/main_bloc.dart';
import 'package:psws_storage/editor/presenter/main/widgets/settings_bottom_sheet.dart';

class MainAppBar extends StatelessWidget
    with PreferredSizeWidget, PswsSnackBar, PswsDialogs {
  const MainAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MainBloc>();
    final l10n = AppLocalizations.of(context);
    final folderName = l10n?.main_appbar_dialog_folder ?? '';
    final fileName = l10n?.main_appbar_dialog_note ?? '';

    return BlocProvider(
      create: (context) => getIt.get<AppBloc>(),
      child: BlocBuilder<AppBloc, Environment>(builder: (context, state) {
        return AppBar(
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
                showBottomSheet(context, state: state);
              },
              icon: const Icon(
                Icons.menu,
              ),
              alignment: AlignmentDirectional.centerEnd,
            )
          ]),
        );
      }),
    );
  }

  void showBottomSheet(BuildContext context, {required Environment state}) {
    final l10n = AppLocalizations.of(context);
    final titleTheme = l10n?.main_appbar_bottom_theme ?? '';
    final titleLocale = l10n?.main_appbar_bottom_locale ?? '';

    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return SettingsBottomSheet(state: state);
        });
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

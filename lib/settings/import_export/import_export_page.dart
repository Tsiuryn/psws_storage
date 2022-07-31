import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:psws_storage/app/common/base_page.dart';
import 'package:psws_storage/app/ui_kit/psws_dialogs.dart';
import 'package:psws_storage/settings/import_export/bloc/import_export_bloc.dart';
import 'package:psws_storage/settings/import_export/export/export_form.dart';

class ImportExportPage
    extends StatelessBasePage<ImportExportBloc, ImportExportState>
    with PswsDialogs {
  const ImportExportPage({Key? key}) : super(key: key);

  @override
  ImportExportBloc createBloc(BuildContext context) {
    return ImportExportBloc()..add(ImportExportEvent.checkPermission());
  }

  @override
  void onListener(BuildContext context, state) {
    final bloc = context.read<ImportExportBloc>();
    if (state is ImportExportShowPermissionDialogState) {
      _showOkDialog(context, tapOk: () {
        bloc.add(ImportExportEvent.checkPermission());
      });
    }
    if (state is ImportExportShowSettingsState) {
      _showOkDialog(context, tapOk: () {
        openAppSettings();
        context.popRoute();
      });
    }
  }

  void _showOkDialog(BuildContext context, {required VoidCallback tapOk}) {
    createOkDialog(context,
        title: 'Check permission',
        message: 'We need write permission',
        tapOk: tapOk, tapNo: () {
      context.popRoute();
      context.popRoute();
    });
  }

  @override
  AppBar? buildAppBar(BuildContext context, state) {
    return AppBar(
      title: const Text('Import/Export Page'),
    );
  }

  @override
  Widget buildBody(BuildContext context, state) {
    return state is ImportExportLoadingState
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            children: [
              Expanded(child: ImportForm()),
              Divider(
                height: 2,
                indent: 16,
                endIndent: 16,
                thickness: 4,
              ),
              Expanded(
                  child: ExportForm(
                state: state,
              )),
            ],
          );
  }
}

class ImportForm extends StatelessWidget {
  const ImportForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.green,
        child: Column(
          children: [Text('Импортировать базу данных')],
        ),
      ),
    );
  }
}

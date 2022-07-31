import 'package:flutter/material.dart';
import 'package:psws_storage/app/dimens/app_dim.dart';
import 'package:psws_storage/app/ui_kit/snack_bar.dart';
import 'package:psws_storage/settings/import_export/bloc/import_export_bloc.dart';
import 'package:psws_storage/settings/import_export/export/widgets/passwords_form.dart';

class ExportForm extends StatefulWidget {
  final ImportExportState state;

  const ExportForm({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  State<ExportForm> createState() => _ExportFormState();
}

class _ExportFormState extends State<ExportForm> with PswsSnackBar {
  String psw = '';
  String repeatPsw = '';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(AppDim.sixteen),
        child: Center(
          child: Column(
            children: [
              const Text(
                'Выгрузить базу данных: ',
                style: TextStyle(
                    fontSize: AppDim.twenty, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: AppDim.sixteen,
              ),
              PasswordsForm(
                onPswChanged: (value) {
                  psw = value;
                },
                onRepeatPswChanged: (value) {
                  repeatPsw = value;
                },
              ),
              const SizedBox(
                height: AppDim.sixteen,
              ),
              Row(
                children: [
                  Expanded(
                      child: Text('Путь: ${widget.state.model.exportPath}')),
                  FloatingActionButton(
                    onPressed: () {
                      if (psw.isEmpty) {
                        showRequestSnackBar(context,
                            message: 'Пароль не может быть пустым');
                      } else if (psw != repeatPsw) {
                        showRequestSnackBar(context,
                            message: 'Пароль и повтор пароля не совпадают');
                      } else {
                        showRequestSnackBar(context,
                            message: 'Успех !!!', isSuccess: true);
                      }
                      // context.read<ImportExportBloc>().exportDB();
                    },
                    mini: true,
                    child: const Icon(Icons.import_export_sharp),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

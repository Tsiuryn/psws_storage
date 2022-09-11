import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:psws_storage/app/dimens/app_dim.dart';
import 'package:psws_storage/app/theme/app_theme.dart';
import 'package:psws_storage/app/ui_kit/psws_input.dart';
import 'package:psws_storage/app/ui_kit/snack_bar.dart';
import 'package:psws_storage/res/resources.dart';
import 'package:psws_storage/settings/import_export/bloc/import_export_bloc.dart';
import 'package:psws_storage/settings/import_export/widget/path_widget.dart';

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
  final _formKey = GlobalKey<FormState>();
  String? _fileName;
  String? _psw;
  String? _pswRepeat;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final appTheme = AppTheme(context);

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.disabled,
                child: Padding(
                  padding: const EdgeInsets.all(AppDim.sixteen),
                  child: Column(
                    children: [
                      PathWidget(
                        path: widget.state.pathToFileOrFolder,
                        onTap: () {},
                        btnTitle:
                            l10n.import_export_page__export_btn_choose_folder,
                        btnSuffix: SvgPicture.asset(
                          AppIcons.icExport,
                          color: appTheme.appColors?.textColor,
                        ),
                      ),
                      PswsInput(
                        placeholder:
                            l10n.import_export_page__input_file_placeholder,
                        onChanged: (value) {
                          _fileName = value;
                        },
                        hintText: l10n.import_export_page__input_file_hint,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Can not be empty';
                          }
                        },
                      ),
                      const SizedBox(
                        height: AppDim.sixteen,
                      ),
                      PswsInput(
                        placeholder:
                            l10n.import_export_page__input_password_placeholder,
                        onChanged: (value) {
                          _psw = value;
                        },
                        hintText: l10n.import_export_page__input_password_hint,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Can not be empty';
                          }
                        },
                      ),
                      const SizedBox(
                        height: AppDim.sixteen,
                      ),
                      PswsInput(
                        placeholder:
                            l10n.import_export_page__input_rpt_psw_placeholder,
                        onChanged: (value) {
                          _pswRepeat = value;
                        },
                        hintText: l10n.import_export_page__input_rpt_psw_hint,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Can not be empty';
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          OutlinedButton(
            onPressed: () {
              _formKey.currentState?.validate();
            },
            child: Text(
              'Check',
            ),
          ),
        ],
      ),
    );
  }
}

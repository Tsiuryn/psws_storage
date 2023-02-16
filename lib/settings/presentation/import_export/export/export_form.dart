import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:psws_storage/app/dimens/app_dim.dart';
import 'package:psws_storage/app/theme/app_theme.dart';
import 'package:psws_storage/app/ui_kit/psws_button.dart';
import 'package:psws_storage/app/ui_kit/psws_input.dart';
import 'package:psws_storage/app/ui_kit/psws_password_input.dart';
import 'package:psws_storage/app/ui_kit/snack_bar.dart';
import 'package:psws_storage/res/resources.dart';
import 'package:psws_storage/settings/domain/entity/export_config.dart';
import 'package:psws_storage/settings/presentation/import_export/bloc/import_export_bloc.dart';
import 'package:psws_storage/settings/presentation/import_export/widget/path_widget.dart';

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
  late String _fileName;
  late String _psw;

  @override
  void initState() {
    super.initState();
    _fileName = '';
    _psw = '';
    context.read<ImportExportBloc>().getPathDirectory();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final appTheme = AppTheme(context);
    _fileName = DateFormat('ddMMyyyy_HHmmss').format(DateTime.now());

    return widget.state.type == ImportExportStateType.loading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : GestureDetector(
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
                              /*onTap: () {
                                context
                                    .read<ImportExportBloc>()
                                    .getFolderPath();
                              },*/
                              btnTitle: l10n
                                  .import_export_page__export_btn_choose_folder,
                              btnSuffix: SvgPicture.asset(
                                AppIcons.icExport,
                                color: appTheme.appColors?.textColor,
                              ),
                            ),
                            PswsInput(
                              placeholder: l10n
                                  .import_export_page__input_file_placeholder,
                              onChanged: (value) {
                                _fileName = value;
                              },
                              initialValue: _fileName,
                              autofocus: false,
                              hintText:
                                  l10n.import_export_page__input_file_hint,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return l10n.input_error__empty;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: AppDim.sixteen,
                            ),
                            PswsPasswordInput(
                              placeholder: l10n
                                  .import_export_page__input_password_placeholder,
                              onChanged: (value) {
                                _psw = value;
                              },
                              hintText:
                                  l10n.import_export_page__input_password_hint,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return l10n.input_error__empty;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: AppDim.sixteen,
                            ),
                            PswsPasswordInput(
                              placeholder: l10n
                                  .import_export_page__input_rpt_psw_placeholder,
                              hintText:
                                  l10n.import_export_page__input_rpt_psw_hint,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return l10n.input_error__empty;
                                }
                                if (value != _psw) {
                                  return l10n.input_error__do_not_match_psw;
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: AppDim.sixteen),
                  child: PswsButton(
                    onPressed: () {
                      final path = widget.state.pathToFileOrFolder ?? '';
                      final bool inputValidate =
                          _formKey.currentState?.validate() ?? false;
                      if (path.isEmpty) {
                        showRequestSnackBar(
                          context,
                          message: l10n.export_form__empty_path,
                        );
                      }
                      if (inputValidate && path.isNotEmpty) {
                        context
                            .read<ImportExportBloc>()
                            .exportDatabase(ExportConfig(
                              fileName: _fileName,
                              password: _psw,
                              path: path,
                            ));
                      }
                    },
                    content: ButtonText(
                      l10n.export_form__confirm_btn_title,
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}

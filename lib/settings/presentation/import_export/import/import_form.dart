import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:psws_storage/app/dimens/app_dim.dart';
import 'package:psws_storage/app/theme/app_theme.dart';
import 'package:psws_storage/app/ui_kit/psws_button.dart';
import 'package:psws_storage/app/ui_kit/psws_password_input.dart';
import 'package:psws_storage/app/ui_kit/snack_bar.dart';
import 'package:psws_storage/res/resources.dart';
import 'package:psws_storage/settings/domain/entity/import_config.dart';
import 'package:psws_storage/settings/presentation/import_export/bloc/import_export_bloc.dart';
import 'package:psws_storage/settings/presentation/import_export/util/import_type_ext.dart';
import 'package:psws_storage/settings/presentation/import_export/widget/path_widget.dart';

class ImportForm extends StatefulWidget {
  final ImportExportState state;

  const ImportForm({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  State<ImportForm> createState() => _ImportFormState();
}

class _ImportFormState extends State<ImportForm> with PswsSnackBar {
  final _formKey = GlobalKey<FormState>();
  late String _psw;

  @override
  void initState() {
    super.initState();
    _psw = '';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final appTheme = AppTheme(context);

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
                              onTap: () {
                                context.read<ImportExportBloc>().getFilePath();
                              },
                              btnTitle: l10n.import_export_page__import_btn_choose_file,
                              btnSuffix: SvgPicture.asset(
                                AppIcons.icImport,
                                color: appTheme.appColors?.textColor,
                              ),
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
                            ...ImportType.values
                                .map((e) => RadioListTile(
                                      title: Text(
                                        e.getTitle(context),
                                        style:
                                            appTheme.appTextStyles?.titleMedium,
                                      ),
                                      value: e,
                                      groupValue: widget.state.importType,
                                      onChanged: (value) {
                                        context
                                            .read<ImportExportBloc>()
                                            .changeImportType(e);
                                      },
                                      activeColor: appTheme
                                          .appColors?.positiveActionColor,
                                    ))
                                .toList()
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
                      final importType = widget.state.importType;
                      final bool inputValidate =
                          _formKey.currentState?.validate() ?? false;
                      if (path.isEmpty) {
                        showRequestSnackBar(
                          context,
                          message: l10n.import_form__empty_path,
                        );
                      }
                      if (inputValidate && path.isNotEmpty) {
                        context.read<ImportExportBloc>().importDatabase(
                            ImportConfig(
                                password: _psw, path: path, type: importType));
                      }
                    },
                    content: ButtonText(
                      l10n.import_form__confirm_btn_title,
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}

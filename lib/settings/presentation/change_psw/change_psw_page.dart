import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:psws_storage/app/di/di.dart';
import 'package:psws_storage/app/dimens/app_dim.dart';
import 'package:psws_storage/app/theme/app_theme.dart';
import 'package:psws_storage/app/ui_kit/psws_button.dart';
import 'package:psws_storage/app/ui_kit/psws_password_input.dart';
import 'package:psws_storage/app/ui_kit/snack_bar.dart';
import 'package:psws_storage/editor/presenter/main/widgets/life_cycle_widget.dart';
import 'package:psws_storage/settings/presentation/change_psw/change_psw_bloc.dart';

@RoutePage()
class ChangePswPage extends StatefulWidget {
  const ChangePswPage({Key? key}) : super(key: key);

  @override
  State<ChangePswPage> createState() => _ChangePswPageState();
}

class _ChangePswPageState extends State<ChangePswPage> with PswsSnackBar {
  final _formKey = GlobalKey<FormState>();
  late String _oldPsw;
  late String _psw;

  @override
  void initState() {
    super.initState();
    _oldPsw = '';
    _psw = '';
  }

  @override
  Widget build(BuildContext context) {
    return LifeCycleWidget(
      routeData: context.routeData,
      child: BlocProvider<ChangePswBloc>(
        create: (context) => getIt.get<ChangePswBloc>(),
        child: BlocBuilder<ChangePswBloc, ChangePswState>(
          builder: _pageStateBuilder,
        ),
      ),
    );
  }

  Widget _pageStateBuilder(BuildContext context, ChangePswState state) {
    final l10n = AppLocalizations.of(context);
    final appTheme = AppTheme(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(
            l10n.password_change__title,
            style: appTheme.appTextStyles?.titleLarge,
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_rounded,
              color: appTheme.appColors?.textColor,
            ),
            onPressed: context.maybePop,
          ),
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: Divider(),
          ),
        ),
        body: GestureDetector(
          onTap: FocusScope.of(context).unfocus,
          child: Column(
            children: [
              Expanded(
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Padding(
                    padding: const EdgeInsets.all(AppDim.sixteen),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PswsPasswordInput(
                          placeholder: l10n.password_change__old_psw,
                          onChanged: (value) {
                            _oldPsw = value;
                          },
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
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
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(8),
                          ],
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
                          hintText: l10n.import_export_page__input_rpt_psw_hint,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
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
              Padding(
                padding: const EdgeInsets.only(bottom: AppDim.sixteen),
                child: PswsButton(
                  onPressed: () async {
                    final bool inputValidate =
                        _formKey.currentState?.validate() ?? false;
                    final bloc = context.read<ChangePswBloc>();

                    if (inputValidate && _psw != _oldPsw) {
                      final equalPin = await bloc.equalPin(_oldPsw);
                      if (equalPin) {
                        await bloc.writeNewPin(_psw);
                        context.maybePop();
                        showRequestSnackBar(
                          context,
                          message: l10n.password_change__message_success,
                          isSuccess: true,
                        );
                      } else {
                        showRequestSnackBar(
                          context,
                          message: l10n.password_change__message_error,
                        );
                      }
                    }
                  },
                  content: ButtonText(
                    l10n.password_change__btn_title,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:local_auth/local_auth.dart';
import 'package:psws_storage/app/common/base_page.dart';
import 'package:psws_storage/app/di/di.dart';
import 'package:psws_storage/app/dimens/app_dim.dart';
import 'package:psws_storage/app/router/app_router.gr.dart';
import 'package:psws_storage/app/ui_kit/snack_bar.dart';
import 'package:psws_storage/pin/presentation/widget/circle.dart';
import 'package:psws_storage/pin/presentation/widget/passcode_screen.dart';
import 'package:psws_storage/res/resources.dart';

import 'bloc/pin_bloc.dart';

class PinPage extends StatelessBasePage<PinBloc, PinState> with PswsSnackBar {
  final bool isFirstPage;

  const PinPage({
    Key? key,
    @QueryParam('isFirstPage') bool? isFirstPage,
  })  : isFirstPage = isFirstPage ?? true,
        super(key: key);

  @override
  PinBloc createBloc(BuildContext context) {
    return getIt.get<PinBloc>();
  }

  @override
  bool onBackButtonPressed(BuildContext context, PinState state) {
    onWillPop(context, state: state);

    return true;
  }

  void onWillPop(BuildContext context, {required PinState state}) {
    DateTime now = DateTime.now();
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final PinBloc bloc = context.read<PinBloc>();
    if (now.difference(state.currentBackPressTime) >
        const Duration(seconds: 2)) {
      bloc.changeCurrentBackPressTime(now);
      showRequestSnackBar(
        context,
        message: l10n.app_snack_exit,
      );
    } else {
      exit(0);
    }
  }

  @override
  void onListener(BuildContext context, PinState state) async {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    if (state.state == PinFlowState.success) {
      if (isFirstPage) {
        _nextPage(context);
      } else {
        context.router.pop();
      }
      showRequestSnackBar(context, message: l10n.pin_page__title_snack_psw_correct, isSuccess: true);
      return;
    }
    if (state.state == PinFlowState.unSuccessCreate || state.state == PinFlowState.unSuccessCheck) {
      showRequestSnackBar(context, message: l10n.pin_page__title_snack_psw_not_correct);
      return;
    }
    if (state.state == PinFlowState.fingerprint) {
      if (await _authenticateByBiometrics(context)) {
        context.read<PinBloc>().changeState(PinFlowState.success);
      }
    }
  }

  Future<bool> _authenticateByBiometrics(BuildContext context) async {
    try {
      final l10n = AppLocalizations.of(context);
      final LocalAuthentication auth = LocalAuthentication();
      final bool didAuthenticate = await auth.authenticate(
        localizedReason: l10n?.pin_page__biometrics_auth ?? '',
        options: const AuthenticationOptions(biometricOnly: true),
      );
      return didAuthenticate;
    } on PlatformException {
      return false;
    }
  }

  @override
  Widget buildBody(BuildContext context, PinState state) {
    String value = '';
    final bloc = context.read<PinBloc>();
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            flex: 3,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: PinCodeWidget(
                title: Text(
                  _getTitle(l10n: l10n, state: state.state).toUpperCase(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline6,
                ),
                passcodeLength: AppDim.eight.toInt(),
                confirmButton: SvgPicture.asset(
                  AppIcons.icCheck,
                  color: Theme.of(context).unselectedWidgetColor,
                  fit: BoxFit.scaleDown,
                ),
                circleUIConfig: CircleUIConfig(
                  circleSize: AppDim.twelve,
                  filledColor: Theme.of(context).colorScheme.secondary,
                  borderColor: Theme.of(context).primaryColorDark,
                ),
                passwordEnteredCallback: (pinCode) {
                  value = pinCode;
                },
                confirmCallback: () {
                  if (value.isEmpty) {
                    showRequestSnackBar(context, message: l10n.pin_page__title_snack_empty_psw);
                  } else {
                    bloc.writePin(value);
                  }
                },
                onTapBiometrics: state.showAuthBtn
                    ? () async {
                        if (await _authenticateByBiometrics(context)) {
                          context.read<PinBloc>().changeState(PinFlowState.success);
                        }
                      }
                    : null,
              ),
            ),
          ),
          const SizedBox(
            height: AppDim.sixteen,
          )
        ],
      ),
    );
  }

  String _getTitle(
      {required AppLocalizations l10n, required PinFlowState state}) {
    switch (state) {
      case PinFlowState.firstCreate:
        return l10n.pin_page__title_first_create;

      case PinFlowState.secondCreate:
        return l10n.pin_page__title_second_create;

      case PinFlowState.fingerprint:
      case PinFlowState.checkPassword:
        return l10n.pin_page__title_check;

      case PinFlowState.unSuccessCreate:
      case PinFlowState.unSuccessCheck:
        return l10n.pin_page__title_unsuccess;
      default:
        return '';
    }
  }

  void _nextPage(BuildContext context) {
    context.router.replace(const MainRoute());
  }
}

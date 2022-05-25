import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:psws_storage/app/common/base_page.dart';
import 'package:psws_storage/app/router/app_router.dart';
import 'package:psws_storage/presenter/pin/domain/entity/credentials.dart';
import 'package:psws_storage/presenter/pin/presentation/pages/create_pin/bloc/create_pin_bloc.dart';
import 'package:psws_storage/presenter/pin/presentation/pages/create_pin/bloc/create_pin_bloc_state.dart';
import 'package:psws_storage/presenter/pin/presentation/widget/passcode_screen.dart';

import 'bloc/create_pin_bloc_event.dart';

class CreatePinPage
    extends StatelessBasePage<CreatePinBloc, CreatePinBlocState> {
  final String? username;
  final String? password;
  final passCodeWidgetKey = GlobalKey<PinCodeWidgetState>();

  CreatePinPage({
    Key? key,
    @QueryParam('username') this.username,
    @QueryParam('password') this.password,
  }) : super(key: key);

  @override
  void listener(BuildContext context, CreatePinBlocState state) {
      // TODO: 25.05.22
  }

  @override
  AppBar? buildAppBar(BuildContext context, CreatePinBlocState state) {
    return AppBar();
  }

  @override
  Widget buildBody(BuildContext context, CreatePinBlocState state) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                PinCodeWidget(
                  key: passCodeWidgetKey,
                  passcodeLength: 4,
                  passwordEnteredCallback: (pinCode) =>
                      _passcodeEnteredCallback(context, pinCode),
                  title: state is ErrorPinCodeState
                      ? Text(
                          'invalid code',
                          style: theme.textTheme.bodyText1?.copyWith(
                            color: theme.colorScheme.onError,
                          ),
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
        TextButton(
          key: const Key('skipPasscodeButton'),
          onPressed: () {
            context.router.push(const MainRoute());
          },
          child: const Text(
            'Skip button',
          ),
        ),
      ],
    );
  }

  void _passcodeEnteredCallback(BuildContext context, String pinCode) {
    if (kDebugMode) {
      print('PASSCODE: $pinCode');
    }
    BlocProvider.of<CreatePinBloc>(context).add(
      CreatePinBlocEvent.createPinCode(
        userCredentials: UserCredentials(
          username: username!,
          password: password!,
        ),
        pinCode: pinCode,
      ),
    );
  }

  @override
  CreatePinBloc createBloc(BuildContext context) {
    return CreatePinBloc();
  }
}

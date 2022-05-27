import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:psws_storage/app/common/base_page.dart';
import 'package:psws_storage/app/router/app_router.dart';
import 'package:psws_storage/presenter/pin/presentation/pages/create_pin/bloc/create_pin_bloc.dart';
import 'package:psws_storage/presenter/pin/presentation/widget/passcode_screen.dart';

class CreatePinPage extends StatelessBasePage<CreatePinBloc, PinState> {
  final String? username;
  final String? password;
  final passCodeWidgetKey = GlobalKey<PinCodeWidgetState>();

  CreatePinPage({
    Key? key,
    @QueryParam('username') this.username,
    @QueryParam('password') this.password,
  }) : super(key: key);

  @override
  void listener(BuildContext context, PinState state) {
    // TODO: 25.05.22
  }

  @override
  AppBar? buildAppBar(BuildContext context, PinState state) {
    return AppBar();
  }

  @override
  Widget buildBody(BuildContext context, PinState state) {
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
                  title: Text(
                          'invalid code',
                          style: theme.textTheme.bodyText1?.copyWith(
                            color: theme.colorScheme.onError,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
        TextButton(
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
    context.read<CreatePinBloc>();
  }

  @override
  CreatePinBloc createBloc(BuildContext context) {
    return CreatePinBloc();
  }
}

class HelloWidget extends StatelessWidget {
  const HelloWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

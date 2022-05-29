import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:psws_storage/app/common/base_page.dart';
import 'package:psws_storage/app/di/di.dart';
import 'package:psws_storage/app/router/app_router.dart';
import 'package:psws_storage/presenter/pin/presentation/bloc/pin_bloc.dart';
import 'package:psws_storage/presenter/pin/presentation/widget/circle.dart';
import 'package:psws_storage/presenter/pin/presentation/widget/passcode_screen.dart';

class PinPage extends StatelessBasePage<PinBloc, PinState> {
  final passCodeWidgetKey = GlobalKey<PinCodeWidgetState>();

  PinPage({
    Key? key,
  }) : super(key: key);

  @override
  AppBar? buildAppBar(BuildContext context, PinState state) {
    return AppBar();
  }

  @override
  Widget buildBody(BuildContext context, PinState state) {
    final theme = Theme.of(context);
    String value = '';

    return Center(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: PinCodeWidget(
                key: passCodeWidgetKey,
                passcodeLength: 8,
                circleUIConfig: const CircleUIConfig(circleSize: 24),
                passwordEnteredCallback: (pinCode) {
                  value = pinCode;
                },
                title: Text(
                  'invalid code',
                  style: theme.textTheme.bodyText1?.copyWith(
                    color: theme.colorScheme.onError,
                  ),
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              await context.read<PinBloc>().writePin(value);
              context.router.push(const MainRoute());
            },
            child: const Text(
              'Skip button',
            ),
          ),
        ],
      ),
    );
  }

  @override
  PinBloc createBloc(BuildContext context) {
    return getIt.get<PinBloc>();
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:psws_storage/app/common/base_page.dart';
import 'package:psws_storage/app/di/di.dart';
import 'package:psws_storage/app/router/app_router.dart';
import 'package:psws_storage/app/ui_kit/snack_bar.dart';
import 'package:psws_storage/presenter/pin/presentation/bloc/pin_bloc.dart';
import 'package:psws_storage/presenter/pin/presentation/widget/circle.dart';
import 'package:psws_storage/presenter/pin/presentation/widget/passcode_screen.dart';

class PinPage extends StatelessBasePage<PinBloc, PinState> with PswsSnackBar {
  const PinPage({
    Key? key,
  }) : super(key: key);

  @override
  AppBar? buildAppBar(BuildContext context, PinState state) {
    return AppBar();
  }

  @override
  void onListenerState(BuildContext context, PinState state) {
    super.onListenerState(context, state);
  }

  @override
  Widget buildBody(BuildContext context, PinState state) {
    String value = '';
    String  title = 'Add new Code';
    final bloc = context.read<PinBloc>();

    return Center(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: PinCodeWidget(
                passcodeLength: 8,
                cancelButton: const Icon(Icons.check),
                circleUIConfig: const CircleUIConfig(circleSize: 16),
                passwordEnteredCallback: (pinCode) {
                  value = pinCode;
                },
                confirmCallback: () {
                  if (value.isEmpty) {
                    _showEmptySnackBar(context);
                  } else {
                    bloc.writePin(value);
                  }
                },
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
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

  void _showEmptySnackBar(BuildContext context) {
    showRequestSnackBar(context, message: 'Can\'t be empty', isSuccess: false);
  }

  @override
  PinBloc createBloc(BuildContext context) {
    return getIt.get<PinBloc>();
  }
}

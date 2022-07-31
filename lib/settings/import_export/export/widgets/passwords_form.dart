import 'package:flutter/material.dart';
import 'package:psws_storage/app/dimens/app_dim.dart';
import 'package:psws_storage/app/ui_kit/psws_password_input.dart';

class PasswordsForm extends StatelessWidget {
  final ValueChanged<String>? onPswChanged;
  final ValueChanged<String>? onRepeatPswChanged;

  const PasswordsForm({Key? key, this.onPswChanged, this.onRepeatPswChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PswsPasswordInput(
          placeHolder: 'Password',
          onChanged: onPswChanged,
        ),
        SizedBox(
          height: AppDim.sixteen,
        ),
        PswsPasswordInput(
          placeHolder: 'Repeat password',
          onChanged: onRepeatPswChanged,
        ),
      ],
    );
  }
}

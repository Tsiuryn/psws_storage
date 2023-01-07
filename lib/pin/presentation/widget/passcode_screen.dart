library passcode_screen;

import 'package:flutter/material.dart';
import 'package:psws_storage/app/dimens/app_dim.dart';

import 'circle.dart';
import 'keyboard.dart';
import 'shake_curve.dart';

typedef PasswordEnteredCallback = void Function(String text);
typedef ConfirmCallback = void Function();

class PinCodeWidget extends StatefulWidget {
  final int passcodeLength;
  final PasswordEnteredCallback passwordEnteredCallback;
  final Widget? confirmButton;
  final ConfirmCallback? confirmCallback;
  final Widget? title;
  final CircleUIConfig circleUIConfig;
  final KeyboardUIConfig keyboardUIConfig;
  final VoidCallback? onTapBiometrics;

  const PinCodeWidget({
    Key? key,
    required this.passcodeLength,
    required this.passwordEnteredCallback,
    this.confirmButton,
    CircleUIConfig? circleUIConfig,
    KeyboardUIConfig? keyboardUIConfig,
    this.confirmCallback,
    this.onTapBiometrics,
    this.title,
  })
      : circleUIConfig = circleUIConfig ?? const CircleUIConfig(),
        keyboardUIConfig = keyboardUIConfig ?? const KeyboardUIConfig(),
        assert(confirmButton != null && confirmCallback != null || confirmButton == null && confirmCallback == null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => PinCodeWidgetState();
}

class PinCodeWidgetState extends State<PinCodeWidget>
    with SingleTickerProviderStateMixin {
  String enteredPasscode = '';
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    final Animation curve =
        CurvedAnimation(parent: controller, curve: ShakeCurve());
    animation = Tween(begin: 0.0, end: 10.0).animate(curve as Animation<double>)
      ..addListener(() {
        // ignore: no-empty-block
        setState(() {
          // the animation object’s value is the changed state
        });
      });
  }

  void _resetPasscode() {
    setState(() {
      enteredPasscode = '';
      controller.value = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    List<Widget> circles = _buildCircles(widget.passcodeLength);
    const double spacing = 8;
    final width = (widget.circleUIConfig.circleSize + spacing) * 8;

    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Align(
            alignment: AlignmentDirectional.bottomCenter,
            child: widget.title ??
                Text(
                  'PIN',
                  style: theme.textTheme.bodyText1
                      ?.copyWith(color: theme.colorScheme.onPrimary),
                ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: AppDim.twentyFour),
            child: SizedBox(
              width: width,
              child: Center(
                child: Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  alignment: WrapAlignment.center,
                  children: [...circles],
                ),
              ),
            ),
          ),
        ),
        _buildKeyboard(),
        Visibility(
            visible: widget.onTapBiometrics != null,
            child: Center(
              child: IconButton(
                icon: const Icon(
                  Icons.fingerprint,
                  size: AppDim.thirtyTwo,
                ),
                onPressed: () async {
                  widget.onTapBiometrics?.call();
                },
              ),
            )),
      ],
    );
  }

  Widget _buildKeyboard() => Keyboard(
    onKeyboardTap: _onKeyboardButtonPressed,
        keyboardUIConfig: widget.keyboardUIConfig,
        bottomLeftKey: _buildConfirmKey(),
        bottomRightKey: _buildBackspaceKey(context),
      );

  List<Widget> _buildCircles(int length) {
    var list = <Widget>[];
    var config = widget.circleUIConfig;
    var extraSize = animation.value;
    for (var i = 0; i < length; i++) {
      list.add(
        Circle(
          filled: i < enteredPasscode.length,
          circleUIConfig: config,
          extraSize: extraSize,
        ),
      );
    }

    return list;
  }

  KeyboardKey? _buildConfirmKey() {
    final Widget? confirm = widget.confirmButton;
    return confirm != null
        ? KeyboardKey(
            onTap: () {
              widget.confirmCallback?.call();
              _resetPasscode();
            },
            child: confirm,
          )
        : null;
  }

  KeyboardKey _buildBackspaceKey(BuildContext context) {
    return KeyboardKey(
      onTap: _onBackspaceButtonPressed,
      child: Icon(Icons.backspace_outlined,
          color: Theme.of(context).unselectedWidgetColor),
    );
  }

  void dropPassCode() {
    setState(() {
      enteredPasscode = '';
    });
  }

  void _onBackspaceButtonPressed() {
    if (enteredPasscode.isNotEmpty) {
      setState(() {
        enteredPasscode =
            enteredPasscode.substring(0, enteredPasscode.length - 1);
      });
      widget.passwordEnteredCallback(enteredPasscode);
    }
  }

  void _onKeyboardButtonPressed(String text) {
    if (enteredPasscode.length == widget.passcodeLength) {
      return;
    }
    setState(() {
      enteredPasscode += text;
    });
    widget.passwordEnteredCallback(enteredPasscode);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

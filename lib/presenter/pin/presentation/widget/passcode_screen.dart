library passcode_screen;

import 'package:flutter/material.dart';

import 'circle.dart';
import 'keyboard.dart';
import 'shake_curve.dart';

typedef PasswordEnteredCallback = void Function(String text);
typedef CancelCallback = void Function();

class PinCodeWidget extends StatefulWidget {
  final int passcodeLength;
  final PasswordEnteredCallback passwordEnteredCallback;
  final Widget? cancelButton;
  final CancelCallback? cancelCallback;
  final Widget? title;
  final CircleUIConfig circleUIConfig;
  final KeyboardUIConfig keyboardUIConfig;

  const PinCodeWidget({
    Key? key,
    required this.passcodeLength,
    required this.passwordEnteredCallback,
    this.cancelButton,
    CircleUIConfig? circleUIConfig,
    KeyboardUIConfig? keyboardUIConfig,
    this.cancelCallback,
    this.title,
  })  : circleUIConfig = circleUIConfig ?? const CircleUIConfig(),
        keyboardUIConfig = keyboardUIConfig ?? const KeyboardUIConfig(),
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
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _resetPasscode();
        }
      })
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

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: widget.title ??
              Text(
                'Hello',
                style: theme.textTheme.bodyText1
                    ?.copyWith(color: theme.colorScheme.onPrimary),
              ),
        ),
        SizedBox(
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildCircles(),
          ),
        ),
        _buildKeyboard(),
      ],
    );
  }

  Widget _buildKeyboard() => Keyboard(
        onKeyboardTap: _onKeyboardButtonPressed,
        keyboardUIConfig: widget.keyboardUIConfig,
        bottomLeftKey: _buildCancelKey(),
        bottomRightKey: _buildBackspaceKey(),
      );

  List<Widget> _buildCircles() {
    var list = <Widget>[];
    var config = widget.circleUIConfig;
    var extraSize = animation.value;
    for (var i = 0; i < widget.passcodeLength; i++) {
      list.add(
        Container(
          margin: const EdgeInsets.all(8),
          child: Circle(
            filled: i < enteredPasscode.length,
            circleUIConfig: config,
            extraSize: extraSize,
          ),
        ),
      );
    }

    return list;
  }

  KeyboardKey? _buildCancelKey() {
    return widget.cancelButton != null && widget.cancelCallback != null
        ? KeyboardKey(
            onTap: widget.cancelCallback!,
            child: widget.cancelButton!,
          )
        : null;
  }

  KeyboardKey _buildBackspaceKey() {
    return KeyboardKey(
      onTap: _onBackspaceButtonPressed,
      child: const Icon(Icons.backspace_outlined, color: Colors.grey),
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
    }
  }

  void _onKeyboardButtonPressed(String text) {
    if (enteredPasscode.length == widget.passcodeLength) {
      return;
    }
    setState(() {
      enteredPasscode += text;
    });
    if (enteredPasscode.length == widget.passcodeLength) {
      widget.passwordEnteredCallback(enteredPasscode);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

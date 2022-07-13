import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';

///RU: Класс [PswsBackButtonListener] предназначен для переопределения кнопки назад и получения обратного вызова при нажатии кнопки;
///
///ENG: Class [PswsBackButtonListener] is for redefining the back button and getting a callback when the button is clicked;
///
class PswsBackButtonListener extends StatefulWidget {
  final BuildContext context;

  ///RU: метод [backPressed] является функцией обратного вызова, срабатывает, когда нажата системная кнопка назад.
  /// Необходимо вернуть bool: если true, тогда поведение по умолчанию кнопки назад не сработает!!!;
  ///
  ///EN: method [backPressed] is a callback function, fires when the system back button is pressed.
  /// Need to return bool: if true, then the default behavior of the back button won't work!!!;
  ///
  final bool Function() backPressed;
  final Widget child;

  const PswsBackButtonListener(
    this.context, {
    Key? key,
    required this.backPressed,
    required this.child,
  }) : super(key: key);

  @override
  _PswsBackButtonListenerState createState() => _PswsBackButtonListenerState();
}

class _PswsBackButtonListenerState extends State<PswsBackButtonListener> {
  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor, context: widget.context);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    if (info.ifRouteChanged(context)) {
      return false;
    }

    return widget.backPressed();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

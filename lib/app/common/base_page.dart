import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:psws_storage/app/ui_kit/psws_back_button_listener.dart';

abstract class StatelessBasePage<B extends BlocBase<S>, S>
    extends StatelessWidget {
  const StatelessBasePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<B>(
      create: createBloc,
      child: BlocConsumer<B, S>(
        listenWhen: listenWhen,
        listener: onListener,
        buildWhen: buildWhen,
        builder: (context, state) {
          return PswsBackButtonListener(
            context: context,
            backPressed: () {
              return onBackButtonPressed(context, state);
            },
            child: SafeArea(
              child: Scaffold(
                appBar: buildAppBar.call(context, state),
                body: buildBody.call(context, state),
              ),
            ),
          );
        },
      ),
    );
  }

  B createBloc(BuildContext context);

  bool listenWhen(S previousState, S state) {
    return true;
  }

  void onListener(BuildContext context, S state) {}

  bool buildWhen(S previousState, S state) {
    return true;
  }

  bool onBackButtonPressed(BuildContext context, S state) {
    return false;
  }

  ///RU: метод [buildAppBar] возвращает абстрактный класс [PreferredSizeWidget],
  ///необходимый для кастомизации AppBar;
  ///```dart
  /// class DomesticAppBar extends StatelessWidget with PreferredSizeWidget{
  ///     @override
  ///   Widget build(BuildContext context) {}
  ///
  ///   @override
  ///   Size get preferredSize => const Size.fromHeight(60.0);
  /// }
  ///```
  ///
  ///EN: method [buildAppBar] returns abstract class [PreferredSizeWidget],
  ///required for customization AppBar;
  ///
  PreferredSizeWidget? buildAppBar(BuildContext context, S state) => null;

  Widget buildBody(BuildContext context, S state);
}

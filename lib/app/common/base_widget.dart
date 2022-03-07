import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class StatelessBaseWidget<B extends BlocBase<S>, S>
    extends StatelessWidget {
  const StatelessBaseWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<B>(
      create: createBloc,
      child: BlocConsumer<B, S>(
        listenWhen: listenWhen,
        listener: onListenerState,
        buildWhen: buildWhen,
        builder: (context, state) {
          return buildBody.call(context, state);
        },
      ),
    );
  }

  bool listenWhen(S previousState, S state) {
    return true;
  }

  B createBloc(BuildContext context);

  void onListenerState(BuildContext context, S state) {}

  bool buildWhen(previousState, state) {
    return true;
  }

  AppBar? buildAppBar(BuildContext context, S state) => null;

  Widget buildBody(BuildContext context, S state);
}

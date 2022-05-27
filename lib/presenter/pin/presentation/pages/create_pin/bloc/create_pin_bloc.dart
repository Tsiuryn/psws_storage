import 'package:flutter_bloc/flutter_bloc.dart';

class CreatePinBloc extends Cubit<PinState> {
  CreatePinBloc() : super(PinState());
}

class PinState {
  // final int? firstPin;
  // final int? secondPin;
  // final State? state;
}

enum State { first, second }

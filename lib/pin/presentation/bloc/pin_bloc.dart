import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecase/read_registration_pin_usecase.dart';
import '../../domain/usecase/write_registration_pin_usecase.dart';

class PinBloc extends Cubit<PinState> {
  final ReadRegistrationPinUseCase readRegistrationPin;
  final WriteRegistrationPinUseCase writeRegistrationPin;

  PinBloc(
      {required this.readRegistrationPin, required this.writeRegistrationPin})
      : super(PinState.initial()) {
    _initialBloc();
  }

  void _initialBloc() async {
    String? securePin = await readRegistrationPin();

    emit(state.copyWith(
        state: securePin == null
            ? PinFlowState.firstCreate
            : PinFlowState.checkPassword));
  }

  Future<void> writePin(String value) async {
    switch (state.state) {
      case PinFlowState.firstCreate:
      case PinFlowState.unSuccessCreate:
        {
          return emit(state.copyWith(
              firstPin: state.hashKey(value),
              state: PinFlowState.secondCreate));
        }
      case PinFlowState.secondCreate:
        {
          if (state.firstPin == state.hashKey(value)) {
            await writeRegistrationPin(state.hashKey(value));

            return emit(state.copyWith(state: PinFlowState.success));
          } else {
            return emit(state.clear(
              state: PinFlowState.unSuccessCreate,
            ));
          }
        }
      case PinFlowState.checkPassword:
      case PinFlowState.unSuccessCheck:
        {
          final String psw = await readRegistrationPin() ?? '';
          if (state.hashKey(value) == psw) {
            return emit(state.copyWith(state: PinFlowState.success));
          } else {
            return emit(state.copyWith(state: PinFlowState.unSuccessCheck));
          }
        }
      case PinFlowState.success:
        {
          return emit(state.copyWith(state: PinFlowState.success));
        }
    }
  }

  Future<void> changeCurrentBackPressTime(DateTime currentBackPressTime) async {
    return emit(state.copyWith(currentBackPressTime: currentBackPressTime));
  }
}

class PinState {
  final String? firstPin;
  final PinFlowState state;
  final DateTime currentBackPressTime;

  PinState(
      {this.firstPin,
      this.state = PinFlowState.firstCreate,
      DateTime? currentBackPressTime})
      : currentBackPressTime = currentBackPressTime ?? DateTime(1980);

  factory PinState.initial() = PinState;

  PinState copyWith({
    String? firstPin,
    PinFlowState? state,
    DateTime? currentBackPressTime,
  }) =>
      PinState(
        firstPin: firstPin ?? this.firstPin,
        state: state ?? this.state,
        currentBackPressTime: currentBackPressTime ?? this.currentBackPressTime,
      );

  PinState clear({
    required PinFlowState state,
  }) =>
      PinState(
        firstPin: null,
        state: state,
      );

  String hashKey(String value) {
    var passwordHash = sha1.convert(utf8.encode(value));
    return base64.encode(passwordHash.bytes);
  }
}

enum PinFlowState {
  firstCreate,
  secondCreate,
  checkPassword,
  success,
  unSuccessCreate,
  unSuccessCheck,
}

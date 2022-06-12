import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:psws_storage/presenter/pin/domain/usecase/read_registration_pin_usecase.dart';
import 'package:psws_storage/presenter/pin/domain/usecase/write_registration_pin_usecase.dart';

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
        state: securePin == null ? State.firstCreate : State.checkPassword));
  }

  Future<void> writePin(String value) async {
    switch (state.state) {
      case State.firstCreate:
      case State.unSuccessCreate:
        {
          return emit(
              state.copyWith(firstPin: value, state: State.secondCreate));
        }
      case State.secondCreate:
        {
          if (state.firstPin == value) {
            await writeRegistrationPin(value);

            return emit(state.copyWith(state: State.success));
          } else {
            return emit(state.clear(
              state: State.unSuccessCreate,
            ));
          }
        }
      case State.checkPassword:
      case State.unSuccessCheck:
        {
          if (value == await readRegistrationPin()) {
           return emit(state.copyWith(state: State.success));
          } else {
           return  emit(state.copyWith(state: State.unSuccessCheck));
          }
        }
      case State.unKnown:
      case State.success:
        {
          return emit(state.copyWith(state: State.unKnown));
        }
    }
  }
}

class PinState {
  final String? firstPin;
  final State state;

  PinState({this.firstPin, this.state = State.unKnown});

  factory PinState.initial() => PinState();

  PinState copyWith({
    String? firstPin,
    State? state,
  }) =>
      PinState(
        firstPin: firstPin ?? this.firstPin,
        state: state ?? this.state,
      );

  PinState clear({
    required State state,
  }) =>
      PinState(
        firstPin: null,
        state: state,
      );
}

enum State {
  firstCreate,
  secondCreate,
  checkPassword,
  success,
  unSuccessCreate,
  unSuccessCheck,
  unKnown,
}

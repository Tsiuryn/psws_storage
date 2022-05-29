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
    print(securePin);
  }

  Future<void> writePin(String value) async {
    await writeRegistrationPin(value);
    final value1 = await readRegistrationPin();
    print(value1);
  }
}

class PinState {
  // final int? firstPin;
  // final int? secondPin;
  // final State? state;

  PinState();

  PinState.initial();
}

enum State { first, second }

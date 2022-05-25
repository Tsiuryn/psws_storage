import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:psws_storage/presenter/pin/presentation/pages/create_pin/bloc/create_pin_bloc_event.dart';
import 'package:psws_storage/presenter/pin/presentation/pages/create_pin/bloc/create_pin_bloc_state.dart';

class CreatePinBloc extends Bloc<CreatePinBlocEvent, CreatePinBlocState> {

  CreatePinBloc() : super(const CreatePinBlocState.initial()) {
    on<CreatePinCode>(_onCreatePinCode);
  }

  void _onCreatePinCode(CreatePinCode event, emit) async {
    if (state is InitState) {
      emit(CreatePinBlocState.setFirstPinCode(event.pinCode));

      return;
    }

    if (state is! EnteredPinCodeState) {
      return;
    }

    final pinCode = (state as EnteredPinCodeState).pinCode;
    if (pinCode != event.pinCode) {
      emit(
        CreatePinBlocState.setFirstPinCode(
          pinCode,
        ),
      );

      emit(
        CreatePinBlocState.invalidPinCode(
          pinCode,
        ),
      );

      return;
    }

  }
}

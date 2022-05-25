abstract class CreatePinBlocState {
  const CreatePinBlocState();

  const factory CreatePinBlocState.initial() = InitState;

  const factory CreatePinBlocState.setFirstPinCode(String pinCode) =
      SetFirstPinCodeState;

  const factory CreatePinBlocState.createdPinCode() =
      CreatedPinCodeState;

  const factory CreatePinBlocState.invalidPinCode(String pinCode) =
      ErrorPinCodeState;

  const factory CreatePinBlocState.successCreateBiometry() =
      SuccessCreateBiometryState;
}

class InitState extends CreatePinBlocState {
  const InitState() : super();

}

class EnteredPinCodeState extends CreatePinBlocState {
  final String pinCode;

  const EnteredPinCodeState(this.pinCode);

}

class SetFirstPinCodeState extends EnteredPinCodeState {
  const SetFirstPinCodeState(String pinCode) : super(pinCode);

}

class ErrorPinCodeState extends EnteredPinCodeState {
  const ErrorPinCodeState(
    String pinCode,
  ) : super(pinCode);

}

class CreatedPinCodeState extends CreatePinBlocState {

  const CreatedPinCodeState() : super();
}

class ErrorCreateBiometryState extends CreatePinBlocState {
  const ErrorCreateBiometryState();

}

class SuccessCreateBiometryState extends CreatePinBlocState {
  const SuccessCreateBiometryState();

}

import 'package:psws_storage/presenter/pin/domain/entity/credentials.dart';

abstract class CreatePinBlocEvent {
  const CreatePinBlocEvent();

  const factory CreatePinBlocEvent.createPinCode({
    required UserCredentials userCredentials,
    required String pinCode,
  }) = CreatePinCode;

  const factory CreatePinBlocEvent.saveCredentialsByBiometry({
    required String accessTitle,
    required String saveTitle,
    required String cancelText,
  }) = SaveCredentialsByBiometryEvent;
}

class CreatePinCode extends CreatePinBlocEvent {
  final UserCredentials userCredentials;
  final String pinCode;

  const CreatePinCode({
    required this.userCredentials,
    required this.pinCode,
  });

}

class SaveCredentialsByBiometryEvent extends CreatePinBlocEvent {
  final String accessTitle;
  final String saveTitle;
  final String cancelText;

  const SaveCredentialsByBiometryEvent({
    required this.accessTitle,
    required this.saveTitle,
    required this.cancelText,
  });
}

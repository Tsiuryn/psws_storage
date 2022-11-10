import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:crypto/crypto.dart';
import 'package:psws_storage/pin/domain/usecase/read_registration_pin_usecase.dart';
import 'package:psws_storage/pin/domain/usecase/write_registration_pin_usecase.dart';

class ChangePswBloc extends Cubit<ChangePswState> {
  final ReadRegistrationPinUseCase readRegistrationPin;
  final WriteRegistrationPinUseCase writeRegistrationPin;

  ChangePswBloc({
    required this.readRegistrationPin,
    required this.writeRegistrationPin,
  }) : super(ChangePswState.empty());

  Future<bool> equalPin(String oldPin) async {
    final oldPinHash = await readRegistrationPin();

    return oldPinHash == _hashKey(oldPin);
  }

  Future<void> writeNewPin(String newPin) async {
    final hash = _hashKey(newPin);
    final df = hash;
    await writeRegistrationPin(hash);
  }

  String _hashKey(String value) {
    var passwordHash = sha1.convert(utf8.encode(value));
    return base64.encode(passwordHash.bytes);
  }
}

class ChangePswState {
  ChangePswState();

  ChangePswState.empty();
}

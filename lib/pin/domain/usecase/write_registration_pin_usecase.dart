import 'package:psws_storage/pin/domain/pin_repo.dart';

class WriteRegistrationPinUseCase {
  final PinRepo _repo;

  const WriteRegistrationPinUseCase(PinRepo repo) : _repo = repo;

  Future<void> call(String value) => _repo.writePinStorage(value);
}

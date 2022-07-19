import 'package:psws_storage/pin/domain/pin_repo.dart';

class ReadRegistrationPinUseCase {
  final PinRepo _repo;

  const ReadRegistrationPinUseCase(PinRepo repo) : _repo = repo;

  Future<String?> call() => _repo.readPinStorage();
}

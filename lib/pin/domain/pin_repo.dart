abstract class PinRepo {
  Future<void> writePinStorage(String value);

  Future<String?> readPinStorage();

  Future<void> deletePinStorage();
}

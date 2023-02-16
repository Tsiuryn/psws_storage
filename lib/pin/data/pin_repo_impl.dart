import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:psws_storage/pin/domain/pin_repo.dart';

class PinRepoImpl implements PinRepo {
  final FlutterSecureStorage secureStorage;
  final AndroidOptions androidOptions;

  const PinRepoImpl({
    required this.secureStorage,
    required this.androidOptions,
  });

  static const _pinKey = 'pinKey_App';

  @override
  Future<void> writePinStorage(String value) async => await secureStorage.write(
      key: _pinKey, value: value, aOptions: androidOptions);

  @override
  Future<String?> readPinStorage() async =>
      await secureStorage.read(key: _pinKey, aOptions: androidOptions);

  @override
  Future<void> deletePinStorage() async =>
      await secureStorage.delete(key: _pinKey, aOptions: androidOptions);
}

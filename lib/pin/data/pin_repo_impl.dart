import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:psws_storage/pin/domain/pin_repo.dart';

class PinRepoImpl implements PinRepo {
  final FlutterSecureStorage _secureStorage;

  const PinRepoImpl(FlutterSecureStorage secureStorage)
      : _secureStorage = secureStorage;

  AndroidOptions get _androidOptions =>
      const AndroidOptions(encryptedSharedPreferences: true);
  static const _pinKey = 'pinKey_App';

  @override
  Future<void> writePinStorage(String value) async => await _secureStorage
      .write(key: _pinKey, value: value, aOptions: _androidOptions);

  @override
  Future<String?> readPinStorage() async =>
      await _secureStorage.read(key: _pinKey, aOptions: _androidOptions);

  @override
  Future<void> deletePinStorage() async =>
      await _secureStorage.delete(key: _pinKey, aOptions: _androidOptions);
}

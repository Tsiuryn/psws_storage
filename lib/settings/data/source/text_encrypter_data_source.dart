import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';

class TextEncrypterDataSource {
  String encrypt({
    required String psw,
    required String plainText,
  }) {
    final iv = IV.fromLength(16); // max: 16

    return Encrypter(AES(_getKey(psw))).encrypt(plainText, iv: iv).base64;
  }

  String decrypt({
    required String psw,
    required String encryptedText,
  }) {
    final iv = IV.fromLength(16); // max: 16

    return Encrypter(AES(_getKey(psw)))
        .decrypt(Encrypted.fromBase64(encryptedText), iv: iv);
  }

  Key _getKey(String psw) {
    List<int> bytes = utf8.encode(psw);
    Digest hash = md5.convert(bytes);

    return Key.fromUtf8(hash.toString());
  }
}

import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:convert';
import 'dart:typed_data';

class EncryptionHelper {

  final String key = "8080808080808080";
  final String iv = "8080808080808080";

  String encryptData(String plainText) {
    final aesKey = encrypt.Key(Uint8List.fromList(utf8.encode(key)));
    final aesIv = encrypt.IV(Uint8List.fromList(utf8.encode(iv)));
    final encrypter = encrypt.Encrypter(encrypt.AES(aesKey, mode: encrypt.AESMode.cbc, padding: 'PKCS7'));
    final encrypted = encrypter.encrypt(plainText, iv: aesIv);
    return encrypted.base64;
  }

  // Decrypt method
  String decryptData(String encryptedText) {
    final aesKey = encrypt.Key(Uint8List.fromList(utf8.encode(key)));
    final aesIv = encrypt.IV(Uint8List.fromList(utf8.encode(iv)));
    final encrypter = encrypt.Encrypter(encrypt.AES(aesKey, mode: encrypt.AESMode.cbc, padding: 'PKCS7'));
    final encrypted = encrypt.Encrypted.fromBase64(encryptedText);
    final decrypted = encrypter.decrypt(encrypted, iv: aesIv);
    return decrypted;
  }
}
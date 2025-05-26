import 'package:encrypt/encrypt.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EncryptionHelper {
  static final _key = Key.fromUtf8(dotenv.env['ENCRYPTION_KEY']!);

  static String encryptText(String plainText) {
    final iv = IV.fromSecureRandom(16);
    final encrypter = Encrypter(AES(_key));
    final encrypted = encrypter.encrypt(plainText, iv: iv);

    return jsonEncode({
      'iv': iv.base64,
      'data': encrypted.base64,
    });
  }

  static String decryptText(String encryptedJson) {
    final parsed = jsonDecode(encryptedJson);
    final iv = IV.fromBase64(parsed['iv'] as String);
    final encrypter = Encrypter(AES(_key));
    return encrypter.decrypt64(parsed['data'] as String, iv: iv);
  }

  static bool isEncrypted(dynamic message) {
    if (message is! String) return false;
    try {
      final parsed = jsonDecode(message);
      return parsed is Map &&
          parsed.containsKey('iv') &&
          parsed.containsKey('data');
    } catch (_) {
      return false;
    }
  }
}

// lib/utils/password_encryption.dart
import 'dart:convert';
import 'package:crypto/crypto.dart';

class PasswordEncryption {
  /// Mengenkripsi password menggunakan SHA-256
  static String hashPassword(String password) {
    final bytes = utf8.encode(password); // Ubah string ke bytes
    final digest = sha256.convert(bytes); // Hash menggunakan SHA-256
    return digest.toString(); // Kembalikan sebagai string hex
  }

  /// [Optional] Verifikasi password dengan hash yang tersimpan
  static bool verifyPassword(String inputPassword, String storedHash) {
    final inputHash = hashPassword(inputPassword);
    return inputHash == storedHash;
  }
}

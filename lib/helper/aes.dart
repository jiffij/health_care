import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'firebase_helper.dart';
// import 'dart:io';

String generateMd5(String input) {
  return md5.convert(utf8.encode(input)).toString();
}

String getMyKey() {
  var uid = getUID();
  return generateMd5(uid);
}

String aesEncrypt(String text, String utf8key) {
  final key = encrypt.Key.fromUtf8(utf8key); //')J@NcRfUjXnZr4u7'
  final iv = encrypt.IV.fromLength(16);
  final encrypter =
      encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
  final encrypted = encrypter.encrypt(text, iv: iv);
  return iv.base64 + encrypted.base64;
}

String aesDecrypt(String text, String utf8key) {
  final key = encrypt.Key.fromUtf8(utf8key);
  var iv = encrypt.IV.fromBase64(text.substring(0, 24));
  final encrypter =
      encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
  var oritext = encrypt.Encrypted.fromBase64(text.substring(24));
  return encrypter.decrypt(oritext, iv: iv);
}

import 'dart:typed_data';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'firebase_helper.dart';
import 'package:fast_rsa/fast_rsa.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'dart:io';

const maxPlaintextLen = 200;

// final storage = new FlutterSecureStorage();
const _storage = FlutterSecureStorage();

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

Future<void> generateKey() async {
  var result = await RSA.generate(2048);
  await _storage.write(key: "PUBLIC_KEY", value: result.publicKey);
  await _storage.write(key: "PRIVATE_KEY", value: result.privateKey);
}

Future<String> getMyPublicKey() async {
  var key = await _storage.read(key: "PUBLIC_KEY") ?? '';
  if (key == '') {
    await generateKey();
  }
  return await _storage.read(key: "PUBLIC_KEY") ?? '';
}

Future<String> getMyPrivateKey() async {
  var key = await _storage.read(key: "PRIVATE_KEY") ?? '';
  if (key == '') {
    await generateKey();
  }
  return await _storage.read(key: "PRIVATE_KEY") ?? '';
}

Future<String> rsaEncryptChunk(String text, String publicKey) async {
  return await RSA.encryptPKCS1v15(text, publicKey);
}

Future<String> rsaDecryptChunk(String text) async {
  var privateKey = await getMyPrivateKey();
  return await RSA.decryptPKCS1v15(text, privateKey);
}

Future<Uint8List> rsaEncryptByte(Uint8List text, String publicKey) async {
  return await RSA.encryptPKCS1v15Bytes(text, publicKey);
}

Future<String> rsaDecrypt(String text) async {
  List<String> substrings = text.split(" ").where((s) => s.isNotEmpty).toList();
  String mergedtext = '';
  for (String str in substrings) {
    mergedtext = mergedtext + await rsaDecryptChunk(str);
  }
  return mergedtext;
}

Future<String> rsaEncrypt(String text, String publicKey) async {
  List<String> chunks = [
    for (int i = 0; i < text.length; i += maxPlaintextLen)
      text.substring(i,
          i + maxPlaintextLen < text.length ? i + maxPlaintextLen : text.length)
  ];
  String mergedtext = '';
  for (int i = 0; i < chunks.length; i++) {
    mergedtext = mergedtext + await rsaEncryptChunk(chunks[i], publicKey);
    if (i != chunks.length - 1) {
      mergedtext += " ";
    }
  }
  return mergedtext;
}

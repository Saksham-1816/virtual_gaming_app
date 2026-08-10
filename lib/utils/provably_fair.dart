import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

class ProvablyFair {
  /// Generate a random hex server seed (32 bytes)
  static String generateServerSeed() {
    final rnd = Random.secure();
    final bytes = List<int>.generate(32, (_) => rnd.nextInt(256));
    return _hexEncode(bytes);
  }

  /// Generate a random hex client seed (16 bytes)
  static String generateClientSeed() {
    final rnd = Random.secure();
    final bytes = List<int>.generate(16, (_) => rnd.nextInt(256));
    return _hexEncode(bytes);
  }

  static int diceFromSeeds({
    required String serverSeed,
    required String clientSeed,
  }) {
    final bytes = _hmacSha256Bytes(serverSeed, clientSeed);
    // use first 4 bytes to form positive int
    final v =
        ((bytes[0] & 0xFF) << 24) |
        ((bytes[1] & 0xFF) << 16) |
        ((bytes[2] & 0xFF) << 8) |
        (bytes[3] & 0xFF);
    final positive = v & 0x7FFFFFFF;
    return (positive % 100) + 1;
  }

  static int coinFromSeeds({
    required String serverSeed,
    required String clientSeed,
  }) {
    final bytes = _hmacSha256Bytes(serverSeed, clientSeed);
    return bytes[0] & 1;
  }

  static String serverSeedHash(String serverSeed) {
    final digest = sha256.convert(utf8.encode(serverSeed));
    return digest.toString();
  }

  static List<int> _hmacSha256Bytes(String keyHex, String msgHex) {
    final key = _hexDecode(keyHex);
    final msg = _hexDecode(msgHex);
    final hmac = Hmac(sha256, key);
    final digest = hmac.convert(msg);
    return digest.bytes;
  }

  static List<int> _hexDecode(String hex) {
    final cleaned = hex.replaceAll('\n', '').replaceAll(' ', '');
    final out = <int>[];
    for (var i = 0; i < cleaned.length; i += 2) {
      final part = cleaned.substring(i, i + 2);
      out.add(int.parse(part, radix: 16));
    }
    return out;
  }

  static String _hexEncode(List<int> bytes) =>
      bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
}

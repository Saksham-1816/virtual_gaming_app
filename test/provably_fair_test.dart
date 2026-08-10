import 'package:flutter_test/flutter_test.dart';
import 'package:virtual_gaming_app/utils/provably_fair.dart';

void main() {
  group('ProvablyFair', () {
    test('deterministic dice and coin from seeds', () {
      final server =
          'a1b2c3d4e5f60718293a4b5c6d7e8f90a1b2c3d4e5f60718293a4b5c6d7e8f90';
      final client = '00112233445566778899aabbccddeeff';

      final roll1 = ProvablyFair.diceFromSeeds(
        serverSeed: server,
        clientSeed: client,
      );
      final roll2 = ProvablyFair.diceFromSeeds(
        serverSeed: server,
        clientSeed: client,
      );
      expect(roll1, roll2);
      expect(roll1, inInclusiveRange(1, 100));

      final coin1 = ProvablyFair.coinFromSeeds(
        serverSeed: server,
        clientSeed: client,
      );
      final coin2 = ProvablyFair.coinFromSeeds(
        serverSeed: server,
        clientSeed: client,
      );
      expect(coin1, coin2);
      expect(coin1, anyOf(0, 1));
    });

    test('serverSeedHash length', () {
      final s = '123456885659';
      final h = ProvablyFair.serverSeedHash(s);
      expect(h.length, 64);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virtual_gaming_app/services/storage_service.dart';
import 'package:virtual_gaming_app/controllers/wallet_controller/wallet_controller.dart';

void main() {
  group('WalletController concurrency', () {
    late SharedPreferences prefs;
    late StorageService storage;
    late WalletController walletController;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      storage = StorageService(prefs);
      walletController = WalletController(storage);
    });

    test(
      'initialize wallet and concurrent deducts do not double-spend',
      () async {
        final userId = 'user1';

        final wallet = await walletController.initializeWallet(userId);
        expect(wallet.balance, WalletController.startingBalance);

        // perform 5 concurrent deducts of 200 each -> total 1000
        final futures = List.generate(
          5,
          (_) => walletController.deduct(userId, 200),
        );

        final results = await Future.wait(futures);

        // All should succeed and final balance should be 0
        expect(results.where((r) => r).length, 5);

        final finalWallet = walletController.getWallet(userId);
        expect(finalWallet.balance, 0);
      },
    );

    test('concurrent adds increase balance correctly', () async {
      final userId = 'user2';

      await walletController.initializeWallet(userId);

      final addFutures = List.generate(
        4,
        (_) => walletController.add(userId, 250),
      );

      await Future.wait(addFutures);

      final w = walletController.getWallet(userId);
      expect(w.balance, WalletController.startingBalance + 1000);
    });
  });
}

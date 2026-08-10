import 'package:virtual_gaming_app/models/wallet_model/wallet_model.dart';
import 'package:virtual_gaming_app/services/storage_service.dart';
import 'package:virtual_gaming_app/utils/app_logger.dart';

class WalletController {
  static const int startingBalance = 1000;

  final StorageService _storageService;

  WalletController(this._storageService);

  final Map<String, Future<void>> _userQueues = {};

  Future<T> _runExclusive<T>(String userId, Future<T> Function() action) {
    final previous = _userQueues[userId] ?? Future.value();

    final future = previous.then((_) => action());

    // store a void future representing the queued work
    _userQueues[userId] = future.then((_) {});

    final voidFuture = _userQueues[userId];

    future.whenComplete(() {
      // remove queue entry only if it still references the future we set
      if (_userQueues[userId] == voidFuture) {
        _userQueues.remove(userId);
      }
    });

    return future;
  }

  Future<WalletModel> initializeWallet(String userId) {
    return _runExclusive<WalletModel>(userId, () async {
      final existingWallet = _storageService.getWallet(userId);

      if (existingWallet != null) {
        AppLogger.info('Existing wallet found for current user');
        return existingWallet;
      }

      const wallet = WalletModel(balance: startingBalance);

      await _storageService.saveWallet(userId, wallet);

      AppLogger.info('New wallet initialized with $startingBalance Game Coins');

      return wallet;
    });
  }

  WalletModel getWallet(String userId) {
    return _storageService.getWallet(userId) ??
        const WalletModel(balance: startingBalance);
  }

  bool canPlaceBet(String userId, int amount) {
    final wallet = getWallet(userId);

    if (amount <= 0) {
      return false;
    }

    return amount <= wallet.balance;
  }

  Future<bool> deduct(String userId, int amount) {
    return _runExclusive<bool>(userId, () async {
      final wallet = getWallet(userId);

      if (amount <= 0) {
        AppLogger.info('Bet rejected: amount must be greater than zero');
        return false;
      }

      if (amount > wallet.balance) {
        AppLogger.info('Bet rejected: insufficient balance');
        return false;
      }

      final newBalance = wallet.balance - amount;

      final updatedWallet = wallet.copyWith(balance: newBalance);

      await _storageService.saveWallet(userId, updatedWallet);

      AppLogger.info('Coins deducted successfully. New balance: $newBalance');

      return true;
    });
  }

  Future<void> add(String userId, int amount) {
    return _runExclusive<void>(userId, () async {
      if (amount <= 0) {
        return;
      }

      final wallet = getWallet(userId);

      final newBalance = wallet.balance + amount;

      final updatedWallet = wallet.copyWith(balance: newBalance);

      await _storageService.saveWallet(userId, updatedWallet);

      AppLogger.info('Coins added successfully. New balance: $newBalance');
    });
  }
}

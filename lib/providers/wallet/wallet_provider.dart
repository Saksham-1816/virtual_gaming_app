import 'package:flutter/foundation.dart';
import 'package:virtual_gaming_app/controllers/wallet_controller/wallet_controller.dart';
import 'package:virtual_gaming_app/models/wallet_model/wallet_model.dart';


class WalletProvider extends ChangeNotifier {
  final WalletController _walletController;

  WalletProvider(this._walletController);

  WalletModel _wallet = const WalletModel(
    balance: WalletController.startingBalance,
  );

  bool _isLoading = false;
  String? _errorMessage;

  WalletModel get wallet => _wallet;
  int get balance => _wallet.balance;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> initializeWallet(String userId) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _wallet = await _walletController.initializeWallet(userId);
    } catch (error) {
      _errorMessage = 'Failed to load wallet.';
    }

    _setLoading(false);
  }

  bool canPlaceBet(String userId, int amount) {
    return _walletController.canPlaceBet(userId, amount);
  }

  Future<bool> deduct(String userId, int amount) async {
    _errorMessage = null;

    if (!canPlaceBet(userId, amount)) {
      _errorMessage = 'Invalid bet amount or insufficient balance.';
      notifyListeners();
      return false;
    }

    final success = await _walletController.deduct(userId, amount);

    if (!success) {
      _errorMessage = 'Unable to place bet.';
      notifyListeners();
      return false;
    }

    _wallet = _walletController.getWallet(userId);

    notifyListeners();

    return true;
  }

  Future<void> add(String userId, int amount) async {
    if (amount <= 0) {
      return;
    }

    await _walletController.add(userId, amount);

    _wallet = _walletController.getWallet(userId);

    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
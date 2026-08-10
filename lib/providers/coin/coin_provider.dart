import 'package:flutter/foundation.dart';
import 'package:virtual_gaming_app/models/game/game_result.dart';
import 'package:virtual_gaming_app/controllers/coin/coin_controller.dart';

class CoinProvider extends ChangeNotifier {
  final CoinController _coinController;

  CoinProvider(this._coinController);

  int _betAmount = 100;
  bool _chooseHeads = true;

  bool _isPlaying = false;
  GameResult? _lastResult;
  String? _errorMessage;

  int get betAmount => _betAmount;
  bool get chooseHeads => _chooseHeads;

  bool get isPlaying => _isPlaying;
  GameResult? get lastResult => _lastResult;
  String? get errorMessage => _errorMessage;

  void setBetAmount(int amount) {
    if (amount <= 0) return;

    _betAmount = amount;
    _errorMessage = null;
    notifyListeners();
  }

  void setChoice(bool heads) {
    _chooseHeads = heads;
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> play(String userId, {int? betAmount}) async {
    if (_isPlaying) return;

    _isPlaying = true;
    _lastResult = null;
    _errorMessage = null;
    notifyListeners();

    try {
      final playAmount = betAmount ?? _betAmount;

      final result = await _coinController.play(
        userId: userId,
        betAmount: playAmount,
        chooseHeads: _chooseHeads,
      );

      if (result == null) {
        _errorMessage = 'Invalid bet amount or insufficient balance.';
      } else {
        _lastResult = result;
      }
    } catch (e) {
      _errorMessage = 'Something went wrong. Please try again.';
    } finally {
      _isPlaying = false;
      notifyListeners();
    }
  }

  void clearResult() {
    _lastResult = null;
    _errorMessage = null;
    notifyListeners();
  }
}

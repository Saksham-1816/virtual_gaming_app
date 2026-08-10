import 'package:flutter/foundation.dart';
import 'package:virtual_gaming_app/models/game/game_result.dart';

import '../../controllers/dice/dice_controller.dart';

class DiceProvider extends ChangeNotifier {
  final DiceController _diceController;

  DiceProvider(this._diceController);

  int _betAmount = 100;
  int _target = 50;
  bool _over = true;

  bool _isPlaying = false;
  GameResult? _lastResult;
  String? _errorMessage;

  int get betAmount => _betAmount;
  int get target => _target;
  bool get over => _over;

  bool get isPlaying => _isPlaying;
  GameResult? get lastResult => _lastResult;
  String? get errorMessage => _errorMessage;

  void setBetAmount(int amount) {
    if (amount <= 0) {
      return;
    }

    _betAmount = amount;
    _errorMessage = null;

    notifyListeners();
  }

  void setTarget(int target) {
    if (target < 2 || target > 98) {
      return;
    }

    _target = target;
    _errorMessage = null;

    notifyListeners();
  }

  void setOver(bool value) {
    _over = value;
    _errorMessage = null;

    notifyListeners();
  }

  Future<void> play(String userId, {int? betAmount}) async {
    // Prevent rapid repeated taps.
    if (_isPlaying) {
      return;
    }

    _isPlaying = true;
    _lastResult = null;
    _errorMessage = null;

    notifyListeners();

    try {
      final playAmount = betAmount ?? _betAmount;

      final result = await _diceController.play(
        userId: userId,
        betAmount: playAmount,
        target: _target,
        over: _over,
      );

      if (result == null) {
        _errorMessage = 'Invalid bet amount or insufficient balance.';
      } else {
        _lastResult = result;
      }
    } catch (error) {
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

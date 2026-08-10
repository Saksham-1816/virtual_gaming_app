import 'package:flutter/foundation.dart';
import 'package:virtual_gaming_app/controllers/history/history_controller.dart';
import 'package:virtual_gaming_app/models/bet/bet_model.dart';


class HistoryProvider extends ChangeNotifier {
  final HistoryController _historyController;

  HistoryProvider(this._historyController);

  List<BetModel> _bets = [];
  bool _isLoading = false;

  List<BetModel> get bets => List.unmodifiable(_bets);
  bool get isLoading => _isLoading;

  Future<void> loadHistory(String userId) async {
    _isLoading = true;
    notifyListeners();

    _bets = _historyController.getHistory(userId);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addBet(BetModel bet) async {
    await _historyController.saveBet(bet);

    _bets = [
      bet,
      ..._bets,
    ];

    notifyListeners();
  }
}
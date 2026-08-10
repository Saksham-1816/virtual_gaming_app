import 'package:virtual_gaming_app/controllers/wallet_controller/wallet_controller.dart';
import 'package:virtual_gaming_app/models/bet/bet_model.dart';
import 'package:virtual_gaming_app/models/game/game_result.dart';

import '../../games/dice_game.dart';


import '../history/history_controller.dart';

class DiceController {
  final WalletController _walletController;
  final HistoryController _historyController;
  final DiceGame _diceGame;

  DiceController({
    required WalletController walletController,
    required HistoryController historyController,
    DiceGame? diceGame,
  })  : _walletController = walletController,
        _historyController = historyController,
        _diceGame = diceGame ?? DiceGame();

  Future<GameResult?> play({
    required String userId,
    required int betAmount,
    required int target,
    required bool over,
  }) async {
    final canBet = _walletController.canPlaceBet(
      userId,
      betAmount,
    );

    if (!canBet) {
      return null;
    }

    final deducted = await _walletController.deduct(
      userId,
      betAmount,
    );

    if (!deducted) {
      return null;
    }

    final result = _diceGame.roll(
      target: target,
      over: over,
      betAmount: betAmount,
    );

    if (result.won) {
      await _walletController.add(
        userId,
        result.payout,
      );
    }

    final resultingBalance =
        _walletController.getWallet(userId).balance;

    final bet = BetModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      userId: userId,
      game: 'Dice',
      amount: betAmount,
      won: result.won,
      payout: result.payout,
      resultingBalance: resultingBalance,
      timestamp: DateTime.now(),
    );

    await _historyController.saveBet(bet);

    return result;
  }
}
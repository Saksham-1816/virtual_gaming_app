import 'package:virtual_gaming_app/controllers/wallet_controller/wallet_controller.dart';
import 'package:virtual_gaming_app/models/bet/bet_model.dart';
import 'package:virtual_gaming_app/models/game/game_result.dart';
import 'package:virtual_gaming_app/games/coin_flip_game.dart';
import 'package:virtual_gaming_app/controllers/history/history_controller.dart';

class CoinController {
  final WalletController _walletController;
  final HistoryController _historyController;
  final CoinFlipGame _coinGame;

  CoinController({
    required WalletController walletController,
    required HistoryController historyController,
    CoinFlipGame? coinGame,
  }) : _walletController = walletController,
       _historyController = historyController,
       _coinGame = coinGame ?? CoinFlipGame();

  Future<GameResult?> play({
    required String userId,
    required int betAmount,
    required bool chooseHeads,
  }) async {
    final canBet = _walletController.canPlaceBet(userId, betAmount);

    if (!canBet) return null;

    final deducted = await _walletController.deduct(userId, betAmount);

    if (!deducted) return null;

    final result = _coinGame.flip(
      chooseHeads: chooseHeads,
      betAmount: betAmount,
    );

    if (result.won) {
      await _walletController.add(userId, result.payout);
    }

    final resultingBalance = _walletController.getWallet(userId).balance;

    final bet = BetModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      userId: userId,
      game: 'Coin Flip',
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

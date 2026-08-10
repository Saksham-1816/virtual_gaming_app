import 'dart:math';

import 'package:virtual_gaming_app/models/game/game_result.dart';

class CoinFlipGame {
  final Random _random;

  CoinFlipGame({int? seed})
      : _random = Random(seed);

  GameResult flip({
    required bool chooseHeads,
    required int betAmount,
  }) {
    if (betAmount <= 0) {
      throw ArgumentError(
        'Bet amount must be greater than zero.',
      );
    }

    // 50/50 result.
    final roll = _random.nextBool() ? 1 : 0;

    final won =
        (chooseHeads && roll == 1) ||
        (!chooseHeads && roll == 0);

    // 50/50 game with 1.90x payout.
    const probability = 0.5;
    const rtp = 0.95;

    final multiplier = won
        ? rtp / probability
        : 0.0;

    final payout = won
        ? (betAmount * multiplier).round()
        : 0;

    return GameResult(
      roll: roll,
      won: won,
      multiplier: multiplier,
      payout: payout,
    );
  }
}
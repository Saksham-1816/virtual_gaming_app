import 'dart:math';

import 'package:virtual_gaming_app/models/game/game_result.dart';

class DiceGame {
  final Random _random;

  DiceGame({int? seed}) : _random = Random(seed);

  GameResult roll({
    required int target,
    required bool over,
    required int betAmount,
  }) {
    if (target < 2 || target > 98) {
      throw ArgumentError(
        'Target must be between 2 and 98.',
      );
    }

    if (betAmount <= 0) {
      throw ArgumentError(
        'Bet amount must be greater than zero.',
      );
    }

    final roll = _random.nextInt(100) + 1;

    final won = over
        ? roll > target
        : roll < target;

    final probability = over
        ? (100 - target) / 100
        : (target - 1) / 100;

    const rtp = 0.95;

    final multiplier = won && probability > 0
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
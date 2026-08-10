class GameResult {
  final int roll;
  final bool won;
  final double multiplier;
  final int payout;

  const GameResult({
    required this.roll,
    required this.won,
    required this.multiplier,
    required this.payout,
  });
}
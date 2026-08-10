class BetModel {
  final String id;
  final String userId;
  final String game;
  final int amount;
  final bool won;
  final int payout;
  final int resultingBalance;
  final DateTime timestamp;

  const BetModel({
    required this.id,
    required this.userId,
    required this.game,
    required this.amount,
    required this.won,
    required this.payout,
    required this.resultingBalance,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'game': game,
      'amount': amount,
      'won': won,
      'payout': payout,
      'resultingBalance': resultingBalance,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory BetModel.fromJson(Map<String, dynamic> json) {
    return BetModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      game: json['game'] as String,
      amount: json['amount'] as int,
      won: json['won'] as bool,
      payout: json['payout'] as int,
      resultingBalance: json['resultingBalance'] as int,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}
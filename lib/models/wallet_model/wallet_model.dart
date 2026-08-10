class WalletModel {
  final int balance;

  const WalletModel({
    required this.balance,
  });

  WalletModel copyWith({
    int? balance,
  }) {
    return WalletModel(
      balance: balance ?? this.balance,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'balance': balance,
    };
  }

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      balance: json['balance'] as int,
    );
  }
}
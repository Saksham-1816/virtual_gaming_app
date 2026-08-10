import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth/auth_provider.dart';
import '../../providers/coin/coin_provider.dart';
import '../../providers/wallet/wallet_provider.dart';

class CoinScreen extends StatefulWidget {
  const CoinScreen({super.key});

  @override
  State<CoinScreen> createState() => _CoinScreenState();
}

class _CoinScreenState extends State<CoinScreen> {
  final TextEditingController _betController =
      TextEditingController(text: '100');

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CoinProvider>().clearResult();

      final user = context.read<AuthProvider>().currentUser;

      if (user != null) {
        context.read<WalletProvider>().initializeWallet(user.id);
      }
    });
  }

  @override
  void dispose() {
    _betController.dispose();
    super.dispose();
  }

  Future<void> _flip() async {
    final auth = context.read<AuthProvider>();
    final coin = context.read<CoinProvider>();

    final user = auth.currentUser;

    if (user == null || coin.isPlaying) {
      return;
    }

    final amount = int.tryParse(
      _betController.text.trim(),
    );

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter a valid bet amount'),
        ),
      );
      return;
    }

    coin.setBetAmount(amount);

    await coin.play(
      user.id,
      betAmount: amount,
    );

    if (!mounted) return;

    await context
        .read<WalletProvider>()
        .initializeWallet(user.id);
  }

  void _setBet(int amount) {
    if (context.read<CoinProvider>().isPlaying) {
      return;
    }

    _betController.text = amount.toString();
    context.read<CoinProvider>().setBetAmount(amount);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<CoinProvider, WalletProvider, AuthProvider>(
      builder: (
        context,
        coinProvider,
        walletProvider,
        authProvider,
        child,
      ) {
        final result = coinProvider.lastResult;

        const purple = Color(0xFF8B2CFF);
        const darkCard = Color(0xFF0D0A1D);

        final betAmount = coinProvider.betAmount;

        // Coin flip is 50/50.
        // Current game logic uses 1.90x payout.
        const multiplier = 1.90;
        const winChance = 50;

        final possiblePayout =
            (betAmount * multiplier).round();

        final profit =
            possiblePayout - betAmount;

        return Scaffold(
          backgroundColor: const Color(0xFF03020A),

          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,

            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),

            title: const Text(
              'Coin Flip',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),

            actions: [
              Container(
                margin: const EdgeInsets.only(
                  right: 12,
                  top: 8,
                  bottom: 8,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D0A1D),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Colors.white24,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.monetization_on,
                      color: Colors.amber,
                      size: 28,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${walletProvider.balance} Coins',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF6C1DFF),
                            Color(0xFFB52CFF),
                          ],
                        ),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              16,
              8,
              16,
              30,
            ),
            child: Column(
              children: [

          
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D0A1D),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: Colors.white12,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: coinProvider.isPlaying
                              ? null
                              : () {
                                  coinProvider.setChoice(true);
                                },
                          child: AnimatedContainer(
                            duration:
                                const Duration(milliseconds: 200),
                            height: 58,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(18),
                              gradient:
                                  coinProvider.chooseHeads
                                      ? const LinearGradient(
                                          colors: [
                                            Color(0xFF1D743C),
                                            Color(0xFF176331),
                                          ],
                                        )
                                      : null,
                              border: Border.all(
                                color: coinProvider.chooseHeads
                                    ? Colors.greenAccent
                                    : Colors.transparent,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.stars,
                                  color:
                                      coinProvider.chooseHeads
                                          ? Colors.amber
                                          : Colors.white54,
                                  size: 30,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'Heads',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight:
                                        coinProvider.chooseHeads
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 4),

                      Expanded(
                        child: GestureDetector(
                          onTap: coinProvider.isPlaying
                              ? null
                              : () {
                                  coinProvider.setChoice(false);
                                },
                          child: AnimatedContainer(
                            duration:
                                const Duration(milliseconds: 200),
                            height: 58,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(18),
                              gradient:
                                  !coinProvider.chooseHeads
                                      ? const LinearGradient(
                                          colors: [
                                            Color(0xFF1D743C),
                                            Color(0xFF176331),
                                          ],
                                        )
                                      : null,
                              border: Border.all(
                                color: !coinProvider.chooseHeads
                                    ? Colors.greenAccent
                                    : Colors.transparent,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.monetization_on_outlined,
                                  color:
                                      !coinProvider.chooseHeads
                                          ? Colors.amber
                                          : Colors.white54,
                                  size: 30,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'Tails',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight:
                                        !coinProvider.chooseHeads
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

          
                _sectionCard(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Bet Amount',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 58,
                              decoration: BoxDecoration(
                                color: const Color(0xFF080615),
                                borderRadius:
                                    BorderRadius.circular(15),
                                border: Border.all(
                                  color: Colors.white12,
                                ),
                              ),
                              child: Row(
                                children: [
                                  const SizedBox(width: 14),

                                  const Icon(
                                    Icons.monetization_on,
                                    color: Colors.amber,
                                    size: 28,
                                  ),

                                  const SizedBox(width: 10),

                                  Expanded(
                                    child: TextField(
                                      controller:
                                          _betController,
                                      enabled:
                                          !coinProvider.isPlaying,
                                      keyboardType:
                                          TextInputType.number,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight:
                                            FontWeight.w600,
                                      ),
                                      decoration:
                                          const InputDecoration(
                                        border:
                                            InputBorder.none,
                                        hintText: '100',
                                        hintStyle: TextStyle(
                                          color: Colors.white38,
                                        ),
                                      ),
                                      onChanged: (value) {
                                        final amount =
                                            int.tryParse(value);

                                        if (amount != null) {
                                          coinProvider
                                              .setBetAmount(
                                            amount,
                                          );
                                          setState(() {});
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(width: 10),

                          SizedBox(
                            height: 58,
                            width: 105,
                            child: ElevatedButton(
                              onPressed:
                                  coinProvider.isPlaying
                                      ? null
                                      : _flip,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    purple,
                                disabledBackgroundColor:
                                    purple.withOpacity(.4),
                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(16),
                                ),
                              ),
                              child:
                                  coinProvider.isPlaying
                                      ? const SizedBox(
                                          width: 22,
                                          height: 22,
                                          child:
                                              CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Text(
                                          'Flip',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight:
                                                FontWeight.bold,
                                          ),
                                        ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Quick bets
                      Row(
                        children: [
                          _quickBet(
                            10,
                            betAmount,
                            _setBet,
                          ),
                          _quickBet(
                            50,
                            betAmount,
                            _setBet,
                          ),
                          _quickBet(
                            100,
                            betAmount,
                            _setBet,
                          ),
                          _quickBet(
                            500,
                            betAmount,
                            _setBet,
                          ),
                          _quickBet(
                            1000,
                            betAmount,
                            _setBet,
                            label: '1K',
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      const Text(
                        'Possible Payout',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Payout
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF0B271B),
                              Color(0xFF07150F),
                            ],
                          ),
                          borderRadius:
                              BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.greenAccent
                                .withOpacity(.55),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.monetization_on,
                              color: Colors.amber,
                              size: 42,
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Win Payout',
                                    style: TextStyle(
                                      color:
                                          Colors.white60,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    '$possiblePayout Coins',
                                    style:
                                        const TextStyle(
                                      color:
                                          Colors.greenAccent,
                                      fontSize: 20,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              width: 1,
                              height: 48,
                              color: Colors.white24,
                            ),

                            const SizedBox(width: 16),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Profit',
                                    style: TextStyle(
                                      color:
                                          Colors.white60,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    '+$profit Coins',
                                    style:
                                        const TextStyle(
                                      color:
                                          Colors.greenAccent,
                                      fontSize: 20,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),

                      _infoRow(
                        Icons.auto_graph,
                        'Payout Multiplier',
                        '${multiplier.toStringAsFixed(2)}x',
                      ),

                      _infoRow(
                        Icons.percent,
                        'Win Chance',
                        '$winChance%',
                      ),

                      const SizedBox(height: 10),

                      // How it works
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0D0822),
                          borderRadius:
                              BorderRadius.circular(14),
                          border: Border.all(
                            color: purple.withOpacity(.35),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.info_outline,
                              color: purple,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'How it works?',
                                    style: TextStyle(
                                      color:
                                          Color(0xFFB76BFF),
                                      fontSize: 16,
                                      fontWeight:
                                          FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Choose Heads or Tails. '
                                    'If the coin lands on your '
                                    'choice, you win!',
                                    style: TextStyle(
                                      color:
                                          Colors.white70,
                                      fontSize: 14,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (result != null) ...[
                  const SizedBox(height: 18),

                  _sectionCard(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Recent Result',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient:
                                    const LinearGradient(
                                  colors: [
                                    Color(0xFFFFD54F),
                                    Color(0xFFB87500),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.amber
                                        .withOpacity(.25),
                                    blurRadius: 15,
                                  ),
                                ],
                              ),
                              child: Icon(
                                result.roll == 1
                                    ? Icons.stars
                                    : Icons
                                        .monetization_on,
                                color: Colors.white,
                                size: 38,
                              ),
                            ),

                            const SizedBox(width: 16),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Result',
                                    style: TextStyle(
                                      color:
                                          Colors.white60,
                                      fontSize: 14,
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  Text(
                                    result.roll == 1
                                        ? 'HEADS'
                                        : 'TAILS',
                                    style:
                                        const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  Text(
                                    _formatDateTime(
                                      DateTime.now(),
                                    ),
                                    style:
                                        const TextStyle(
                                      color:
                                          Colors.white54,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              padding:
                                  const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: result.won
                                    ? const Color(
                                        0xFF0B2B18,
                                      )
                                    : const Color(
                                        0xFF2A0B14,
                                      ),
                                borderRadius:
                                    BorderRadius.circular(14),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    result.won
                                        ? 'You Won'
                                        : 'You Lost',
                                    style: TextStyle(
                                      color: result.won
                                          ? Colors.greenAccent
                                          : Colors.redAccent,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    result.won
                                        ? '+${result.payout}'
                                        : '0',
                                    style: TextStyle(
                                      color: result.won
                                          ? Colors.greenAccent
                                          : Colors.redAccent,
                                      fontSize: 18,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],

                if (coinProvider.errorMessage != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    coinProvider.errorMessage!,
                    style: const TextStyle(
                      color: Colors.redAccent,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _sectionCard({
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF080615),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white12,
        ),
      ),
      child: child,
    );
  }

  Widget _quickBet(
    int amount,
    int selected,
    Function(int) onTap, {
    String? label,
  }) {
    final isSelected = amount == selected;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(amount),
        child: Container(
          margin: const EdgeInsets.only(right: 7),
          height: 45,
          decoration: BoxDecoration(
            color: const Color(0xFF080615),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF8B2CFF)
                  : Colors.white12,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label ?? amount.toString(),
            style: TextStyle(
              color: Colors.white,
              fontWeight: isSelected
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(
    IconData icon,
    String title,
    String value,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 13,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.white12,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFF9D43FF),
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 15,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFFB45CFF),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime date) {
    final hour = date.hour % 12 == 0
        ? 12
        : date.hour % 12;

    final minute =
        date.minute.toString().padLeft(2, '0');

    final second =
        date.second.toString().padLeft(2, '0');

    final period =
        date.hour >= 12 ? 'PM' : 'AM';

    return '${date.day} ${_month(date.month)} '
        '${date.year}, '
        '$hour:$minute:$second $period';
  }

  String _month(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return months[month - 1];
  }
}
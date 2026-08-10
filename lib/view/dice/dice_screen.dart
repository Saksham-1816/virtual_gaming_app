import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth/auth_provider.dart';
import '../../providers/dice/dice_provider.dart';
import '../../providers/wallet/wallet_provider.dart';

class DiceScreen extends StatefulWidget {
  const DiceScreen({super.key});

  @override
  State<DiceScreen> createState() => _DiceScreenState();
}

class _DiceScreenState extends State<DiceScreen> {
  final TextEditingController _betController = TextEditingController(
    text: '100',
  );

  @override
  void dispose() {
    _betController.dispose();
    super.dispose();
  }

  void _updateBetAmount() {
    final amount = int.tryParse(_betController.text.trim());

    if (amount == null) {
      return;
    }

    context.read<DiceProvider>().setBetAmount(amount);
  }

  Future<void> _rollDice() async {
    _updateBetAmount();

    final authProvider = context.read<AuthProvider>();
    final diceProvider = context.read<DiceProvider>();
    final walletProvider = context.read<WalletProvider>();

    if (diceProvider.isPlaying) {
      return;
    }

    final user = authProvider.currentUser;

    if (user == null) {
      return;
    }

    final amount = int.tryParse(_betController.text.trim());

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Enter a valid bet amount')));
      return;
    }

    await diceProvider.play(user.id, betAmount: amount);

    if (!mounted) return;

    await walletProvider.initializeWallet(user.id);

    if (!mounted) return;

    final error = diceProvider.errorMessage;

    if (error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<DiceProvider, WalletProvider>(
      builder: (context, diceProvider, walletProvider, child) {
        final result = diceProvider.lastResult;

        return Scaffold(
          backgroundColor: const Color(0xFF04040D),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopBar(context, walletProvider.balance),

                  const SizedBox(height: 14),

                  _buildBalanceCard(walletProvider.balance),

                  const SizedBox(height: 18),

                  _buildLabel('Bet Amount'),

                  const SizedBox(height: 8),

                  _buildBetField(diceProvider),

                  const SizedBox(height: 16),

                  _buildTargetSection(diceProvider),

                  const SizedBox(height: 10),

                  _buildOverUnder(diceProvider),

                  const SizedBox(height: 18),

                  _buildRollButton(diceProvider),

                  const SizedBox(height: 12),

                  if (result != null)
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: _buildResultCard(result, diceProvider),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopBar(BuildContext context, int balance) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 25,
          ),
        ),

        const SizedBox(width: 22),

        const Text(
          'Roll Dice',
          style: TextStyle(
            color: Colors.white,
            fontSize: 27,
            fontWeight: FontWeight.w700,
          ),
        ),

        const Spacer(),

        _buildCoinPill(balance),
      ],
    );
  }

  Widget _buildCoinPill(int balance) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF080813),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFF4A465D), width: 1.2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
       
      ),
    );
  }
  Widget _buildBalanceCard(int balance) {
    return Container(
      width: double.infinity,
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(23),
        gradient: const LinearGradient(
          colors: [Color(0xFF0A0618), Color(0xFF0D081D)],
        ),
        border: Border.all(color: const Color(0xFF8B27FF), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B27FF).withOpacity(0.12),
            blurRadius: 25,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          const Text(
            'Balance',
            style: TextStyle(
              color: Color(0xFFD0CADC),
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),

          const Spacer(),

          _coinIcon(size: 36),

          const SizedBox(width: 12),

          Text(
            '$balance',
            style: const TextStyle(
              color: Color(0xFFFFD84D),
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(width: 6),

          const Text(
            'Coins',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildBetField(DiceProvider diceProvider) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFF070711),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF302D43)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 18),

          _coinIcon(size: 28),

          const SizedBox(width: 14),

          Expanded(
            child: TextField(
              controller: _betController,
              enabled: !diceProvider.isPlaying,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter amount',
                hintStyle: TextStyle(color: Colors.white30),
              ),
              onChanged: (_) {
                _updateBetAmount();
              },
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TARGET
  // ============================================================

  Widget _buildTargetSection(DiceProvider diceProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              const TextSpan(
                text: 'Target: ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextSpan(
                text: '${diceProvider.target}',
                style: const TextStyle(
                  color: Color(0xFFA73DFF),
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 7,
            activeTrackColor: const Color(0xFF8D22FF),
            inactiveTrackColor: const Color(0xFF252137),
            thumbColor: Colors.white,
            overlayColor: const Color(0xFF9A32FF).withOpacity(0.15),
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 11),
          ),
          child: Slider(
            value: diceProvider.target.toDouble(),
            min: 2,
            max: 98,
            divisions: 96,
            onChanged: diceProvider.isPlaying
                ? null
                : (value) {
                    context.read<DiceProvider>().setTarget(value.round());
                  },
          ),
        ),
      ],
    );
  }

  // ============================================================
  // OVER UNDER
  // ============================================================

  Widget _buildOverUnder(DiceProvider diceProvider) {
    return Row(
      children: [
        Expanded(
          child: _predictionButton(
            title: 'Over',
            selected: diceProvider.over,
            onTap: diceProvider.isPlaying
                ? null
                : () {
                    context.read<DiceProvider>().setOver(true);
                  },
          ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: _predictionButton(
            title: 'Under',
            selected: !diceProvider.over,
            onTap: diceProvider.isPlaying
                ? null
                : () {
                    context.read<DiceProvider>().setOver(false);
                  },
          ),
        ),
      ],
    );
  }

  Widget _predictionButton({
    required String title,
    required bool selected,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(17),
          gradient: selected
              ? const LinearGradient(
                  colors: [Color(0xFF48118C), Color(0xFF210947)],
                )
              : null,
          color: selected ? null : const Color(0xFF080812),
          border: Border.all(
            color: selected ? const Color(0xFF982DFF) : const Color(0xFF252239),
            width: selected ? 1.5 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: const Color(0xFF8E22FF).withOpacity(0.25),
                    blurRadius: 18,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (selected) ...[
              const Icon(Icons.check, color: Color(0xFFC36AFF), size: 25),
              const SizedBox(width: 8),
            ],
            Text(
              title,
              style: TextStyle(
                color: selected ? Colors.white : const Color(0xFFD5D0DF),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ROLL BUTTON
  // ============================================================

  Widget _buildRollButton(DiceProvider diceProvider) {
    return GestureDetector(
      onTap: diceProvider.isPlaying ? null : _rollDice,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: double.infinity,
        height: 68,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFF751FFF), Color(0xFF32108C), Color(0xFF1C0751)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: const Color(0xFFBD53FF), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF8B20FF).withOpacity(0.55),
              blurRadius: 28,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(left: 12, top: 14, child: _miniDice(rotation: -0.2)),
            Positioned(right: 12, top: 14, child: _miniDice(rotation: 0.15)),

            Center(
              child: diceProvider.isPlaying
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    )
                  : const Text(
                      'ROLL DICE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // RESULT
  // ============================================================

  Widget _buildResultCard(dynamic result, DiceProvider diceProvider) {
    final bool won = result.won;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 22, 18, 22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(23),
        gradient: const LinearGradient(
          colors: [Color(0xFF0B0618), Color(0xFF10051F), Color(0xFF070711)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: Border.all(color: const Color(0xFF8E24FF), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7F20FF).withOpacity(0.16),
            blurRadius: 28,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 150,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFF0A0717),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFF3C1761)),
            ),
            child: const Text(
              'Result',
              style: TextStyle(
                color: Color(0xFFC35DFF),
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          const SizedBox(height: 16),

          SizedBox(
            height: 90,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF701FFF).withOpacity(0.5),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6D1CFF).withOpacity(0.25),
                        blurRadius: 20,
                        spreadRadius: 6,
                      ),
                    ],
                  ),
                ),

                Positioned(left: 0, child: _largeDice(rotation: -0.2)),

                Positioned(right: 0, child: _largeDice(rotation: 0.2)),

                Text(
                  '${result.roll}',
                  style: const TextStyle(
                    color: Color(0xFFFFD63D),
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    shadows: [Shadow(color: Color(0xFFFFA800), blurRadius: 10)],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 4),

          Text(
            won ? 'YOU WON!' : 'YOU LOST',
            style: TextStyle(
              color: won ? const Color(0xFF67FF45) : const Color(0xFFFF4560),
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 20),

          _resultInfo(
            icon: Icons.monetization_on,
            title: 'Payout',
            value: '${result.payout} Coins',
          ),

          const SizedBox(height: 12),

          Container(height: 1, color: const Color(0xFF352143)),

          const SizedBox(height: 12),

          _resultInfo(
            icon: Icons.trending_up_rounded,
            title: 'Multiplier',
            value: '${result.multiplier.toStringAsFixed(2)}x',
          ),
        ],
      ),
    );
  }

  Widget _resultInfo({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFB759FF), size: 27),

        const SizedBox(width: 15),

        Text(
          '$title:',
          style: const TextStyle(color: Color(0xFFD9D3E3), fontSize: 18),
        ),

        const Spacer(),

        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // COIN
  // ============================================================

  Widget _coinIcon({required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Color(0xFFFFE16A), Color(0xFFFFB300), Color(0xFFFF8C00)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: const Color(0xFFFFE994), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFB300).withOpacity(0.35),
            blurRadius: 10,
          ),
        ],
      ),
      child: Icon(
        Icons.attach_money_rounded,
        color: Colors.white,
        size: size * 0.6,
      ),
    );
  }

  // ============================================================
  // DICE VISUAL
  // ============================================================

  Widget _miniDice({required double rotation}) {
    return Transform.rotate(
      angle: rotation,
      child: Icon(
        Icons.casino_rounded,
        size: 28,
        color: const Color(0xFF7D36E8),
        shadows: [
          Shadow(
            color: const Color(0xFF9C38FF).withOpacity(0.55),
            blurRadius: 15,
          ),
        ],
      ),
    );
  }

  Widget _largeDice({required double rotation}) {
    return Transform.rotate(
      angle: rotation,
      child: Icon(
        Icons.casino_rounded,
        size: 40,
        color: const Color(0xFFE82E3D),
        shadows: [
          Shadow(
            color: const Color(0xFFFF2348).withOpacity(0.45),
            blurRadius: 18,
          ),
        ],
      ),
    );
  }
}

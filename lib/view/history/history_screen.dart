import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth/auth_provider.dart';
import '../../providers/history/history_provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthProvider>().currentUser;

      if (user == null) return;

      context.read<HistoryProvider>().loadHistory(user.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final historyProvider = context.watch<HistoryProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF03030D),
      body: SafeArea(
        child: Stack(
          children: [
            _buildBackground(),

            Column(
              children: [
                _buildHeader(),

                Expanded(
                  child: historyProvider.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFA83AFF),
                          ),
                        )
                      : historyProvider.bets.isEmpty
                      ? _buildEmptyState()
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(18, 8, 18, 25),
                          itemCount: historyProvider.bets.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final bet = historyProvider.bets[index];

                            return _buildBetCard(bet);
                          },
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF04030E), Color(0xFF080318), Color(0xFF03020B)],
            ),
          ),
        ),

        Positioned(left: -90, top: 150, child: _glow(220)),

        Positioned(right: -100, top: 500, child: _glow(250)),

        Positioned(left: -100, bottom: 100, child: _glow(240)),

        // Background dice.
        Positioned(
          left: -20,
          top: 145,
          child: Transform.rotate(
            angle: -0.3,
            child: const Icon(
              Icons.casino_rounded,
              size: 90,
              color: Color(0xFF472064),
            ),
          ),
        ),

        Positioned(
          right: -20,
          top: 250,
          child: Transform.rotate(
            angle: 0.3,
            child: const Icon(
              Icons.casino_rounded,
              size: 90,
              color: Color(0xFF61253E),
            ),
          ),
        ),

        Positioned(
          right: -15,
          bottom: 330,
          child: Transform.rotate(
            angle: 0.2,
            child: const Icon(
              Icons.casino_rounded,
              size: 85,
              color: Color(0xFF43245E),
            ),
          ),
        ),
      ],
    );
  }

  Widget _glow(double size) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              const Color(0xFF7D20FF).withOpacity(0.15),
              const Color(0xFF7D20FF).withOpacity(0.03),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final balance = context.watch<AuthProvider>().currentUser == null
        ? 0
        : null;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 27,
            ),
          ),

          const SizedBox(width: 6),

          const Text(
            'Bet History',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBetCard(dynamic bet) {
    final bool won = bet.won;

    final Color borderColor = won
        ? const Color(0xFF4B9E42)
        : const Color(0xFF9E2344);

    final Color statusColor = won
        ? const Color(0xFF63F14F)
        : const Color(0xFFFF465E);

    return Container(
      padding: const EdgeInsets.fromLTRB(22, 20, 20, 20),
      decoration: BoxDecoration(
        color: const Color(0xFF070711).withOpacity(0.96),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGameIcon(bet.game, won),

              const SizedBox(width: 20),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            bet.game,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),

                        Text(
                          won ? 'WON' : 'LOST',
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 17),

                    _detail(
                      Icons.monetization_on_rounded,
                      const Color(0xFFFFC52E),
                      'Bet',
                      '${bet.amount} Coins',
                    ),

                    const SizedBox(height: 13),

                    _detail(
                      Icons.card_giftcard_rounded,
                      const Color(0xFFB13BFF),
                      'Payout',
                      '${bet.payout} Coins',
                      valueColor: won ? const Color(0xFF63F14F) : null,
                    ),

                    const SizedBox(height: 13),

                    _detail(
                      Icons.account_balance_wallet_rounded,
                      const Color(0xFF9C35FF),
                      'Balance after bet',
                      '${bet.resultingBalance} Coins',
                    ),

                    const SizedBox(height: 13),

                    _detail(
                      Icons.access_time_rounded,
                      const Color(0xFF9C35FF),
                      'Time',
                      bet.timestamp.toString(),
                      small: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGameIcon(String game, bool won) {
    IconData iconData;
    Color iconColor;

    if (game.toLowerCase().contains('coin')) {
      iconData = Icons.monetization_on;
      iconColor = won ? const Color(0xFF63F14F) : const Color(0xFFFFC52E);
    } else {
      iconData = Icons.casino_rounded;
      iconColor = won ? const Color(0xFF638EFF) : const Color(0xFFD93C59);
    }

    return Container(
      width: 76,
      height: 76,
      decoration: BoxDecoration(
        color: won ? const Color(0xFF102B1B) : const Color(0xFF261025),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: won ? const Color(0xFF397C3D) : const Color(0xFF63213F),
        ),
        boxShadow: [
          BoxShadow(
            color: won
                ? const Color(0xFF3AFF69).withOpacity(0.08)
                : const Color(0xFFFF3155).withOpacity(0.08),
            blurRadius: 12,
          ),
        ],
      ),
      child: Icon(iconData, size: 51, color: iconColor),
    );
  }

  Widget _detail(
    IconData icon,
    Color iconColor,
    String label,
    String value, {
    Color? valueColor,
    bool small = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: iconColor, size: 26),

        const SizedBox(width: 14),

        Text(
          '$label:',
          style: TextStyle(
            color: const Color(0xFFD5D0DD),
            fontSize: small ? 14 : 16,
          ),
        ),

        const SizedBox(width: 7),

        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: valueColor ?? Colors.white,
              fontSize: small ? 14 : 16,
              fontWeight: valueColor != null
                  ? FontWeight.w600
                  : FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.history_rounded, color: Color(0xFFA035FF), size: 70),

          const SizedBox(height: 15),

          const Text(
            'No bets yet',
            style: TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'Your completed bets will appear here.',
            style: TextStyle(color: Color(0xFF9690A4), fontSize: 14),
          ),
        ],
      ),
    );
  }
}

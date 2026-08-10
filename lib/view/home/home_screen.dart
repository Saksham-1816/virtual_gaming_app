import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:virtual_gaming_app/providers/auth/auth_provider.dart';
import 'package:virtual_gaming_app/providers/wallet/wallet_provider.dart';
import 'package:virtual_gaming_app/providers/history/history_provider.dart';

import 'package:virtual_gaming_app/view/dice/dice_screen.dart';
import 'package:virtual_gaming_app/view/coin/coin_screen.dart';
import 'package:virtual_gaming_app/view/history/history_screen.dart';

import '../auth/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthProvider>().currentUser;

      if (user == null) {
        return;
      }

      context.read<WalletProvider>().initializeWallet(user.id);
      context.read<HistoryProvider>().loadHistory(user.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final walletProvider = context.watch<WalletProvider>();
    final historyProvider = context.watch<HistoryProvider>();

    final user = authProvider.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFF050510),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(
                context,
                user?.name ?? 'User',
                walletProvider.balance,
              ),

              const SizedBox(height: 24),

              _buildHeroBanner(context),

              const SizedBox(height: 28),

              _buildSectionHeader(
                context,
                title: 'Game Section',
                onTap: () {},
              ),

              const SizedBox(height: 14),

              _buildGameCards(context),

              const SizedBox(height: 28),

              _buildFeaturedDice(context),

              const SizedBox(height: 30),

              _buildHistorySection(
                context,
                historyProvider,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // HEADER
  // ------------------------------------------------------------

  Widget _buildHeader(
    BuildContext context,
    String userName,
    int balance,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF9B4DFF),
              width: 2,
            ),
              boxShadow: [
              BoxShadow(
                color: const Color(0xFF8A2BE2).withOpacity(0.5),
                blurRadius: 14,
                spreadRadius: 2,
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 28,
            backgroundColor: const Color(0xFF17152B),
            child: Text(
              userName.isNotEmpty
                  ? userName[0].toUpperCase()
                  : 'U',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome,',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      userName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                
                ],
              ),
            ],
          ),
        ),

        _buildWalletChip(balance),

        const SizedBox(width: 8),

        IconButton(
          onPressed: () async {
            await context.read<AuthProvider>().logout();

            if (!context.mounted) return;

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => const LoginScreen(),
              ),
              (route) => false,
            );
          },
          icon: const Icon(
            Icons.logout_rounded,
            color: Color(0xFFFF426D),
            size: 27,
          ),
          tooltip: 'Logout',
        ),
      ],
    );
  }

  Widget _buildWalletChip(int balance) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF0B0B18),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF34324A),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFFFB51B),
            ),
            child: const Icon(
              Icons.monetization_on,
              color: Colors.white,
              size: 22,
            ),
          ),

          const SizedBox(width: 8),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _formatCoins(balance),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'COINS',
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 9,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // HERO
  // ------------------------------------------------------------

  Widget _buildHeroBanner(BuildContext context) {
    return Container(
      height: 210,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF100629),
            Color(0xFF211044),
            Color(0xFF080814),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: const Color(0xFF43236D),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C2CFF).withOpacity(0.25),
            blurRadius: 30,
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -20,
            child: Container(
              height: 180,
              width: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF9B30FF).withOpacity(0.65),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            right: 20,
            bottom: 15,
            child: Icon(
              Icons.casino,
              size: 130,
              color: const Color(0xFFFFB52C).withOpacity(0.9),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'WELCOME TO',
                  style: TextStyle(
                    color: Color(0xFFFFD43B),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  'VIRTUAL',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),

                const Text(
                  'CASINO',
                  style: TextStyle(
                    color: Color(0xFFFFC52E),
                    fontSize: 38,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  'Play  •  Win  •  Enjoy',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // SECTION HEADER
  // ------------------------------------------------------------

  Widget _buildSectionHeader(
    BuildContext context, {
    required String title,
    required VoidCallback onTap,
  }) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),

        const Spacer(),

        TextButton(
          onPressed: onTap,
          child: const Row(
            children: [
              Text(
                'View All',
                style: TextStyle(
                  color: Color(0xFFA64DFF),
                  fontSize: 15,
                ),
              ),
              SizedBox(width: 4),
              Icon(
                Icons.arrow_forward_ios,
                size: 13,
                color: Color(0xFFA64DFF),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // GAME CARDS
  // ------------------------------------------------------------

  Widget _buildGameCards(BuildContext context) {
    return SizedBox(
      height: 225,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _gameCard(
            title: 'Roll Dice',
            subtitle: ' Hot',
            icon: Icons.casino,
            isSelected: true,
            onTap: () async {
              final user = context.read<AuthProvider>().currentUser;

              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const DiceScreen(),
                ),
              );

              if (user != null) {
                await context.read<HistoryProvider>().loadHistory(user.id);
              }
            },
          ),

          _gameCard(
            title: 'Coin Flip',
            subtitle: 'Heads or Tails',
            icon: Icons.monetization_on,
            isSelected: false,
            onTap: () async {
              final user = context.read<AuthProvider>().currentUser;

              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CoinScreen(),
                ),
              );

              if (user != null) {
                await context.read<HistoryProvider>().loadHistory(user.id);
              }
            },
          ),

          _gameCard(
            title: 'Teen Patti',
            subtitle: '★ Popular',
            icon: Icons.style,
            isSelected: false,
          ),

          _gameCard(
            title: 'Roulette',
            subtitle: 'Classic',
            icon: Icons.album,
            isSelected: false,
          ),

          _gameCard(
            title: 'Slots',
            subtitle: 'Fun',
            icon: Icons.local_activity,
            isSelected: false,
          ),
        ],
      ),
    );
  }

  Widget _gameCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 165,
        margin: const EdgeInsets.only(right: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF080817),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFA331FF)
                : const Color(0xFF25243A),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF8A2BE2)
                        .withOpacity(0.28),
                    blurRadius: 20,
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Icon(
                  icon,
                  size: 72,
                  color: isSelected
                      ? const Color(0xFFFF3D5E)
                      : const Color(0xFFB96AFF),
                ),
              ),
            ),

            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF4C1222)
                    : const Color(0xFF26114A),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                subtitle,
                style: TextStyle(
                  color: isSelected
                      ? const Color(0xFFFF4C60)
                      : const Color(0xFFB66AFF),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedDice(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 230,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF100B28),
            Color(0xFF1B0C3D),
            Color(0xFF080812),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        border: Border.all(
          color: const Color(0xFF38245A),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            top: 15,
            child: Icon(
              Icons.casino,
              size: 175,
              color: const Color(0xFFFF334D)
                  .withOpacity(0.8),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Roll Dice',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                const SizedBox(
                  width: 200,
                  child: Text(
                    'Roll the dice and test your luck!',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  height: 48,
                  width: 160,
                  child: ElevatedButton(
                    onPressed: () async {
                      final user = context.read<AuthProvider>().currentUser;

                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const DiceScreen(),
                        ),
                      );

                      if (user != null) {
                        await context.read<HistoryProvider>().loadHistory(user.id);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF7B22E8),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Text(
                          'Play Now',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 12),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  
  Widget _buildHistorySection(
    BuildContext context,
    HistoryProvider historyProvider,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          context,
          title: 'Bet History',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const HistoryScreen(),
              ),
            );
          },
        ),

        const SizedBox(height: 12),

        if (historyProvider.bets.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: const Color(0xFF090918),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF24243A),
              ),
            ),
            child: const Center(
              child: Text(
                'No bets yet',
                style: TextStyle(
                  color: Colors.white60,
                ),
              ),
            ),
          )
        else
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF080817),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF24243A),
              ),
            ),
            child: Column(
              children: historyProvider.bets
                  .take(3)
                  .map(
                    (bet) => _historyTile(
                      context,
                      bet.game,
                      bet.amount,
                      bet.won,
                      bet.payout,
                      bet.timestamp,
                    ),
                  )
                  .toList(),
            ),
          ),
      ],
    );
  }

  Widget _historyTile(
    BuildContext context,
    String game,
    int amount,
    bool won,
    int payout,
    DateTime timestamp,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFF202033),
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF30145A),
              border: Border.all(
                color: const Color(0xFF7130A8),
              ),
            ),
            child: const Icon(
              Icons.games,
              color: Color(0xFFB76AFF),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  game,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  _formatDate(timestamp),
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment:
                CrossAxisAlignment.end,
            children: [
              Text(
                won
                    ? '+ $payout'
                    : '- $amount',
                style: TextStyle(
                  color: won
                      ? const Color(0xFF7DFF22)
                      : const Color(0xFFFF3D4D),
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                won ? 'Won' : 'Lost',
                style: TextStyle(
                  color: won
                      ? const Color(0xFF7DFF22)
                      : const Color(0xFFFF3D4D),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatCoins(int value) {
    return value.toString();
  }

  String _formatDate(DateTime date) {
    final hour = date.hour % 12 == 0
        ? 12
        : date.hour % 12;

    final minute =
        date.minute.toString().padLeft(2, '0');

    final period = date.hour >= 12 ? 'PM' : 'AM';

    return '${date.day} ${_monthName(date.month)} '
        '${date.year} • '
        '$hour:$minute $period';
  }

  String _monthName(int month) {
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
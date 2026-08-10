import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virtual_gaming_app/controllers/auth_controller/auth_controller.dart';
import 'package:virtual_gaming_app/controllers/dice/dice_controller.dart';
import 'package:virtual_gaming_app/controllers/coin/coin_controller.dart';
import 'package:virtual_gaming_app/controllers/history/history_controller.dart';
import 'package:virtual_gaming_app/controllers/wallet_controller/wallet_controller.dart';
import 'package:virtual_gaming_app/providers/auth/auth_provider.dart';
import 'package:virtual_gaming_app/providers/dice/dice_provider.dart';
import 'package:virtual_gaming_app/providers/history/history_provider.dart';
import 'package:virtual_gaming_app/providers/wallet/wallet_provider.dart';
import 'package:virtual_gaming_app/providers/coin/coin_provider.dart';
import 'package:virtual_gaming_app/view/auth/login_screen.dart';
import 'package:virtual_gaming_app/view/home/home_screen.dart';

import 'services/storage_service.dart';
import 'utils/app_logger.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppLogger.info('Application initialization started');

  final preferences = await SharedPreferences.getInstance();
  final storageService = StorageService(preferences);

  final authController = AuthController(storageService);

  final walletController = WalletController(storageService);

  final historyController = HistoryController(storageService);

  // coin controller will be constructed when creating the provider below

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(authController)),

        ChangeNotifierProvider(create: (_) => WalletProvider(walletController)),

        ChangeNotifierProvider(
          create: (_) => HistoryProvider(historyController),
        ),

        ChangeNotifierProvider(
          create: (_) => DiceProvider(
            DiceController(
              walletController: walletController,
              historyController: historyController,
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => CoinProvider(
            // create controller matching Dice pattern
            // instantiate CoinController inline to reuse existing controllers
            // Delay import to avoid circulars; create here directly
            // using the same walletController and historyController.
            // Note: CoinController is lightweight and doesn't need storage here.
            // ignore: prefer_const_constructors
            // We'll create the controller instance inline in the provider
            // to keep consistency with other providers.
            CoinController(
              walletController: walletController,
              historyController: historyController,
            ),
          ),
        ),
      ],
      child: const VirtualGamingApp(),
    ),
  );
  AppLogger.info('Application initialization completed');
}

class VirtualGamingApp extends StatelessWidget {
  const VirtualGamingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Virtual Gaming App',
      theme: ThemeData(useMaterial3: true),
      home: const AuthGate(),
    );
  }
} //D/InputMethodManager( 9238): showSoftInput() view=io.flutter.embedding.android.FlutterView{7dfbf4a VFE...... .F...... 0,0-1344,2992 #1 aid=1073741824} flags=0 reason=SHOW_SOFT_INPUT

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().checkSession();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.isLoggedIn) {
          return const HomeScreen();
        }

        return const LoginScreen();
      },
    );
  }
}

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:virtual_gaming_app/models/auth_model/user_model.dart';
import 'package:virtual_gaming_app/models/bet/bet_model.dart';
import 'package:virtual_gaming_app/models/wallet_model/wallet_model.dart';

import '../utils/app_logger.dart';

class StorageService {
  final SharedPreferences _preferences;

  StorageService(this._preferences);

  static const String _userKey = 'user';
  static const String _loggedInKey = 'is_logged_in';
  static const String _currentUserIdKey = 'current_user_id';
  static const String _walletKeyPrefix = 'wallet_';
  static const String _betsKeyPrefix = 'bets_';
  // Save a user record keyed by user id. Multiple user records are supported.
  Future<void> saveUser(UserModel user) async {
    try {
      final userJson = jsonEncode(user.toJson());

      await _preferences.setString('user_${user.id}', userJson);

      AppLogger.info('User saved successfully');
    } catch (error, stackTrace) {
      AppLogger.error(
        'Failed to save user',
        error: error,
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }

  // Returns the currently logged in user (if any).
  UserModel? getUser() {
    try {
      final currentId = _preferences.getString(_currentUserIdKey);

      if (currentId == null) {
        AppLogger.info('No current user set');
        return null;
      }

      return getUserById(currentId);
    } catch (error, stackTrace) {
      AppLogger.error(
        'Failed to retrieve current user',
        error: error,
        stackTrace: stackTrace,
      );

      return null;
    }
  }

  UserModel? getUserById(String id) {
    try {
      final userJson = _preferences.getString('user_$id');

      if (userJson == null) {
        return null;
      }

      final userMap = jsonDecode(userJson) as Map<String, dynamic>;

      return UserModel.fromJson(userMap);
    } catch (error, stackTrace) {
      AppLogger.error(
        'Failed to retrieve user by id',
        error: error,
        stackTrace: stackTrace,
      );

      return null;
    }
  }

  UserModel? getUserByEmail(String email) {
    try {
      final keys = _preferences.getKeys();

      for (final key in keys) {
        if (!key.startsWith('user_')) continue;

        final userJson = _preferences.getString(key);
        if (userJson == null) continue;

        final userMap = jsonDecode(userJson) as Map<String, dynamic>;
        final user = UserModel.fromJson(userMap);

        if (user.email.toLowerCase() == email.toLowerCase()) {
          return user;
        }
      }

      return null;
    } catch (error, stackTrace) {
      AppLogger.error(
        'Failed to retrieve user by email',
        error: error,
        stackTrace: stackTrace,
      );

      return null;
    }
  }

  // Tracks a boolean logged-in flag and the id of the current user.
  Future<void> setLoggedIn(bool value, {String? userId}) async {
    await _preferences.setBool(_loggedInKey, value);

    if (value && userId != null) {
      await _preferences.setString(_currentUserIdKey, userId);
    }

    if (!value) {
      await _preferences.remove(_currentUserIdKey);
    }

    AppLogger.info(value ? 'User session started' : 'User session ended');
  }

  bool isLoggedIn() {
    return _preferences.getBool(_loggedInKey) ?? false;
  }

  Future<void> clearSession() async {
    await _preferences.setBool(_loggedInKey, false);

    await _preferences.remove(_currentUserIdKey);

    AppLogger.info('User session cleared');
  }

  Future<void> saveWallet(String userId, WalletModel wallet) async {
    try {
      final walletJson = jsonEncode(wallet.toJson());

      await _preferences.setString('$_walletKeyPrefix$userId', walletJson);

      AppLogger.info('Wallet saved successfully');
    } catch (error, stackTrace) {
      AppLogger.error(
        'Failed to save wallet',
        error: error,
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }

  WalletModel? getWallet(String userId) {
    try {
      final walletJson = _preferences.getString('$_walletKeyPrefix$userId');

      if (walletJson == null) {
        AppLogger.info('No wallet found for user');
        return null;
      }

      final walletMap = jsonDecode(walletJson) as Map<String, dynamic>;

      AppLogger.info('Wallet retrieved for user');

      return WalletModel.fromJson(walletMap);
    } catch (error, stackTrace) {
      AppLogger.error(
        'Failed to retrieve wallet',
        error: error,
        stackTrace: stackTrace,
      );

      return null;
    }
  }

  Future<void> saveBet(BetModel bet) async {
    try {
      final key = '$_betsKeyPrefix${bet.userId}';

      final existingBets = getBets(bet.userId);

      existingBets.insert(0, bet);

      final betsJson = jsonEncode(
        existingBets.map((bet) => bet.toJson()).toList(),
      );

      await _preferences.setString(key, betsJson);

      AppLogger.info('Bet saved successfully');
    } catch (error, stackTrace) {
      AppLogger.error(
        'Failed to save bet',
        error: error,
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }

  List<BetModel> getBets(String userId) {
    try {
      final key = '$_betsKeyPrefix$userId';

      final betsJson = _preferences.getString(key);

      if (betsJson == null) {
        return [];
      }

      final decoded = jsonDecode(betsJson) as List;

      return decoded
          .map((item) => BetModel.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    } catch (error, stackTrace) {
      AppLogger.error(
        'Failed to retrieve bet history',
        error: error,
        stackTrace: stackTrace,
      );

      return [];
    }
  }
}

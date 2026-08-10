import 'package:virtual_gaming_app/models/auth_model/user_model.dart';
import 'package:virtual_gaming_app/services/storage_service.dart';
import 'package:virtual_gaming_app/utils/app_logger.dart';
import 'dart:math';

class AuthController {
  final StorageService _storageService;

  AuthController(this._storageService);
  String _generateUserId() {
    return '${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(100000)}';
  }

  Future<bool> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      AppLogger.info('Signup process started');

      final existingUser = _storageService.getUserByEmail(email.trim());

      if (existingUser != null) {
        AppLogger.info('Signup failed: user already exists');
        return false;
      }

      final user = UserModel(
        id: _generateUserId(),
        name: name.trim(),
        email: email.trim(),
        password: password,
      );

      await _storageService.saveUser(user);

      await _storageService.setLoggedIn(true, userId: user.id);

      AppLogger.info('Signup completed successfully');

      return true;
    } catch (error, stackTrace) {
      AppLogger.error(
        'Signup failed unexpectedly',
        error: error,
        stackTrace: stackTrace,
      );

      return false;
    }
  }

  Future<bool> login({required String email, required String password}) async {
    try {
      AppLogger.info('Login process started');

      final user = _storageService.getUserByEmail(email.trim());

      if (user == null) {
        AppLogger.info('Login failed: no user found for email');
        return false;
      }

      final isValidCredentials = user.password == password;

      if (!isValidCredentials) {
        AppLogger.info('Login failed: invalid credentials');
        return false;
      }

      await _storageService.setLoggedIn(true, userId: user.id);

      AppLogger.info('Login completed successfully');

      return true;
    } catch (error, stackTrace) {
      AppLogger.error(
        'Login failed unexpectedly',
        error: error,
        stackTrace: stackTrace,
      );

      return false;
    }
  }

  Future<void> logout() async {
    try {
      AppLogger.info('Logout process started');

      await _storageService.clearSession();

      AppLogger.info('Logout completed successfully');
    } catch (error, stackTrace) {
      AppLogger.error('Logout failed', error: error, stackTrace: stackTrace);

      rethrow;
    }
  }

  bool checkSession() {
    final isLoggedIn = _storageService.isLoggedIn();

    AppLogger.info('Session checked: ${isLoggedIn ? 'active' : 'inactive'}');

    return isLoggedIn;
  }

  UserModel? getCurrentUser() {
    return _storageService.getUser();
  }
}

import 'package:flutter/foundation.dart';
import 'package:virtual_gaming_app/controllers/auth_controller/auth_controller.dart';
import 'package:virtual_gaming_app/models/auth_model/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthController _authController;

  AuthProvider(this._authController);

  bool _isLoading = false;
  bool _isLoggedIn = false;
  String? _errorMessage;
  UserModel? _currentUser;

  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  String? get errorMessage => _errorMessage;
  UserModel? get currentUser => _currentUser;

  Future<bool> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    final success = await _authController.signup(
      name: name,
      email: email,
      password: password,
    );

    if (success) {
      _isLoggedIn = true;
      _currentUser = _authController.getCurrentUser();
    } else {
      final existing = _authController.getCurrentUser();
      if (existing != null &&
          existing.email.toLowerCase() == email.trim().toLowerCase()) {
        _errorMessage = 'User already exists.';
      } else {
        _errorMessage = 'Signup failed. Please try again.';
      }
    }

    _setLoading(false);

    return success;
  }

  Future<bool> login({required String email, required String password}) async {
    _setLoading(true);
    _errorMessage = null;

    final success = await _authController.login(
      email: email,
      password: password,
    );

    if (success) {
      _isLoggedIn = true;
      _currentUser = _authController.getCurrentUser();
    } else {
      _errorMessage = 'Invalid email or password.';
    }

    _setLoading(false);

    return success;
  }

  Future<void> logout() async {
    await _authController.logout();

    _isLoggedIn = false;
    _currentUser = null;
    _errorMessage = null;

    notifyListeners();
  }

  void checkSession() {
    _isLoggedIn = _authController.checkSession();

    if (_isLoggedIn) {
      _currentUser = _authController.getCurrentUser();
    }

    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}

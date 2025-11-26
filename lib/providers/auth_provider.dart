import 'package:flutter/material.dart';
import 'package:simulasi_ukk/models/user_model.dart';
import 'package:simulasi_ukk/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  UserModel? _user;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  UserModel? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;

  // Register a new user
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    String? role,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _authService.register(
        name: name,
        email: email,
        password: password,
        role: role,
      );

      if (response.user != null) {
        _user = UserModel(
          id: response.user!.id,
          name: name,
          email: response.user!.email ?? '',
          role: role ?? 'pegawai', // Default to 'pegawai' as per your schema
        );
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Registration failed';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Login user
  Future<bool> login({required String email, required String password}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _authService.login(
        email: email,
        password: password,
      );

      if (response.user != null) {
        final userDetails = await _authService.getUserDetails(
          response.user!.id,
        );

        _user = UserModel(
          id: response.user!.id,
          name:
              userDetails?['nama'] ??
              response.user!.userMetadata?['nama'] ??
              '',
          email: response.user!.email ?? '',
          role: userDetails?['role'] ?? response.user!.userMetadata?['role'],
        );
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Login failed';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Logout user
  Future<void> logout() async {
    try {
      await _authService.logout();
      _user = null;
      notifyListeners();
    } catch (e) {
      print('Error during logout: $e');
      _user = null;
      notifyListeners();
    }
  }

  bool checkAuthStatus() {
    final currentUser = _authService.getCurrentUser();
    if (currentUser != null) {
      _user = UserModel(
        id: currentUser.id,
        name: currentUser.userMetadata?['nama'] ?? '',
        email: currentUser.email ?? '',
        role: currentUser.userMetadata?['role'],
      );
      notifyListeners();
      return true;
    }
    return false;
  }
}

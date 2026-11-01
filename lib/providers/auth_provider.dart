import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/storage_service.dart';

class AuthProvider extends ChangeNotifier {
  final StorageService _storage;
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  AuthProvider(this._storage) {
    _loadUserFromStorage();
  }

  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null && _storage.isLoggedIn;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isCoordinator => _currentUser?.isCoordinator ?? false;
  bool get isAdmin => _currentUser?.isAdmin ?? false;

  void _loadUserFromStorage() {
    _currentUser = _storage.getUser();
    notifyListeners();
  }

  Future<bool> login({required String email, required String password}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate network / auth latency
      await Future.delayed(const Duration(milliseconds: 600));

      // --- Input Validation ---
      if (email.trim().isEmpty || password.isEmpty) {
        _errorMessage = 'Email and password are required.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      if (!_isValidEmail(email.trim())) {
        _errorMessage = 'Please enter a valid email address.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      if (password.length < 6) {
        _errorMessage = 'Password must be at least 6 characters.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // --- Check if user is registered ---
      if (!_storage.isEmailRegistered(email.trim())) {
        _errorMessage = 'No account found with this email. Please sign up first.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // --- Verify password against stored hash ---
      final user = _storage.verifyLogin(email.trim(), password);
      if (user == null) {
        _errorMessage = 'Incorrect password. Please try again.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // --- Login successful ---
      _currentUser = user;
      await _storage.saveUser(_currentUser!);
      await _storage.setLoggedIn(true);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Authentication error: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String rollNo,
    required String department,
    required String semester,
    required String phone,
    required String password,
    String role = 'student',
    String? clubName,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 600));

      // --- Input Validation ---
      if (name.trim().isEmpty) {
        _errorMessage = 'Please enter your full name.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      if (email.trim().isEmpty || !_isValidEmail(email.trim())) {
        _errorMessage = 'Please enter a valid email address.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      if (rollNo.trim().isEmpty) {
        _errorMessage = 'Please enter your Roll Number / Student ID.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      if (password.length < 6) {
        _errorMessage = 'Password must be at least 6 characters.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // --- Check if email is already registered ---
      if (_storage.isEmailRegistered(email.trim())) {
        _errorMessage = 'An account with this email already exists. Please sign in.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // --- Create user model ---
      final newUser = UserModel(
        id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
        name: name.trim(),
        email: email.trim().toLowerCase(),
        rollNo: rollNo.trim(),
        department: department,
        semester: semester,
        phone: phone,
        role: role,
        clubName: clubName,
        avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400',
      );

      // --- Save to registered users database with hashed password ---
      final registered = await _storage.registerUser(newUser, password);
      if (!registered) {
        _errorMessage = 'Registration failed. Please try again.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // --- Auto login after registration ---
      _currentUser = newUser;
      await _storage.saveUser(_currentUser!);
      await _storage.setLoggedIn(true);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Registration failed: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Validates email format properly
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  void switchRole(String newRole) async {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(
        role: newRole,
        clubName: newRole == 'coordinator' ? 'TechNova & AI Club' : null,
      );
      await _storage.saveUser(_currentUser!);
      notifyListeners();
    }
  }

  void updateProfile({
    String? name,
    String? department,
    String? semester,
    String? phone,
    String? avatarUrl,
  }) async {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(
        name: name,
        department: department,
        semester: semester,
        phone: phone,
        avatarUrl: avatarUrl,
      );
      await _storage.saveUser(_currentUser!);
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    await _storage.clearUser();
    notifyListeners();
  }
}

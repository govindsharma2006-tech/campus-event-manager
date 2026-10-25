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

      if (email.isEmpty || password.isEmpty) {
        _errorMessage = 'Email and password are required.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      if (!email.contains('@')) {
        _errorMessage = 'Please enter a valid university email address.';
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

      // Determine role based on email or credentials
      final bool isCoord = email.toLowerCase().contains('club') || email.toLowerCase().contains('coord') || email.toLowerCase().contains('admin');
      
      _currentUser = UserModel(
        id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
        name: email.split('@')[0].toUpperCase(),
        email: email,
        rollNo: '23CSB${(100 + (DateTime.now().millisecond % 899))}',
        department: 'Computer Science & Engineering',
        semester: '6th Semester',
        phone: '+91 98765 12345',
        role: isCoord ? 'coordinator' : 'student',
        clubName: isCoord ? 'Tech & Robotics Club' : null,
        avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400',
      );

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

      _currentUser = UserModel(
        id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        email: email,
        rollNo: rollNo,
        department: department,
        semester: semester,
        phone: phone,
        role: role,
        clubName: clubName,
        avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400',
      );

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

  // Quick Login for classroom demonstration
  Future<void> demoLoginAsStudent() async {
    _currentUser = UserModel(
      id: 'student_demo_1',
      name: 'Aarav Sharma',
      email: 'aarav.sharma@campus.edu',
      rollNo: '23CSB1042',
      department: 'Computer Science & Engineering',
      semester: '6th Semester',
      phone: '+91 98765 43210',
      role: 'student',
      avatarUrl: 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=400',
    );
    await _storage.saveUser(_currentUser!);
    await _storage.setLoggedIn(true);
    notifyListeners();
  }

  Future<void> demoLoginAsCoordinator() async {
    _currentUser = UserModel(
      id: 'coord_demo_1',
      name: 'Dr. Priya Verma',
      email: 'priya.verma@campus.edu',
      rollNo: 'FAC-CS-088',
      department: 'Information Technology',
      semester: 'Faculty / Club Convener',
      phone: '+91 98111 22334',
      role: 'coordinator',
      clubName: 'TechNova & AI Club',
      avatarUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=400',
    );
    await _storage.saveUser(_currentUser!);
    await _storage.setLoggedIn(true);
    notifyListeners();
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

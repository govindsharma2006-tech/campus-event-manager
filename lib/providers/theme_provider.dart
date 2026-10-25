import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class ThemeProvider extends ChangeNotifier {
  final StorageService _storage;
  bool _isDarkMode;

  ThemeProvider(this._storage) : _isDarkMode = _storage.isDarkMode;

  bool get isDarkMode => _isDarkMode;
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _storage.setDarkMode(_isDarkMode);
    notifyListeners();
  }

  void setDarkMode(bool isDark) {
    if (_isDarkMode != isDark) {
      _isDarkMode = isDark;
      _storage.setDarkMode(_isDarkMode);
      notifyListeners();
    }
  }
}

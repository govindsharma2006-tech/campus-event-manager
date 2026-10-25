import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/event_model.dart';
import '../models/registration_model.dart';
import '../models/user_model.dart';

class StorageService {
  static const String _keyUser = 'campus_user_data';
  static const String _keyIsLoggedIn = 'campus_is_logged_in';
  static const String _keyThemeMode = 'campus_theme_mode';
  static const String _keyOnboardingDone = 'campus_onboarding_done';
  static const String _keyCustomEvents = 'campus_custom_events';
  static const String _keyRegistrations = 'campus_user_registrations';
  static const String _keyBookmarks = 'campus_bookmarks';

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  static Future<StorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService(prefs);
  }

  // --- Onboarding & Auth State ---
  bool get isOnboardingDone => _prefs.getBool(_keyOnboardingDone) ?? false;
  Future<void> setOnboardingDone(bool value) async {
    await _prefs.setBool(_keyOnboardingDone, value);
  }

  bool get isLoggedIn => _prefs.getBool(_keyIsLoggedIn) ?? false;
  Future<void> setLoggedIn(bool value) async {
    await _prefs.setBool(_keyIsLoggedIn, value);
  }

  // --- User Profile ---
  UserModel? getUser() {
    final userJson = _prefs.getString(_keyUser);
    if (userJson == null) return null;
    try {
      return UserModel.fromJson(userJson);
    } catch (e) {
      return null;
    }
  }

  Future<void> saveUser(UserModel user) async {
    await _prefs.setString(_keyUser, user.toJson());
  }

  Future<void> clearUser() async {
    await _prefs.remove(_keyUser);
    await _prefs.setBool(_keyIsLoggedIn, false);
  }

  // --- Theme Mode ---
  bool get isDarkMode => _prefs.getBool(_keyThemeMode) ?? false;
  Future<void> setDarkMode(bool isDark) async {
    await _prefs.setBool(_keyThemeMode, isDark);
  }

  // --- Events Local Persistence (CRUD) ---
  List<EventModel> getStoredEvents() {
    final eventsJson = _prefs.getString(_keyCustomEvents);
    if (eventsJson == null) return [];
    try {
      final List decoded = json.decode(eventsJson);
      return decoded.map((e) => EventModel.fromMap(e)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveEvents(List<EventModel> events) async {
    final list = events.map((e) => e.toMap()).toList();
    await _prefs.setString(_keyCustomEvents, json.encode(list));
  }

  // --- Registrations / Tickets ---
  List<RegistrationModel> getRegistrations() {
    final regJson = _prefs.getString(_keyRegistrations);
    if (regJson == null) return [];
    try {
      final List decoded = json.decode(regJson);
      return decoded.map((e) => RegistrationModel.fromMap(e)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveRegistrations(List<RegistrationModel> registrations) async {
    final list = registrations.map((r) => r.toMap()).toList();
    await _prefs.setString(_keyRegistrations, json.encode(list));
  }

  // --- Bookmarks ---
  List<String> getBookmarks() {
    return _prefs.getStringList(_keyBookmarks) ?? [];
  }

  Future<void> saveBookmarks(List<String> eventIds) async {
    await _prefs.setStringList(_keyBookmarks, eventIds);
  }
}

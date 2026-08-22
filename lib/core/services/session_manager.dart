import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  // ==========================================================
  // SINGLETON INSTANCE
  // ==========================================================

  static final SessionManager instance = SessionManager._internal();

  SessionManager._internal();

  // ==========================================================
  // KEYS
  // ==========================================================

  static const String _loggedInKey = 'is_logged_in';
  static const String _onboardingKey = 'onboarding_completed';

  // ==========================================================
  // LOGIN SESSION
  // ==========================================================

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_loggedInKey) ?? false;
  }

  // ==========================================================
  // LOGIN
  // ==========================================================

  Future<void> login() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_loggedInKey, true);
  }

  // ==========================================================
  // LOGOUT
  // ==========================================================

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_loggedInKey, false);
  }

  // ==========================================================
  // ONBOARDING COMPLETED
  // ==========================================================

  Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_onboardingKey) ?? false;
  }

  // ==========================================================
  // SET ONBOARDING COMPLETED
  // ==========================================================

  Future<void> setOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_onboardingKey, true);
  }

  // ==========================================================
  // CLEAR SESSION
  // ==========================================================

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_loggedInKey, false);
  }
}
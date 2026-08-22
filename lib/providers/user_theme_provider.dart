import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserThemeProvider extends ChangeNotifier {
  // ============================================================
  // STORAGE KEY
  // ============================================================

  static const String _themeKey = 'user_theme_mode';

  // ============================================================
  // THEME MODE
  // ============================================================

  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  bool get isDark => _themeMode == ThemeMode.dark;

  bool get isLight => _themeMode == ThemeMode.light;

  // ============================================================
  // CONSTRUCTOR
  // ============================================================

  UserThemeProvider() {
    loadTheme();
  }

  // ============================================================
  // LOAD SAVED THEME
  // ============================================================

  Future<void> loadTheme() async {
    try {
      final SharedPreferences prefs =
          await SharedPreferences.getInstance();

      final String? savedTheme =
          prefs.getString(_themeKey);

      if (savedTheme == 'dark') {
        _themeMode = ThemeMode.dark;
      } else {
        _themeMode = ThemeMode.light;
      }

      notifyListeners();
    } catch (e) {
      _themeMode = ThemeMode.light;
      notifyListeners();
    }
  }

  // ============================================================
  // LIGHT MODE
  // ============================================================

  Future<void> setLightMode() async {
    await setTheme(ThemeMode.light);
  }

  // ============================================================
  // DARK MODE
  // ============================================================

  Future<void> setDarkMode() async {
    await setTheme(ThemeMode.dark);
  }

  // ============================================================
  // SET THEME
  // ============================================================

  Future<void> setTheme(ThemeMode mode) async {
    _themeMode = mode;

    notifyListeners();

    try {
      final SharedPreferences prefs =
          await SharedPreferences.getInstance();

      await prefs.setString(
        _themeKey,
        mode == ThemeMode.dark ? 'dark' : 'light',
      );
    } catch (e) {
      // Storage error ki wajah se app crash nahi hogi.
    }
  }

  // ============================================================
  // TOGGLE THEME
  // ============================================================

  Future<void> toggleTheme() async {
    if (_themeMode == ThemeMode.dark) {
      await setLightMode();
    } else {
      await setDarkMode();
    }
  }

  // ============================================================
  // RESET THEME
  // ============================================================

  Future<void> resetTheme() async {
    await setLightMode();
  }
}
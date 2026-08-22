import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTheme {
  AppTheme._();

  // =====================================================
  // LIGHT THEME
  // =====================================================

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    scaffoldBackgroundColor: AppColors.cream,

    fontFamily: 'Roboto',

    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.brown,
      brightness: Brightness.light,
      primary: AppColors.brown,
      secondary: AppColors.peach,
    ),

    // ===================================================
    // APP BAR
    // ===================================================

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.cream,
      foregroundColor: AppColors.brown,
      elevation: 0,
      centerTitle: false,
    ),

    // ===================================================
    // TEXT THEME
    // ===================================================

    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        color: AppColors.brown,
      ),
      bodyMedium: TextStyle(
        color: AppColors.grey,
      ),
      titleLarge: TextStyle(
        color: AppColors.brown,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: TextStyle(
        color: AppColors.brown,
        fontWeight: FontWeight.w600,
      ),
    ),

    // ===================================================
    // INPUT FIELDS
    // ===================================================

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      hintStyle: const TextStyle(
        color: AppColors.grey,
      ),
      prefixIconColor: AppColors.brown,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: AppColors.brown,
          width: 1.5,
        ),
      ),
    ),

    // ===================================================
    // CARD
    // ===================================================

    cardTheme: const CardThemeData(
      color: Colors.white,
      elevation: 2,
    ),

    // ===================================================
    // BUTTON
    // ===================================================

    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.brown,
        foregroundColor: Colors.white,
        minimumSize: const Size(
          double.infinity,
          52,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    ),

    // ===================================================
    // OUTLINED BUTTON
    // ===================================================

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.brown,
        side: const BorderSide(
          color: AppColors.brown,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    ),

    // ===================================================
    // NAVIGATION BAR
    // ===================================================

    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: AppColors.peach,
      elevation: 3,
      height: 75,
      labelTextStyle: const WidgetStatePropertyAll(
        TextStyle(
          color: AppColors.brown,
          fontWeight: FontWeight.w600,
        ),
      ),
      iconTheme: const WidgetStatePropertyAll(
        IconThemeData(
          color: AppColors.grey,
        ),
      ),
    ),

    // ===================================================
    // BOTTOM NAVIGATION BAR
    // ===================================================

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: AppColors.brown,
      unselectedItemColor: AppColors.grey,
    ),

    // ===================================================
    // DIVIDER
    // ===================================================

    dividerColor: Colors.black12,
  );

  // =====================================================
  // DARK THEME (HIGH CONTRAST & CLEAR LOOK)
  // =====================================================

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    // Rich Dark Background (Admin side matching)
    scaffoldBackgroundColor: const Color(0xFF140D0B),

    fontFamily: 'Roboto',

    colorScheme: const ColorScheme.dark(
      primary: AppColors.peach,
      secondary: AppColors.brown,
      surface: Color(0xFF231814),
      onPrimary: Colors.black,
      onSurface: Colors.white,
    ),

    // ===================================================
    // APP BAR
    // ===================================================

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF140D0B),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      actionsIconTheme: IconThemeData(color: Colors.white),
      iconTheme: IconThemeData(color: Colors.white),
    ),

    // ===================================================
    // TEXT THEME
    // ===================================================

    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        color: Color(0xFFD6C7C2), // Ultra-clear light grey-cream
        fontSize: 14,
      ),
      titleLarge: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 22,
      ),
      titleMedium: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: 18,
      ),
      titleSmall: TextStyle(
        color: AppColors.peach,
        fontWeight: FontWeight.bold,
      ),
    ),

    // ===================================================
    // INPUT FIELDS
    // ===================================================

    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFF231814),
      hintStyle: TextStyle(
        color: Color(0xFFA6938A),
      ),
      labelStyle: TextStyle(
        color: Colors.white,
      ),
      prefixIconColor: AppColors.peach,
      suffixIconColor: AppColors.peach,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(14),
        ),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(14),
        ),
        borderSide: BorderSide(
          color: Color(0xFF382721),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(14),
        ),
        borderSide: BorderSide(
          color: AppColors.peach,
          width: 1.5,
        ),
      ),
    ),

    // ===================================================
    // CARD
    // ===================================================

    cardTheme: CardThemeData(
      color: const Color(0xFF231814),
      elevation: 4,
      shadowColor: Colors.black.withValues(alpha: 0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(
          color: Color(0xFF33231D),
          width: 1,
        ),
      ),
    ),

    // ===================================================
    // BUTTON
    // ===================================================

    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.peach,
        foregroundColor: AppColors.brown,
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        minimumSize: const Size(
          double.infinity,
          52,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    ),

    // ===================================================
    // OUTLINED BUTTON
    // ===================================================

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.peach,
        side: const BorderSide(
          color: AppColors.peach,
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    ),

    // ===================================================
    // NAVIGATION BAR
    // ===================================================

    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color(0xFF1C1310),
      indicatorColor: AppColors.peach,
      elevation: 8,
      height: 75,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(
            color: AppColors.peach,
            fontWeight: FontWeight.bold,
          );
        }
        return const TextStyle(
          color: Color(0xFFA6938A),
          fontWeight: FontWeight.w500,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(
            color: AppColors.brown,
          );
        }
        return const IconThemeData(
          color: Color(0xFFA6938A),
        );
      }),
    ),

    // ===================================================
    // BOTTOM NAVIGATION BAR
    // ===================================================

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1C1310),
      selectedItemColor: AppColors.peach,
      unselectedItemColor: Color(0xFFA6938A),
      elevation: 8,
    ),

    // ===================================================
    // DIVIDER
    // ===================================================

    dividerColor: const Color(0xFF382721),

    // ===================================================
    // DIALOG
    // ===================================================

    dialogTheme: const DialogThemeData(
      backgroundColor: Color(0xFF231814),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      contentTextStyle: TextStyle(
        color: Color(0xFFD6C7C2),
      ),
    ),

    // ===================================================
    // SNACKBAR
    // ===================================================

    snackBarTheme: const SnackBarThemeData(
      backgroundColor: Color(0xFF231814),
      contentTextStyle: TextStyle(
        color: Colors.white,
      ),
    ),
  );
}

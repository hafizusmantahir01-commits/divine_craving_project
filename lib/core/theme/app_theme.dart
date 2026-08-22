import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTheme {
  AppTheme._();

  // ============================================================
  // LIGHT THEME
  // ============================================================

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
      surface: Colors.white,
      onSurface: AppColors.brown,
    ),

    // ============================================================
    // APP BAR
    // ============================================================

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.cream,
      foregroundColor: AppColors.brown,
      elevation: 0,
      centerTitle: false,
      iconTheme: IconThemeData(
        color: AppColors.brown,
      ),
      actionsIconTheme: IconThemeData(
        color: AppColors.brown,
      ),
    ),

    // ============================================================
    // TEXT THEME
    // ============================================================

    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        color: AppColors.brown,
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        color: AppColors.grey,
        fontSize: 14,
      ),
      bodySmall: TextStyle(
        color: AppColors.grey,
        fontSize: 12,
      ),
      titleLarge: TextStyle(
        color: AppColors.brown,
        fontWeight: FontWeight.bold,
        fontSize: 22,
      ),
      titleMedium: TextStyle(
        color: AppColors.brown,
        fontWeight: FontWeight.w600,
        fontSize: 18,
      ),
      titleSmall: TextStyle(
        color: AppColors.brown,
        fontWeight: FontWeight.bold,
      ),
    ),

    // ============================================================
    // INPUT FIELDS
    // ============================================================

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      hintStyle: const TextStyle(
        color: AppColors.grey,
      ),
      labelStyle: const TextStyle(
        color: AppColors.brown,
      ),
      prefixIconColor: AppColors.brown,
      suffixIconColor: AppColors.brown,
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

    // ============================================================
    // CARD
    // ============================================================

    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),

    // ============================================================
    // FILLED BUTTON
    // ============================================================

    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.brown,
        foregroundColor: Colors.white,
        minimumSize: const Size(
          double.infinity,
          52,
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    ),

    // ============================================================
    // OUTLINED BUTTON
    // ============================================================

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.brown,
        side: const BorderSide(
          color: AppColors.brown,
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    ),

    // ============================================================
    // TEXT BUTTON
    // ============================================================

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.brown,
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // ============================================================
    // NAVIGATION BAR
    // ============================================================

    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: AppColors.peach,
      elevation: 3,
      height: 75,
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              color: AppColors.brown,
              fontWeight: FontWeight.bold,
            );
          }

          return const TextStyle(
            color: AppColors.grey,
            fontWeight: FontWeight.w500,
          );
        },
      ),
      iconTheme: WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(
              color: AppColors.brown,
            );
          }

          return const IconThemeData(
            color: AppColors.grey,
          );
        },
      ),
    ),

    // ============================================================
    // BOTTOM NAVIGATION BAR
    // ============================================================

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: AppColors.brown,
      unselectedItemColor: AppColors.grey,
      elevation: 3,
    ),

    // ============================================================
    // DIVIDER
    // ============================================================

    dividerColor: Colors.black12,

    // ============================================================
    // DIALOG
    // ============================================================

    dialogTheme: const DialogThemeData(
      backgroundColor: Colors.white,
      titleTextStyle: TextStyle(
        color: AppColors.brown,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      contentTextStyle: TextStyle(
        color: AppColors.grey,
        fontSize: 14,
      ),
    ),

    // ============================================================
    // SNACKBAR
    // ============================================================

    snackBarTheme: const SnackBarThemeData(
      backgroundColor: AppColors.brown,
      contentTextStyle: TextStyle(
        color: Colors.white,
      ),
    ),
  );

  // ============================================================
  // DARK THEME
  // ============================================================
  //
  // IMPORTANT:
  // Ye colors AdminDashboard ke Dark Mode ke
  // colors ke according rakhe gaye hain.
  //
  // Admin:
  // Background  = #121212
  // Card        = #1E1E1E
  // Text        = White
  // Secondary   = White70
  // Icon BG     = #302820
  // Accent      = Gold
  // Selected BG = #3A3027
  //
  // ============================================================

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    // ============================================================
    // ADMIN STYLE BACKGROUND
    // ============================================================

    scaffoldBackgroundColor: const Color(0xFF121212),

    fontFamily: 'Roboto',

    // ============================================================
    // COLOR SCHEME
    // ============================================================

    colorScheme: const ColorScheme.dark(
      primary: AppColors.gold,
      secondary: AppColors.peach,
      surface: Color(0xFF1E1E1E),
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onSurface: Colors.white,
      error: Colors.redAccent,
      onError: Colors.white,
    ),

    // ============================================================
    // APP BAR
    // ============================================================

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      actionsIconTheme: IconThemeData(
        color: AppColors.gold,
      ),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: 'Roboto',
      ),
    ),

    // ============================================================
    // TEXT THEME
    // ============================================================

    textTheme: const TextTheme(
      // Main normal text
      bodyLarge: TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),

      // Secondary text
      bodyMedium: TextStyle(
        color: Colors.white70,
        fontSize: 14,
      ),

      // Small secondary text
      bodySmall: TextStyle(
        color: Color(0xFFBDBDBD),
        fontSize: 12,
      ),

      // Main headings
      titleLarge: TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),

      // Secondary headings
      titleMedium: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),

      // Accent heading
      titleSmall: TextStyle(
        color: AppColors.gold,
        fontWeight: FontWeight.bold,
      ),

      // Display
      displayLarge: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),

      displayMedium: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),

      displaySmall: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),

      headlineLarge: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),

      headlineMedium: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),

      headlineSmall: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),

    // ============================================================
    // INPUT FIELDS
    // ============================================================

    inputDecorationTheme: const InputDecorationTheme(
      filled: true,

      // Admin card style
      fillColor: Color(0xFF1E1E1E),

      hintStyle: TextStyle(
        color: Colors.white54,
      ),

      labelStyle: TextStyle(
        color: Colors.white70,
      ),

      floatingLabelStyle: TextStyle(
        color: AppColors.gold,
      ),

      prefixIconColor: AppColors.gold,

      suffixIconColor: AppColors.gold,

      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(14),
        ),
        borderSide: BorderSide(
          color: Colors.white10,
        ),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(14),
        ),
        borderSide: BorderSide(
          color: Colors.white10,
          width: 1,
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(14),
        ),
        borderSide: BorderSide(
          color: AppColors.gold,
          width: 1.5,
        ),
      ),
    ),

    // ============================================================
    // CARD
    // ============================================================

    cardTheme: CardThemeData(
      color: const Color(0xFF1E1E1E),
      elevation: 4,
      shadowColor: Colors.black.withValues(alpha: 0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(
          color: Colors.white10,
          width: 1,
        ),
      ),
    ),

    // ============================================================
    // FILLED BUTTON
    // ============================================================

    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        // Admin dark mode accent
        backgroundColor: AppColors.gold,

        // Dark text on gold
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

        elevation: 0,
      ),
    ),

    // ============================================================
    // OUTLINED BUTTON
    // ============================================================

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.gold,
        side: const BorderSide(
          color: AppColors.gold,
          width: 1.5,
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    ),

    // ============================================================
    // TEXT BUTTON
    // ============================================================

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.gold,
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    ),

    // ============================================================
    // NAVIGATION BAR
    // ============================================================

    navigationBarTheme: NavigationBarThemeData(
      // Admin-style dark navigation
      backgroundColor: const Color(0xFF1E1E1E),

      // Selected item background
      indicatorColor: const Color(0xFF3A3027),

      elevation: 8,

      height: 75,

      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(
            WidgetState.selected,
          )) {
            return const TextStyle(
              color: AppColors.gold,
              fontWeight: FontWeight.bold,
            );
          }

          return const TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.w500,
          );
        },
      ),

      iconTheme: WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(
            WidgetState.selected,
          )) {
            return const IconThemeData(
              color: AppColors.gold,
            );
          }

          return const IconThemeData(
            color: Colors.white70,
          );
        },
      ),
    ),

    // ============================================================
    // BOTTOM NAVIGATION BAR
    // ============================================================

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1E1E1E),
      selectedItemColor: AppColors.gold,
      unselectedItemColor: Colors.white70,
      elevation: 8,
    ),

    // ============================================================
    // DIVIDER
    // ============================================================

    dividerColor: Colors.white10,

    // ============================================================
    // DIALOG
    // ============================================================

    dialogTheme: const DialogThemeData(
      backgroundColor: Color(0xFF1E1E1E),
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      contentTextStyle: TextStyle(
        color: Colors.white70,
        fontSize: 14,
      ),
    ),

    // ============================================================
    // BOTTOM SHEET
    // ============================================================

    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Color(0xFF1E1E1E),
      surfaceTintColor: Colors.transparent,
      modalBackgroundColor: Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
    ),

    // ============================================================
    // SNACKBAR
    // ============================================================

    snackBarTheme: const SnackBarThemeData(
      backgroundColor: Color(0xFF1E1E1E),
      contentTextStyle: TextStyle(
        color: Colors.white,
      ),
      actionTextColor: AppColors.gold,
      behavior: SnackBarBehavior.floating,
    ),

    // ============================================================
    // LIST TILE
    // ============================================================

    listTileTheme: const ListTileThemeData(
      textColor: Colors.white,
      iconColor: AppColors.gold,
      subtitleTextStyle: TextStyle(
        color: Colors.white70,
      ),
    ),

    // ============================================================
    // CHECKBOX
    // ============================================================

    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(
            WidgetState.selected,
          )) {
            return AppColors.gold;
          }

          return Colors.transparent;
        },
      ),
      checkColor: WidgetStateProperty.all(
        AppColors.brown,
      ),
    ),

    // ============================================================
    // SWITCH
    // ============================================================

    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(
            WidgetState.selected,
          )) {
            return AppColors.gold;
          }

          return Colors.white70;
        },
      ),
      trackColor: WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(
            WidgetState.selected,
          )) {
            return AppColors.gold.withValues(alpha: 0.35);
          }

          return Colors.white24;
        },
      ),
    ),

    // ============================================================
    // PROGRESS INDICATOR
    // ============================================================

    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.gold,
    ),

    // ============================================================
    // ICON THEME
    // ============================================================

    iconTheme: const IconThemeData(
      color: Colors.white70,
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ============================================================
// PROVIDERS
// ============================================================

import 'providers/favorite_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/user_theme_provider.dart';
import 'providers/admin_theme_provider.dart';

// ============================================================
// THEME + SESSION
// ============================================================

import 'core/theme/app_theme.dart';

// ============================================================
// AUTH / ONBOARDING
// ============================================================

import 'screens/splash/splash_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/auth/role_selection_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/admin_login_screen.dart';
import 'screens/auth/signup_screen.dart';

// ============================================================
// USER
// ============================================================

import 'screens/home/home_screen.dart';
import 'screens/categories/categories_screen.dart';
import 'screens/favorites/favorites_screen.dart';
import 'screens/cart/cart_screen.dart';
import 'screens/profile/profile_screen.dart';

// ============================================================
// ADMIN
// ============================================================

import 'admin/admin_dashboard.dart';

// ============================================================
// WIDGETS
// ============================================================

import 'widgets/bottom_nav.dart';

// ============================================================
// MAIN
// ============================================================

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        // ======================================================
        // FAVORITES
        // ======================================================

        ChangeNotifierProvider<FavoriteProvider>(
          create: (_) => FavoriteProvider(),
        ),

        // ======================================================
        // CART
        // ======================================================

        ChangeNotifierProvider<CartProvider>(
          create: (_) => CartProvider(),
        ),

        // ======================================================
        // USER THEME
        // ======================================================

        ChangeNotifierProvider<UserThemeProvider>(
          create: (_) => UserThemeProvider(),
        ),

        // ======================================================
        // ADMIN THEME
        // ======================================================

        ChangeNotifierProvider<AdminThemeProvider>(
          create: (_) => AdminThemeProvider(),
        ),
      ],

      // ========================================================
      // APP
      // ========================================================

      child: const MyApp(),
    ),
  );
}

// ============================================================
// MY APP
// ============================================================

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final userTheme = context.watch<UserThemeProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Divine Craving',

      // ======================================================
      // THEME
      // ======================================================

      theme: AppTheme.lightTheme,

      darkTheme: AppTheme.darkTheme,

      themeMode: userTheme.themeMode,

      // ======================================================
      // START SCREEN
      // ======================================================
      //
      // App launch par sabse pehle Splash Screen open hogi.
      //
      // ======================================================

      home: const SplashScreen(),

      // ======================================================
      // ROUTES
      // ======================================================

      routes: {
        // ONBOARDING
        '/onboarding': (_) => const OnboardingScreen(),

        // AUTH
        '/role-selection': (_) => const RoleSelectionScreen(),
        '/login': (_) => const LoginScreen(),
        '/signup': (_) => const SignupScreen(),
        '/admin-login': (_) => const AdminLoginScreen(),

        // USER HOME
        '/home': (_) => const MainShell(),

        // ADMIN
        '/admin-dashboard': (_) => const AdminDashboard(),
      },
    );
  }
}

// ============================================================
// MAIN SHELL
// ============================================================

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int currentIndex = 0;

  // ==========================================================
  // SCREENS
  // ==========================================================

  late final List<Widget> screens = [
    // HOME
    HomeScreen(
      onNavigation: _onNavigation,
    ),

    // CATEGORIES
    const CategoriesScreen(),

    // FAVORITES
    const FavoritesScreen(),

    // CART
    const CartScreen(),

    // PROFILE
    const ProfileScreen(),
  ];

  // ==========================================================
  // NAVIGATION
  // ==========================================================

  void _onNavigation(int index) {
    if (index < 0 || index >= screens.length) {
      return;
    }

    setState(() {
      currentIndex = index;
    });
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),

      // ======================================================
      // BOTTOM NAVIGATION
      // ======================================================

      bottomNavigationBar: BottomNav(
        currentIndex: currentIndex,
        onChanged: _onNavigation,
      ),
    );
  }
}
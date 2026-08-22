import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// PROVIDERS
import 'providers/favorite_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/user_theme_provider.dart';
import 'providers/admin_theme_provider.dart';

// THEME + SESSION
import 'core/theme/app_theme.dart';
import 'core/services/session_manager.dart';

// AUTH
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/auth/role_selection_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/admin_login_screen.dart';
import 'screens/auth/signup_screen.dart';

// USER
import 'screens/home/home_screen.dart';
import 'screens/categories/categories_screen.dart';
import 'screens/favorites/favorites_screen.dart';
import 'screens/cart/cart_screen.dart';
import 'screens/profile/profile_screen.dart';

// ADMIN
import 'admin/admin_dashboard.dart';

// WIDGETS
import 'widgets/bottom_nav.dart';

// ============================================================
// MAIN
// ============================================================

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => FavoriteProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AdminThemeProvider(),
        ),
      ],
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
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: userTheme.themeMode,
      home: const AppStartScreen(),
      routes: {
        '/onboarding': (_) => const OnboardingScreen(),
        '/role-selection': (_) => const RoleSelectionScreen(),
        '/login': (_) => const LoginScreen(),
        '/signup': (_) => const SignupScreen(),
        '/admin-login': (_) => const AdminLoginScreen(),
        '/home': (_) => const MainShell(),
        '/admin-dashboard': (_) => const AdminDashboard(),
      },
    );
  }
}

// ============================================================
// APP START SCREEN
// ============================================================

class AppStartScreen extends StatefulWidget {
  const AppStartScreen({super.key});

  @override
  State<AppStartScreen> createState() => _AppStartScreenState();
}

class _AppStartScreenState extends State<AppStartScreen> {
  @override
  void initState() {
    super.initState();

    _checkAppState();
  }

  Future<void> _checkAppState() async {
    final session = SessionManager.instance;

    final onboardingCompleted = await session.isOnboardingCompleted();

    final loggedIn = await session.isLoggedIn();

    if (!mounted) return;

    if (loggedIn) {
      Navigator.pushReplacementNamed(
        context,
        '/home',
      );

      return;
    }

    if (!onboardingCompleted) {
      Navigator.pushReplacementNamed(
        context,
        '/onboarding',
      );

      return;
    }

    Navigator.pushReplacementNamed(
      context,
      '/role-selection',
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
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

  late final List<Widget> screens = [
    HomeScreen(
      onNavigation: _onNavigation,
    ),
    const CategoriesScreen(),
    const FavoritesScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];

  void _onNavigation(int index) {
    if (index < 0 || index >= screens.length) {
      return;
    }

    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: currentIndex,
        onChanged: _onNavigation,
      ),
    );
  }
}

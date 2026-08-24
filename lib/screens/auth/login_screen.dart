import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_colors.dart';
import '../../core/utils/responsive.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // ============================================================
  // LOGIN
  // ============================================================

  Future<void> login() async {
    final String email = emailController.text.trim().toLowerCase();

    final String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter email and password',
          ),
        ),
      );
      return;
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // ============================================================
    // GET SAVED ACCOUNT
    // ============================================================

    final String? savedEmail = prefs.getString('account_email');

    final String? savedPassword = prefs.getString('account_password');

    if (savedEmail == null || savedPassword == null) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Account not found. Please create an account first.',
          ),
        ),
      );

      return;
    }

    // ============================================================
    // CHECK EMAIL
    // ============================================================

    if (email != savedEmail.toLowerCase()) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No account found with this email.',
          ),
        ),
      );

      return;
    }

    // ============================================================
    // CHECK PASSWORD
    // ============================================================

    if (password != savedPassword) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Incorrect password.',
          ),
        ),
      );

      return;
    }

    // ============================================================
    // SAVE CURRENT USER
    // ============================================================

    await prefs.setString(
      'current_user_email',
      savedEmail,
    );

    await prefs.setBool(
      'is_logged_in',
      true,
    );

    if (!mounted) return;

    Navigator.pushReplacementNamed(
      context,
      '/home',
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final bool isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 24 : 18,
              vertical: 25,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 500,
              ),
              child: Container(
                padding: isDesktop
                    ? const EdgeInsets.all(40)
                    : const EdgeInsets.all(8),
                decoration: isDesktop
                    ? BoxDecoration(
                        color: isDark ? const Color(0xFF261D19) : Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF3E2D25)
                              : const Color(0xFFF0E2D6),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.07),
                            blurRadius: 30,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      )
                    : null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ======================================================
                    // DIVINE CRAVING LOGO
                    // ======================================================

                    Center(
                      child: Column(
                        children: [
                          // ==================================================
                          // PERFECT CIRCLE LOGO
                          // ==================================================

                          SizedBox(
                            width: 100,
                            height: 100,
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/divine_craving_logo.png',

                                width: 100,
                                height: 100,

                                fit: BoxFit.cover,

                                alignment: Alignment.center,

                                // =================================================
                                // FALLBACK
                                // =================================================

                                errorBuilder: (
                                  context,
                                  error,
                                  stackTrace,
                                ) {
                                  return Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: AppColors.brown,
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: Alignment.center,
                                    child: const Icon(
                                      Icons.cake_rounded,
                                      color: AppColors.gold,
                                      size: 48,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),

                          const SizedBox(height: 18),

                          // ==================================================
                          // APP NAME
                          // ==================================================

                          Text(
                            'Divine Craving',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isDark ? Colors.white : AppColors.brown,
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),

                          const SizedBox(height: 5),

                          Text(
                            'CAKES MADE WITH LOVE',
                            style: TextStyle(
                              color: AppColors.gold,
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 42),

                    // ======================================================
                    // WELCOME
                    // ======================================================

                    Text(
                      'Welcome Back! 👋',
                      style: TextStyle(
                        color: isDark ? Colors.white : AppColors.brown,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Login to continue your sweet journey.',
                      style: TextStyle(
                        color: isDark ? Colors.white60 : AppColors.grey,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // ======================================================
                    // EMAIL
                    // ======================================================

                    Text(
                      'Email Address',
                      style: TextStyle(
                        color: isDark ? Colors.white : AppColors.brown,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'Enter your email',
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: AppColors.brown,
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // ======================================================
                    // PASSWORD
                    // ======================================================

                    Text(
                      'Password',
                      style: TextStyle(
                        color: isDark ? Colors.white : AppColors.brown,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      controller: passwordController,
                      obscureText: obscurePassword,
                      decoration: InputDecoration(
                        hintText: 'Enter your password',
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: AppColors.brown,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.brown,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 5),

                    // ======================================================
                    // FORGOT PASSWORD
                    // ======================================================

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: AppColors.gold,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ======================================================
                    // LOGIN BUTTON
                    // ======================================================

                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: FilledButton(
                        onPressed: login,
                        child: const Text(
                          'LOGIN',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // ======================================================
                    // OR
                    // ======================================================

                    Row(
                      children: [
                        const Expanded(
                          child: Divider(
                            color: AppColors.peach,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                          ),
                          child: Text(
                            'OR',
                            style: TextStyle(
                              color: isDark ? Colors.white54 : AppColors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Divider(
                            color: AppColors.peach,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // ======================================================
                    // GOOGLE
                    // ======================================================

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.g_mobiledata,
                          size: 28,
                          color: AppColors.brown,
                        ),
                        label: Text(
                          'Continue with Google',
                          style: TextStyle(
                            color: isDark ? Colors.white : AppColors.brown,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // ======================================================
                    // SIGN UP
                    // ======================================================

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            "Don't have an account?",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: isDark ? Colors.white60 : AppColors.grey,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SignupScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              color: AppColors.brown,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

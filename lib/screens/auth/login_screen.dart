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
          content: Text('Please enter email and password'),
        ),
      );
      return;
    }

    final SharedPreferences prefs =
        await SharedPreferences.getInstance();

    // ============================================================
    // CHECK ACCOUNT
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

    if (email != savedEmail) {
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
    // SAVE CURRENT LOGGED-IN USER
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

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor,

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 500,
              ),
              child: Container(
                padding: Responsive.isDesktop(context)
                    ? const EdgeInsets.all(40)
                    : const EdgeInsets.all(5),
                decoration: Responsive.isDesktop(context)
                    ? BoxDecoration(
                        color: isDark
                            ? const Color(0xFF261D19)
                            : Colors.white,
                        borderRadius:
                            BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withOpacity(0.08),
                            blurRadius: 30,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      )
                    : null,
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    // =========================
                    // LOGO
                    // =========================

                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              color: AppColors.brown,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.brown
                                      .withOpacity(0.20),
                                  blurRadius: 20,
                                  offset:
                                      const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                'D',
                                style: TextStyle(
                                  color: AppColors.gold,
                                  fontSize: 48,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 14),

                          Text(
                            'DIVINE',
                            style: TextStyle(
                              color: isDark
                                  ? Colors.white
                                  : AppColors.brown,
                              fontSize: 28,
                              fontWeight:
                                  FontWeight.bold,
                              letterSpacing: 5,
                            ),
                          ),

                          Text(
                            'CRAVING',
                            style: TextStyle(
                              color: isDark
                                  ? Colors.white70
                                  : AppColors.brown,
                              fontSize: 17,
                              fontWeight:
                                  FontWeight.w500,
                              letterSpacing: 4,
                            ),
                          ),

                          const SizedBox(height: 5),

                          const Text(
                            'CAKES MADE WITH LOVE',
                            style: TextStyle(
                              color: AppColors.gold,
                              fontSize: 9,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 45),

                    // =========================
                    // WELCOME
                    // =========================

                    Text(
                      'Welcome Back! 👋',
                      style: TextStyle(
                        color: isDark
                            ? Colors.white
                            : AppColors.brown,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Login to continue your sweet journey.',
                      style: TextStyle(
                        color: isDark
                            ? Colors.white60
                            : AppColors.grey,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // =========================
                    // EMAIL
                    // =========================

                    Text(
                      'Email Address',
                      style: TextStyle(
                        color: isDark
                            ? Colors.white
                            : AppColors.brown,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      controller: emailController,
                      keyboardType:
                          TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'Enter your email',
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: AppColors.brown,
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // =========================
                    // PASSWORD
                    // =========================

                    Text(
                      'Password',
                      style: TextStyle(
                        color: isDark
                            ? Colors.white
                            : AppColors.brown,
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
                              obscurePassword =
                                  !obscurePassword;
                            });
                          },
                          icon: Icon(
                            obscurePassword
                                ? Icons
                                    .visibility_off_outlined
                                : Icons
                                    .visibility_outlined,
                            color: AppColors.brown,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Align(
                      alignment:
                          Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: AppColors.gold,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // =========================
                    // LOGIN
                    // =========================

                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: FilledButton(
                        onPressed: login,
                        child: const Text(
                          'LOGIN',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight:
                                FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    Row(
                      children: [
                        const Expanded(
                          child: Divider(
                            color: AppColors.peach,
                          ),
                        ),

                        Padding(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 12,
                          ),
                          child: Text(
                            'OR',
                            style: TextStyle(
                              color: isDark
                                  ? Colors.white54
                                  : AppColors.grey,
                              fontSize: 12,
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

                    // =========================
                    // GOOGLE
                    // =========================

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
                            color: isDark
                                ? Colors.white
                                : AppColors.brown,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // =========================
                    // SIGN UP
                    // =========================

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(
                            color: isDark
                                ? Colors.white60
                                : AppColors.grey,
                          ),
                        ),

                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const SignupScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              color: AppColors.brown,
                              fontWeight:
                                  FontWeight.bold,
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
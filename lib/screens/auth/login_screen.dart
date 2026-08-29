import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool obscurePassword = true;
  bool isLoading = false;
  bool isResettingPassword = false;

  // ============================================================
  // EMAIL VALIDATION
  // ============================================================

bool _isValidEmail(String email) {
  final emailRegex = RegExp(
    r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@'
    r'[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?'
    r'(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)+$',
  );

  return emailRegex.hasMatch(email);
}

  // ============================================================
  // SHOW MESSAGE
  // ============================================================

  void _showMessage(
    String message, {
    bool isError = true,
  }) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade700,
        ),
      );
  }

  // ============================================================
  // FIREBASE ERROR MESSAGE
  // ============================================================

  String _firebaseErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Please enter a valid email address.';

      case 'user-not-found':
        return 'No account found with this email.';

      case 'wrong-password':
        return 'Incorrect password.';

      case 'invalid-credential':
        return 'Incorrect email or password.';

      case 'user-disabled':
        return 'This account has been disabled.';

      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';

      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';

      default:
        return e.message ?? 'Login failed. Please try again.';
    }
  }

  // ============================================================
  // LOGIN
  // ============================================================

  Future<void> login() async {
    // Prevent multiple clicks.
    if (isLoading) return;

    final String email = emailController.text.trim().toLowerCase();
    final String password = passwordController.text;

    // ==========================================================
    // EMAIL EMPTY
    // ==========================================================

    if (email.isEmpty) {
      _showMessage('Please enter your email address.');
      return;
    }

    // ==========================================================
    // EMAIL FORMAT
    // ==========================================================

    if (!_isValidEmail(email)) {
      _showMessage('Please enter a valid email address.');
      return;
    }

    // ==========================================================
    // PASSWORD EMPTY
    // ==========================================================

    if (password.isEmpty) {
      _showMessage('Please enter your password.');
      return;
    }

    // ==========================================================
    // PASSWORD LENGTH
    // ==========================================================

    if (password.length < 6) {
      _showMessage(
        'Password must be at least 6 characters.',
      );
      return;
    }

    // ==========================================================
    // START LOADING
    // ==========================================================

    setState(() {
      isLoading = true;
    });

    try {
      // ========================================================
      // FIREBASE LOGIN
      // ========================================================

      final UserCredential credential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = credential.user;

      if (user == null) {
        _showMessage('Login failed. Please try again.');
        return;
      }

      // ========================================================
      // SUCCESS
      // ========================================================

      if (!mounted) return;

      _showMessage(
        'Login successful! Welcome back.',
        isError: false,
      );

      // Small delay only for the success message to be visible.
      await Future.delayed(
        const Duration(milliseconds: 300),
      );

      if (!mounted) return;

      Navigator.pushReplacementNamed(
        context,
        '/home',
      );
    } on FirebaseAuthException catch (e) {
      _showMessage(
        _firebaseErrorMessage(e),
      );
    } catch (e) {
      _showMessage(
        'Something went wrong. Please try again.',
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // ============================================================
  // FORGOT PASSWORD
  // ============================================================

  Future<void> resetPassword() async {
    if (isResettingPassword) return;

    final String email = emailController.text.trim().toLowerCase();

    // ==========================================================
    // EMAIL REQUIRED
    // ==========================================================

    if (email.isEmpty) {
      _showMessage(
        'Enter your email address first.',
      );
      return;
    }

    // ==========================================================
    // EMAIL FORMAT
    // ==========================================================

    if (!_isValidEmail(email)) {
      _showMessage(
        'Please enter a valid email address.',
      );
      return;
    }

    setState(() {
      isResettingPassword = true;
    });

    try {
      // ========================================================
      // SEND FIREBASE RESET EMAIL
      // ========================================================

      await _auth.sendPasswordResetEmail(
        email: email,
      );

      _showMessage(
        'Password reset email sent. Check your inbox.',
        isError: false,
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          _showMessage(
            'No account found with this email.',
          );
          break;

        case 'invalid-email':
          _showMessage(
            'Please enter a valid email address.',
          );
          break;

        case 'network-request-failed':
          _showMessage(
            'Network error. Please check your internet connection.',
          );
          break;

        case 'too-many-requests':
          _showMessage(
            'Too many requests. Please try again later.',
          );
          break;

        default:
          _showMessage(
            e.message ?? 'Unable to send reset email.',
          );
      }
    } catch (e) {
      _showMessage(
        'Something went wrong. Please try again.',
      );
    } finally {
      if (mounted) {
        setState(() {
          isResettingPassword = false;
        });
      }
    }
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final bool isDark =
        Theme.of(context).brightness == Brightness.dark;

    final bool isDesktop =
        Responsive.isDesktop(context);

    return Scaffold(
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor,

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
                        color: isDark
                            ? const Color(0xFF261D19)
                            : Colors.white,

                        borderRadius:
                            BorderRadius.circular(28),

                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF3E2D25)
                              : const Color(0xFFF0E2D6),
                        ),

                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.black.withOpacity(0.07),
                            blurRadius: 30,
                            offset:
                                const Offset(0, 12),
                          ),
                        ],
                      )
                    : null,

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    // ==================================================
                    // LOGO
                    // ==================================================

                    Center(
                      child: Column(
                        children: [

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

                                errorBuilder:
                                    (
                                      context,
                                      error,
                                      stackTrace,
                                    ) {
                                  return Container(
                                    width: 100,
                                    height: 100,

                                    decoration:
                                        const BoxDecoration(
                                      color:
                                          AppColors.brown,
                                      shape:
                                          BoxShape.circle,
                                    ),

                                    alignment:
                                        Alignment.center,

                                    child:
                                        const Icon(
                                      Icons.cake_rounded,
                                      color:
                                          AppColors.gold,
                                      size: 48,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),

                          const SizedBox(height: 18),

                          Text(
                            'Divine Craving',
                            textAlign:
                                TextAlign.center,

                            style: TextStyle(
                              color: isDark
                                  ? Colors.white
                                  : AppColors.brown,

                              fontSize: 28,
                              fontWeight:
                                  FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),

                          const SizedBox(height: 5),

                          const Text(
                            'CAKES MADE WITH LOVE',
                            style: TextStyle(
                              color:
                                  AppColors.gold,
                              fontSize: 9,
                              fontWeight:
                                  FontWeight.w600,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 42),

                    // ==================================================
                    // WELCOME
                    // ==================================================

                    Text(
                      'Welcome Back! 👋',
                      style: TextStyle(
                        color: isDark
                            ? Colors.white
                            : AppColors.brown,
                        fontSize: 28,
                        fontWeight:
                            FontWeight.bold,
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

                    // ==================================================
                    // EMAIL
                    // ==================================================

                    Text(
                      'Email Address',
                      style: TextStyle(
                        color: isDark
                            ? Colors.white
                            : AppColors.brown,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      controller:
                          emailController,

                      keyboardType:
                          TextInputType.emailAddress,

                      textInputAction:
                          TextInputAction.next,

                      autocorrect: false,

                      decoration:
                          const InputDecoration(
                        hintText:
                            'Enter your email',

                        prefixIcon:
                            Icon(
                          Icons.email_outlined,
                          color:
                              AppColors.brown,
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // ==================================================
                    // PASSWORD
                    // ==================================================

                    Text(
                      'Password',
                      style: TextStyle(
                        color: isDark
                            ? Colors.white
                            : AppColors.brown,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      controller:
                          passwordController,

                      obscureText:
                          obscurePassword,

                      textInputAction:
                          TextInputAction.done,

                      onSubmitted: (_) {
                        if (!isLoading) {
                          login();
                        }
                      },

                      decoration:
                          InputDecoration(
                        hintText:
                            'Enter your password',

                        prefixIcon:
                            const Icon(
                          Icons.lock_outline,
                          color:
                              AppColors.brown,
                        ),

                        suffixIcon:
                            IconButton(
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

                            color:
                                AppColors.brown,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 5),

                    // ==================================================
                    // FORGOT PASSWORD
                    // ==================================================

                    Align(
                      alignment:
                          Alignment.centerRight,

                      child: TextButton(
                        onPressed:
                            isResettingPassword
                                ? null
                                : resetPassword,

                        child:
                            isResettingPassword
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,

                                    child:
                                        CircularProgressIndicator(
                                      strokeWidth:
                                          2,
                                    ),
                                  )
                                : const Text(
                                    'Forgot Password?',
                                    style:
                                        TextStyle(
                                      color:
                                          AppColors.gold,
                                      fontWeight:
                                          FontWeight.w600,
                                    ),
                                  ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ==================================================
                    // LOGIN BUTTON
                    // ==================================================

                    SizedBox(
                      width:
                          double.infinity,

                      height: 55,

                      child: FilledButton(
                        onPressed:
                            isLoading
                                ? null
                                : login,

                        child: isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,

                                child:
                                    CircularProgressIndicator(
                                  strokeWidth:
                                      2.5,
                                  color:
                                      Colors.white,
                                ),
                              )
                            : const Text(
                                'LOGIN',
                                style:
                                    TextStyle(
                                  fontSize: 15,
                                  fontWeight:
                                      FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // ==================================================
                    // OR
                    // ==================================================

                    Row(
                      children: [

                        const Expanded(
                          child: Divider(
                            color:
                                AppColors.peach,
                          ),
                        ),

                        Padding(
                          padding:
                              const EdgeInsets
                                  .symmetric(
                            horizontal: 12,
                          ),

                          child: Text(
                            'OR',
                            style: TextStyle(
                              color: isDark
                                  ? Colors.white54
                                  : AppColors.grey,

                              fontSize: 12,
                              fontWeight:
                                  FontWeight.w600,
                            ),
                          ),
                        ),

                        const Expanded(
                          child: Divider(
                            color:
                                AppColors.peach,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // ==================================================
                    // GOOGLE
                    // ==================================================

                    SizedBox(
                      width:
                          double.infinity,

                      height: 52,

                      child:
                          OutlinedButton.icon(
                        onPressed: () {
                          _showMessage(
                            'Google Sign-In will be connected separately.',
                            isError: false,
                          );
                        },

                        icon:
                            const Icon(
                          Icons.g_mobiledata,
                          size: 28,
                          color:
                              AppColors.brown,
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

                    // ==================================================
                    // SIGN UP
                    // ==================================================

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,

                      children: [

                        Flexible(
                          child: Text(
                            "Don't have an account?",

                            overflow:
                                TextOverflow.ellipsis,

                            style: TextStyle(
                              color: isDark
                                  ? Colors.white60
                                  : AppColors.grey,
                            ),
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

                          child:
                              const Text(
                            'Sign Up',

                            style:
                                TextStyle(
                              color:
                                  AppColors.brown,
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
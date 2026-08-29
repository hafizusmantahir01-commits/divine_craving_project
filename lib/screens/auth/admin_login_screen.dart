import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../admin/admin_dashboard.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  bool obscurePassword = true;
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // ============================================================
  // ADMIN LOGIN
  // ============================================================

  Future<void> adminLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (isLoading) {
      return;
    }

    final String email =
        emailController.text.trim();

    final String password =
        passwordController.text;

    setState(() {
      isLoading = true;
    });

    try {
      // ========================================================
      // FIREBASE AUTHENTICATION
      // ========================================================

      final UserCredential credential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = credential.user;

      if (user == null) {
        throw FirebaseAuthException(
          code: 'user-not-found',
        );
      }

      // ========================================================
      // CHECK ADMIN ROLE FROM FIRESTORE
      // ========================================================

      final DocumentSnapshot<Map<String, dynamic>>
          userDocument = await _firestore
              .collection('users')
              .doc(user.uid)
              .get();

      if (!userDocument.exists) {
        await _auth.signOut();

        if (!mounted) return;

        _showError(
          'Admin account information was not found.',
        );

        return;
      }

      final Map<String, dynamic> userData =
          userDocument.data() ?? {};

      final String role =
          (userData['role'] ?? '')
              .toString()
              .toLowerCase()
              .trim();

      // ========================================================
      // ADMIN ROLE CHECK
      // ========================================================

      if (role != 'admin') {
        await _auth.signOut();

        if (!mounted) return;

        _showError(
          'Access denied. This account is not an admin.',
        );

        return;
      }

      // ========================================================
      // ADMIN LOGIN SUCCESS
      // ========================================================

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const AdminDashboard(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      String message =
          'Unable to login. Please try again.';

      switch (e.code) {
        case 'invalid-credential':
          message =
              'Invalid admin email or password.';
          break;

        case 'user-not-found':
          message =
              'No account found with this email.';
          break;

        case 'wrong-password':
          message =
              'Incorrect password.';
          break;

        case 'invalid-email':
          message =
              'Please enter a valid email address.';
          break;

        case 'user-disabled':
          message =
              'This account has been disabled.';
          break;

        case 'too-many-requests':
          message =
              'Too many login attempts. Please try again later.';
          break;

        case 'network-request-failed':
          message =
              'Network error. Please check your internet connection.';
          break;

        default:
          message =
              'Login failed. Please check your email and password.';
      }

      _showError(message);
    } on FirebaseException catch (e) {
      if (!mounted) return;

      if (e.code == 'permission-denied') {
        _showError(
          'Permission denied while checking admin account.',
        );
      } else {
        _showError(
          'Could not verify admin account.',
        );
      }
    } catch (e) {
      if (!mounted) return;

      _showError(
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
  // ERROR SNACKBAR
  // ============================================================

  void _showError(String message) {
    ScaffoldMessenger.of(context)
        .hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(message),
            ),
          ],
        ),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // ============================================================
  // INPUT DECORATION
  // ============================================================

  InputDecoration inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Colors.grey,
        fontSize: 15,
        fontWeight: FontWeight.w400,
      ),
      prefixIcon: Icon(
        icon,
        color: AppColors.brown,
        size: 22,
      ),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 17,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: AppColors.gold,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 2,
        ),
      ),
      errorStyle: const TextStyle(
        fontSize: 12,
        color: Colors.red,
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final Size screenSize =
        MediaQuery.of(context).size;

    final bool isLargeScreen =
        screenSize.width > 700;

    return Scaffold(
      backgroundColor:
          const Color(0xFFF8F4EF),

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: AppColors.brown,
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
          ),
          onPressed: isLoading
              ? null
              : () {
                  Navigator.pop(context);
                },
        ),
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal:
                  isLargeScreen ? 40 : 24,
              vertical: 20,
            ),
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(
                maxWidth: 500,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    // ==================================================
                    // LOGO
                    // ==================================================

                    Center(
                      child: ClipOval(
                        child: SizedBox(
                          width: 110,
                          height: 110,
                          child: Image.asset(
                            'assets/images/divine_craving_logo.png',
                            width: 110,
                            height: 110,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (
                              context,
                              error,
                              stackTrace,
                            ) {
                              return Container(
                                width: 110,
                                height: 110,
                                decoration:
                                    const BoxDecoration(
                                  color:
                                      AppColors.peach,
                                  shape:
                                      BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons
                                      .admin_panel_settings,
                                  size: 55,
                                  color:
                                      AppColors.brown,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // ==================================================
                    // TITLE
                    // ==================================================

                    const Center(
                      child: Text(
                        'Admin Login',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight:
                              FontWeight.bold,
                          color:
                              AppColors.brown,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Center(
                      child: Text(
                        'Login to manage Divine Craving',
                        textAlign:
                            TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          height: 1.5,
                        ),
                      ),
                    ),

                    const SizedBox(height: 35),

                    // ==================================================
                    // LOGIN CARD
                    // ==================================================

                    Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsets.all(22),
                      decoration:
                          BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(
                          24,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withOpacity(0.05),
                            blurRadius: 20,
                            offset:
                                const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [

                          // ==========================================
                          // EMAIL LABEL
                          // ==========================================

                          const Text(
                            'Admin Email',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight:
                                  FontWeight.bold,
                              color:
                                  AppColors.brown,
                            ),
                          ),

                          const SizedBox(height: 8),

                          // ==========================================
                          // EMAIL FIELD
                          // ==========================================

                          TextFormField(
                            controller:
                                emailController,
                            keyboardType:
                                TextInputType
                                    .emailAddress,
                            textInputAction:
                                TextInputAction.next,
                            enabled: !isLoading,
                            style:
                                const TextStyle(
                              color:
                                  AppColors.brown,
                              fontSize: 16,
                              fontWeight:
                                  FontWeight.w500,
                            ),
                            cursorColor:
                                AppColors.brown,
                            decoration:
                                inputDecoration(
                              hint:
                                  'Enter admin email',
                              icon:
                                  Icons
                                      .email_outlined,
                            ),
                            validator:
                                (value) {
                              if (value ==
                                      null ||
                                  value
                                      .trim()
                                      .isEmpty) {
                                return 'Please enter admin email';
                              }

                              if (!value
                                  .contains('@')) {
                                return 'Please enter a valid email';
                              }

                              return null;
                            },
                          ),

                          const SizedBox(height: 20),

                          // ==========================================
                          // PASSWORD LABEL
                          // ==========================================

                          const Text(
                            'Password',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight:
                                  FontWeight.bold,
                              color:
                                  AppColors.brown,
                            ),
                          ),

                          const SizedBox(height: 8),

                          // ==========================================
                          // PASSWORD FIELD
                          // ==========================================

                          TextFormField(
                            controller:
                                passwordController,
                            obscureText:
                                obscurePassword,
                            textInputAction:
                                TextInputAction.done,
                            enabled: !isLoading,
                            style:
                                const TextStyle(
                              color:
                                  AppColors.brown,
                              fontSize: 16,
                              fontWeight:
                                  FontWeight.w500,
                            ),
                            cursorColor:
                                AppColors.brown,
                            onFieldSubmitted:
                                (_) {
                              adminLogin();
                            },
                            decoration:
                                inputDecoration(
                              hint:
                                  'Enter admin password',
                              icon:
                                  Icons
                                      .lock_outline,
                              suffixIcon:
                                  IconButton(
                                tooltip:
                                    obscurePassword
                                        ? 'Show password'
                                        : 'Hide password',
                                onPressed:
                                    isLoading
                                        ? null
                                        : () {
                                            setState(
                                              () {
                                                obscurePassword =
                                                    !obscurePassword;
                                              },
                                            );
                                          },
                                icon: Icon(
                                  obscurePassword
                                      ? Icons
                                          .visibility_outlined
                                      : Icons
                                          .visibility_off_outlined,
                                  color:
                                      AppColors
                                          .brown,
                                ),
                              ),
                            ),
                            validator:
                                (value) {
                              if (value ==
                                      null ||
                                  value.isEmpty) {
                                return 'Please enter password';
                              }

                              return null;
                            },
                          ),

                          const SizedBox(height: 28),

                          // ==========================================
                          // LOGIN BUTTON
                          // ==========================================

                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child:
                                ElevatedButton.icon(
                              onPressed:
                                  isLoading
                                      ? null
                                      : adminLogin,
                              icon: isLoading
                                  ? const SizedBox(
                                      width: 21,
                                      height: 21,
                                      child:
                                          CircularProgressIndicator(
                                        strokeWidth:
                                            2.5,
                                        color:
                                            Colors.white,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.login,
                                      size: 21,
                                    ),
                              label: Text(
                                isLoading
                                    ? 'LOGGING IN...'
                                    : 'ADMIN LOGIN',
                                style:
                                    const TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                  letterSpacing:
                                      0.5,
                                ),
                              ),
                              style:
                                  ElevatedButton
                                      .styleFrom(
                                backgroundColor:
                                    AppColors.brown,
                                foregroundColor:
                                    Colors.white,
                                disabledBackgroundColor:
                                    AppColors.brown
                                        .withOpacity(
                                  0.6,
                                ),
                                disabledForegroundColor:
                                    Colors.white,
                                elevation: 0,
                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                    15,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 22),

                    // ==================================================
                    // DEMO ACCOUNT
                    // ==================================================

                    Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsets.all(16),
                      decoration:
                          BoxDecoration(
                        color: AppColors.peach
                            .withOpacity(0.45),
                        borderRadius:
                            BorderRadius.circular(
                          18,
                        ),
                        border: Border.all(
                          color: AppColors.peach
                              .withOpacity(0.8),
                        ),
                      ),
                      child: Column(
                        children: [
                          const Row(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .center,
                            children: [
                              Icon(
                                Icons
                                    .info_outline,
                                size: 18,
                                color:
                                    AppColors
                                        .brown,
                              ),
                              SizedBox(width: 7),
                              Text(
                                'Demo Admin Account',
                                style:
                                    TextStyle(
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                  color:
                                      AppColors
                                          .brown,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          const Text(
                            'admin@divinecraving.com',
                            style: TextStyle(
                              color:
                                  AppColors.brown,
                              fontSize: 14,
                            ),
                          ),

                          const SizedBox(height: 3),

                          const Text(
                            'Password: admin123',
                            style: TextStyle(
                              color:
                                  AppColors.brown,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ==================================================
                    // FOOTER
                    // ==================================================

                    const Center(
                      child: Text(
                        'Divine Craving • Admin Panel',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
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
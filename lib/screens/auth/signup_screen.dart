import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // ============================================================
  // CONTROLLERS
  // ============================================================

  final TextEditingController nameController =
      TextEditingController();

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController phoneController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  // ============================================================
  // FIREBASE
  // ============================================================

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  // ============================================================
  // VARIABLES
  // ============================================================

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool agreeTerms = false;
  bool isLoading = false;

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }

  // ============================================================
  // NAME VALIDATION
  // ============================================================

  bool _isValidName(String name) {
    final RegExp nameRegex = RegExp(
      r"^[a-zA-Z]+(?:[ '-][a-zA-Z]+)*$",
    );

    return nameRegex.hasMatch(name) &&
        name.length >= 2;
  }

  // ============================================================
  // EMAIL VALIDATION
  // ============================================================

  bool _isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@'
      r'[a-zA-Z0-9]'
      r'(?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?'
      r'(?:\.'
      r'[a-zA-Z0-9]'
      r'(?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?'
      r')+$',
    );

    return emailRegex.hasMatch(email);
  }

  // ============================================================
  // PHONE VALIDATION
  // ============================================================

  bool _isValidPhone(String phone) {
    final String cleanedPhone =
        phone.replaceAll(RegExp(r'[\s-]'), '');

    return RegExp(
      r'^(03\d{9}|\+923\d{9})$',
    ).hasMatch(cleanedPhone);
  }

  // ============================================================
  // PASSWORD VALIDATION
  // ============================================================
  //
  // ONLY REQUIREMENT:
  // Password must contain at least 8 characters.
  //
  // Examples of valid passwords:
  //
  // 12345678
  // password
  // Password
  // 1234abcd
  // abcdefgh
  //
  // NO uppercase requirement
  // NO lowercase requirement
  // NO number requirement
  // NO special character requirement
  // ============================================================

  String? _passwordError(String password) {
    if (password.isEmpty) {
      return 'Please enter a password with at least 8 characters.';
    }

    if (password.length < 8) {
      return 'Password must be at least 8 characters.';
    }

    return null;
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
          backgroundColor: isError
              ? Colors.red.shade700
              : Colors.green.shade700,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 3),
        ),
      );
  }

  // ============================================================
  // FIREBASE AUTH ERROR
  // ============================================================

  String _firebaseAuthError(
    FirebaseAuthException e,
  ) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'An account already exists with this email.';

      case 'invalid-email':
        return 'Please enter a valid email address.';

      case 'weak-password':
        return 'Password must be at least 8 characters.';

      case 'operation-not-allowed':
        return 'Email/password authentication is not enabled in Firebase.';

      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';

      case 'too-many-requests':
        return 'Too many requests. Please try again later.';

      case 'user-disabled':
        return 'This account has been disabled.';

      default:
        return e.message ??
            'Unable to create account. Please try again.';
    }
  }

  // ============================================================
  // FIRESTORE ERROR
  // ============================================================

  String _firestoreError(
    FirebaseException e,
  ) {
    switch (e.code) {
      case 'permission-denied':
        return 'Account created, but Firestore permission was denied. Check your Firestore security rules.';

      case 'unavailable':
        return 'Firestore is temporarily unavailable. Please try again.';

      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';

      default:
        return e.message ??
            'Unable to save your profile.';
    }
  }

  // ============================================================
  // SIGN UP
  // ============================================================

 Future<void> signup() async {
  if (isLoading) return;

  FocusScope.of(context).unfocus();

  final String name = nameController.text.trim();
  final String email = emailController.text.trim().toLowerCase();
  final String phone = phoneController.text.trim();
  final String password = passwordController.text;
  final String confirmPassword = confirmPasswordController.text;

  // ============================================================
  // NAME
  // ============================================================

  if (name.isEmpty) {
    _showMessage('Please enter your full name.');
    return;
  }

  if (!_isValidName(name)) {
    _showMessage(
      'Please enter a valid name using letters only.',
    );
    return;
  }

  // ============================================================
  // EMAIL
  // ============================================================

  if (email.isEmpty) {
    _showMessage('Please enter your email address.');
    return;
  }

  if (!_isValidEmail(email)) {
    _showMessage('Please enter a valid email address.');
    return;
  }

  // ============================================================
  // PHONE
  // ============================================================

  if (phone.isEmpty) {
    _showMessage('Please enter your phone number.');
    return;
  }

  if (!_isValidPhone(phone)) {
    _showMessage(
      'Enter a valid Pakistani phone number, e.g. 03001234567.',
    );
    return;
  }

  // ============================================================
  // PASSWORD
  // ============================================================

  final String? passwordError = _passwordError(password);

  if (passwordError != null) {
    _showMessage(passwordError);
    return;
  }

  // ============================================================
  // CONFIRM PASSWORD
  // ============================================================

  if (confirmPassword.isEmpty) {
    _showMessage('Please confirm your password.');
    return;
  }

  if (password != confirmPassword) {
    _showMessage('Passwords do not match.');
    return;
  }

  // ============================================================
  // TERMS
  // ============================================================

  if (!agreeTerms) {
    _showMessage(
      'Please agree to Terms & Conditions and Privacy Policy.',
    );
    return;
  }

  // ============================================================
  // LOADING
  // ============================================================

  setState(() {
    isLoading = true;
  });

  try {
    // ==========================================================
    // FIREBASE AUTH
    // ==========================================================

    debugPrint('STEP 1: Creating Firebase account...');
    debugPrint('EMAIL: $email');
    debugPrint('PASSWORD LENGTH: ${password.length}');

    final UserCredential credential =
        await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final User? user = credential.user;

    if (user == null) {
      _showMessage(
        'Firebase account could not be created.',
      );
      return;
    }

    debugPrint(
      'STEP 2: Firebase account created. UID: ${user.uid}',
    );

    // ==========================================================
    // UPDATE DISPLAY NAME
    // ==========================================================

    await user.updateDisplayName(name);

    debugPrint('STEP 3: Display name updated.');

    // ==========================================================
    // SAVE TO FIRESTORE
    // ==========================================================

    debugPrint('STEP 4: Saving user to Firestore...');

    await _firestore
        .collection('users')
        .doc(user.uid)
        .set({
      'uid': user.uid,
      'name': name,
      'email': email,
      'phone': phone,
      'provider': 'email',
      'createdAt': FieldValue.serverTimestamp(),
    });

    debugPrint('STEP 5: Firestore profile saved.');

    // ==========================================================
    // SUCCESS
    // ==========================================================

    if (!mounted) return;

    _showMessage(
      'Account created successfully!',
      isError: false,
    );

    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    if (!mounted) return;

    Navigator.pushReplacementNamed(
      context,
      '/home',
    );
  }

  // ==========================================================
  // FIREBASE AUTH ERROR
  // ==========================================================

  on FirebaseAuthException catch (e) {
    debugPrint('====================================');
    debugPrint('FIREBASE AUTH ERROR');
    debugPrint('CODE: ${e.code}');
    debugPrint('MESSAGE: ${e.message}');
    debugPrint('====================================');

    String message;

    switch (e.code) {
      case 'email-already-in-use':
        message =
            'An account already exists with this email.';
        break;

      case 'invalid-email':
        message =
            'Please enter a valid email address.';
        break;

      case 'weak-password':
        message =
            'Password must be at least 8 characters.';
        break;

      case 'operation-not-allowed':
        message =
            'Email/Password authentication is not enabled in Firebase.';
        break;

      case 'network-request-failed':
        message =
            'Network error. Please check your internet connection.';
        break;

      case 'too-many-requests':
        message =
            'Too many requests. Please try again later.';
        break;

      case 'user-disabled':
        message =
            'This account has been disabled.';
        break;

      default:
        message =
            'Firebase error: ${e.message ?? e.code}';
    }

    _showMessage(message);
  }

  // ==========================================================
  // FIRESTORE ERROR
  // ==========================================================

  on FirebaseException catch (e) {
    debugPrint('====================================');
    debugPrint('FIREBASE/FIRESTORE ERROR');
    debugPrint('CODE: ${e.code}');
    debugPrint('MESSAGE: ${e.message}');
    debugPrint('====================================');

    String message;

    switch (e.code) {
      case 'permission-denied':
        message =
            'Firestore permission denied. Check your Firestore security rules.';
        break;

      case 'unavailable':
        message =
            'Firestore is temporarily unavailable. Please try again.';
        break;

      case 'not-found':
        message =
            'Firestore database was not found.';
        break;

      case 'failed-precondition':
        message =
            'Firestore is not properly configured.';
        break;

      default:
        message =
            'Firestore error: ${e.message ?? e.code}';
    }

    _showMessage(message);
  }

  // ==========================================================
  // OTHER ERROR
  // ==========================================================

  catch (e) {
    debugPrint('====================================');
    debugPrint('UNKNOWN SIGNUP ERROR');
    debugPrint('ERROR: $e');
    debugPrint('====================================');

    _showMessage(
      'Something went wrong: $e',
    );
  }

  // ==========================================================
  // STOP LOADING
  // ==========================================================

  finally {
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }
}
  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final ThemeData theme =
        Theme.of(context);

    final bool isDark =
        theme.brightness == Brightness.dark;

    final Color primaryColor =
        theme.colorScheme.primary;

    final Color secondaryText =
        isDark
            ? Colors.white70
            : Colors.grey;

    return Scaffold(
      backgroundColor:
          theme.scaffoldBackgroundColor,

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        backgroundColor:
            theme.scaffoldBackgroundColor,

        elevation: 0,

        leading: IconButton(
          onPressed: isLoading
              ? null
              : () {
                  Navigator.pop(context);
                },

          icon: Icon(
            Icons.arrow_back_ios_new,
            color: primaryColor,
          ),
        ),
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            24,
            10,
            24,
            30,
          ),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              // ==================================================
              // TITLE
              // ==================================================

              Text(
                'Create Account 🎂',

                style: TextStyle(
                  color: primaryColor,
                  fontSize: 29,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Create your Divine Craving account and '
                'start ordering your favorite cakes.',

                style: TextStyle(
                  color: secondaryText,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 30),

              // ==================================================
              // FULL NAME
              // ==================================================

              Text(
                'Full Name',

                style: TextStyle(
                  color: primaryColor,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              TextField(
                controller:
                    nameController,

                textCapitalization:
                    TextCapitalization.words,

                textInputAction:
                    TextInputAction.next,

                decoration:
                    InputDecoration(
                  hintText:
                      'Enter your full name',

                  prefixIcon: Icon(
                    Icons.person_outline,
                    color: primaryColor,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // ==================================================
              // EMAIL
              // ==================================================

              Text(
                'Email Address',

                style: TextStyle(
                  color: primaryColor,
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

                enableSuggestions: false,

                decoration:
                    InputDecoration(
                  hintText:
                      'Enter your email',

                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: primaryColor,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // ==================================================
              // PHONE
              // ==================================================

              Text(
                'Phone Number',

                style: TextStyle(
                  color: primaryColor,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              TextField(
                controller:
                    phoneController,

                keyboardType:
                    TextInputType.phone,

                textInputAction:
                    TextInputAction.next,

                decoration:
                    InputDecoration(
                  hintText:
                      '03XX XXXXXXX',

                  prefixIcon: Icon(
                    Icons.phone_outlined,
                    color: primaryColor,
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
                  color: primaryColor,
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
                    TextInputAction.next,

                decoration:
                    InputDecoration(
                  hintText:
                      'Create a password',

                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: primaryColor,
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
                          primaryColor,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // ==================================================
              // CONFIRM PASSWORD
              // ==================================================

              Text(
                'Confirm Password',

                style: TextStyle(
                  color: primaryColor,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              TextField(
                controller:
                    confirmPasswordController,

                obscureText:
                    obscureConfirmPassword,

                textInputAction:
                    TextInputAction.done,

                onSubmitted: (_) {
                  if (!isLoading) {
                    signup();
                  }
                },

                decoration:
                    InputDecoration(
                  hintText:
                      'Confirm your password',

                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: primaryColor,
                  ),

                  suffixIcon:
                      IconButton(
                    onPressed: () {
                      setState(() {
                        obscureConfirmPassword =
                            !obscureConfirmPassword;
                      });
                    },

                    icon: Icon(
                      obscureConfirmPassword
                          ? Icons
                              .visibility_off_outlined
                          : Icons
                              .visibility_outlined,

                      color:
                          primaryColor,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ==================================================
              // TERMS
              // ==================================================

              Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  Checkbox(
                    value: agreeTerms,

                    activeColor:
                        primaryColor,

                    onChanged:
                        isLoading
                            ? null
                            : (value) {
                                setState(() {
                                  agreeTerms =
                                      value ??
                                          false;
                                });
                              },
                  ),

                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(
                        top: 12,
                      ),

                      child: Text(
                        'I agree to the Terms & Conditions '
                        'and Privacy Policy.',

                        style: TextStyle(
                          color:
                              secondaryText,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              // ==================================================
              // CREATE ACCOUNT BUTTON
              // ==================================================

              SizedBox(
                width:
                    double.infinity,

                height: 55,

                child:
                    FilledButton(
                  onPressed:
                      isLoading
                          ? null
                          : signup,

                  child:
                      isLoading
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
                              'CREATE ACCOUNT',

                              style:
                                  TextStyle(
                                fontWeight:
                                    FontWeight
                                        .bold,
                                letterSpacing:
                                    1,
                              ),
                            ),
                ),
              ),

              const SizedBox(height: 25),

              // ==================================================
              // LOGIN
              // ==================================================

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,

                children: [
                  Text(
                    'Already have an account?',

                    style: TextStyle(
                      color:
                          secondaryText,
                    ),
                  ),

                  TextButton(
                    onPressed:
                        isLoading
                            ? null
                            : () {
                                Navigator.pop(
                                  context,
                                );
                              },

                    child: Text(
                      'Login',

                      style: TextStyle(
                        color:
                            primaryColor,

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
    );
  }
}
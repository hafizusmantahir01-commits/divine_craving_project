import 'dart:async';

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // ============================================================
    // ANIMATION CONTROLLER
    // ============================================================

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // ============================================================
    // FADE ANIMATION
    // ============================================================

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    // ============================================================
    // SCALE ANIMATION
    // ============================================================

    _scaleAnimation = Tween<double>(
      begin: 0.75,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    // Start animation
    _controller.forward();

    // ============================================================
    // SPLASH DURATION
    // ============================================================

    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;

      // Splash ke baad direct Onboarding
      Navigator.pushReplacementNamed(
        context,
        '/onboarding',
      );
    });
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        // ========================================================
        // BACKGROUND
        // ========================================================

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFF8F2),
              Color(0xFFFFEBDD),
              Color(0xFFFFF5ED),
            ],
          ),
        ),

        child: SafeArea(
          child: Column(
            children: [
              // ==================================================
              // TOP SPACE
              // ==================================================

              const Spacer(flex: 2),

              // ==================================================
              // LOGO + TEXT
              // ==================================================

              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: child,
                    ),
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ============================================
                    // ROUND LOGO
                    // ============================================

                    Container(
                      width: 230,
                      height: 230,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF8B5E3C).withOpacity(0.20),
                            blurRadius: 35,
                            spreadRadius: 8,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/divine_craving_logo.png',
                          width: 230,
                          height: 230,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ============================================
                    // APP NAME
                    // ============================================

                    const Text(
                      'Divine Craving',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: Color(0xFF7A4B32),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // ============================================
                    // TAGLINE
                    // ============================================

                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 35,
                      ),
                      child: Text(
                        'Sweetness Crafted With Love',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.8,
                          color: Color(0xFF8A7165),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // ============================================
                    // DESCRIPTION
                    // ============================================

                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 45,
                      ),
                      child: Text(
                        'Delicious cakes made specially for your '
                        'sweetest moments.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.5,
                          color: Color(0xFF9A8880),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ==================================================
              // BOTTOM EMPTY SPACE
              // ==================================================

              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}

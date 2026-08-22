import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    // ============================================================
    // THEME COLORS
    // ============================================================

    final Color primary = theme.colorScheme.primary;

    final Color background =
        isDark ? const Color(0xFF120E0C) : const Color(0xFFFFFAF6);

    final Color card = isDark ? const Color(0xFF211814) : Colors.white;

    final Color cardBorder =
        isDark ? const Color(0xFF4A3328) : const Color(0xFFE8D9CC);

    final Color titleColor = isDark ? Colors.white : AppColors.brown;

    final Color subtitleColor =
        isDark ? const Color(0xFFBCAEA6) : AppColors.grey;

    final Color iconBoxColor =
        isDark ? const Color(0xFF33231C) : const Color(0xFFFFF0E4);

    final Color buttonColor =
        isDark ? const Color(0xFFD5A45A) : AppColors.brown;

    final Color buttonTextColor =
        isDark ? const Color(0xFF21150F) : Colors.white;

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 22,
              vertical: 30,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 520,
              ),
              child: Column(
                children: [
                  // ========================================================
                  // LOGO
                  // ========================================================

                  Container(
                    width: 94,
                    height: 94,
                    decoration: BoxDecoration(
                      color: iconBoxColor,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF6B4A38)
                            : const Color(0xFFF0D8C3),
                        width: 1.5,
                      ),
                      boxShadow: [
                        if (isDark)
                          BoxShadow(
                            color: Colors.black.withOpacity(0.35),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          )
                        else
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                      ],
                    ),
                    child: Icon(
                      Icons.cake_rounded,
                      size: 50,
                      color: primary,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // ========================================================
                  // APP NAME
                  // ========================================================

                  Text(
                    'Divine Craving',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.2,
                      color: primary,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ========================================================
                  // WELCOME
                  // ========================================================

                  Text(
                    'Welcome!',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w700,
                      color: titleColor,
                    ),
                  ),

                  const SizedBox(height: 7),

                  Text(
                    'Choose how you want to continue',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.5,
                      color: subtitleColor,
                    ),
                  ),

                  const SizedBox(height: 35),

                  // ========================================================
                  // USER CARD
                  // ========================================================

                  _RoleCard(
                    icon: Icons.person_outline_rounded,
                    title: 'Continue as User',
                    subtitle:
                        'Browse cakes, place orders and manage your favorites.',
                    buttonText: 'USER LOGIN',
                    isDark: isDark,
                    cardColor: card,
                    borderColor: cardBorder,
                    iconColor: primary,
                    iconBackgroundColor: iconBoxColor,
                    buttonColor: buttonColor,
                    buttonTextColor: buttonTextColor,
                    titleColor: titleColor,
                    subtitleColor: subtitleColor,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/login',
                      );
                    },
                  ),

                  const SizedBox(height: 18),

                  // ========================================================
                  // ADMIN CARD
                  // ========================================================

                  _RoleCard(
                    icon: Icons.admin_panel_settings_outlined,
                    title: 'Continue as Admin',
                    subtitle:
                        'Manage cakes, orders, customers and your business.',
                    buttonText: 'ADMIN LOGIN',
                    isDark: isDark,
                    cardColor: card,
                    borderColor: cardBorder,
                    iconColor: primary,
                    iconBackgroundColor: iconBoxColor,
                    buttonColor: buttonColor,
                    buttonTextColor: buttonTextColor,
                    titleColor: titleColor,
                    subtitleColor: subtitleColor,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/admin-login',
                      );
                    },
                  ),

                  const SizedBox(height: 30),

                  // ========================================================
                  // FOOTER
                  // ========================================================

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite_rounded,
                        size: 14,
                        color:
                            isDark ? const Color(0xFFD5A45A) : AppColors.brown,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Sweetness made with love',
                        style: TextStyle(
                          fontSize: 12.5,
                          color:
                              isDark ? const Color(0xFF8F7D72) : AppColors.grey,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // ========================================================
                  // DARK / LIGHT INDICATOR
                  // ========================================================

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF211814)
                          : const Color(0xFFF5EDE6),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF3D2A21)
                            : const Color(0xFFE7D9CD),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isDark
                              ? Icons.dark_mode_rounded
                              : Icons.light_mode_rounded,
                          size: 15,
                          color: primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isDark ? 'Dark Mode' : 'Light Mode',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? const Color(0xFFBCAEA6)
                                : AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ========================================================================
// ROLE CARD
// ========================================================================

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String buttonText;

  final bool isDark;

  final Color cardColor;
  final Color borderColor;
  final Color iconColor;
  final Color iconBackgroundColor;
  final Color buttonColor;
  final Color buttonTextColor;
  final Color titleColor;
  final Color subtitleColor;

  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.isDark,
    required this.cardColor,
    required this.borderColor,
    required this.iconColor,
    required this.iconBackgroundColor,
    required this.buttonColor,
    required this.buttonTextColor,
    required this.titleColor,
    required this.subtitleColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(22),

        // ==============================================================
        // BORDER
        // ==============================================================

        border: Border.all(
          color: borderColor,
          width: isDark ? 1.2 : 1,
        ),

        // ==============================================================
        // SHADOW
        // ==============================================================

        boxShadow: [
          if (isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.45),
              blurRadius: 20,
              offset: const Offset(0, 9),
            )
          else
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 18,
              offset: const Offset(0, 7),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ==============================================================
          // ICON + TITLE
          // ==============================================================

          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: iconBackgroundColor,
                  borderRadius: BorderRadius.circular(17),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF5B4031)
                        : const Color(0xFFF0D7C1),
                    width: 1,
                  ),
                ),
                child: Icon(
                  icon,
                  size: 31,
                  color: iconColor,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18.5,
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ==============================================================
          // DESCRIPTION
          // ==============================================================

          Text(
            subtitle,
            style: TextStyle(
              fontSize: 13.5,
              height: 1.5,
              color: subtitleColor,
            ),
          ),

          const SizedBox(height: 19),

          // ==============================================================
          // LOGIN BUTTON
          // ==============================================================

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: buttonTextColor,
                elevation: isDark ? 3 : 0,
                shadowColor: isDark
                    ? Colors.black.withOpacity(0.35)
                    : Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    buttonText,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                      color: buttonTextColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 18,
                    color: buttonTextColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_colors.dart';
import '../providers/admin_theme_provider.dart';
import '../screens/auth/login_screen.dart';

class AdminSettingsScreen extends StatelessWidget {
  const AdminSettingsScreen({super.key});

  // ============================================================
  // COLORS
  // ============================================================

  Color _backgroundColor(bool isDark) {
    return isDark ? const Color(0xFF121212) : const Color(0xFFF8F4EF);
  }

  Color _cardColor(bool isDark) {
    return isDark ? const Color(0xFF1E1E1E) : Colors.white;
  }

  Color _secondaryCardColor(bool isDark) {
    return isDark ? const Color(0xFF292929) : const Color(0xFFF9F6F2);
  }

  Color _primaryTextColor(bool isDark) {
    return isDark ? Colors.white : AppColors.brown;
  }

  Color _secondaryTextColor(bool isDark) {
    return isDark ? Colors.white70 : AppColors.grey;
  }

  Color _accentColor(bool isDark) {
    return isDark ? AppColors.gold : AppColors.brown;
  }

  Color _iconBackground(bool isDark) {
    return isDark ? const Color(0xFF352D27) : AppColors.peach;
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminThemeProvider>(
      builder: (context, themeProvider, child) {
        final bool isDark = themeProvider.themeMode == ThemeMode.dark;

        final double width = MediaQuery.of(context).size.width;
        final bool isDesktop = width >= 900;

        return Scaffold(
          backgroundColor: _backgroundColor(isDark),

          // ======================================================
          // MOBILE APP BAR
          // ======================================================
          appBar: isDesktop
              ? null
              : AppBar(
                  backgroundColor: _cardColor(isDark),
                  elevation: 0,
                  surfaceTintColor: Colors.transparent,
                  leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      color: _primaryTextColor(isDark),
                    ),
                    tooltip: 'Back',
                  ),
                  title: Text(
                    'Settings',
                    style: TextStyle(
                      color: _primaryTextColor(isDark),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

          // ======================================================
          // BODY
          // ======================================================
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isDesktop ? 30 : 18),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context, isDesktop, isDark),

                      const SizedBox(height: 28),

                      // ==================================================
                      // ACCOUNT
                      // ==================================================
                      _buildAccountSection(isDark),

                      const SizedBox(height: 28),

                      // ==================================================
                      // APP INFORMATION
                      // ==================================================
                      _buildAppInformation(isDark),

                      const SizedBox(height: 28),

                      // ==================================================
                      // PRIVACY & TERMS
                      // ==================================================
                      _buildPrivacySection(context, isDark),

                      const SizedBox(height: 28),

                      // ==================================================
                      // LOGOUT
                      // ==================================================
                      _buildLogoutSection(context, isDark),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader(BuildContext context, bool isDesktop, bool isDark) {
    return Row(
      children: [
        // ========================================================
        // DESKTOP BACK BUTTON
        // ========================================================
        if (isDesktop)
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _cardColor(isDark),
                borderRadius: BorderRadius.circular(13),
                boxShadow: [
                  if (!isDark)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                ],
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: _primaryTextColor(isDark),
                ),
                tooltip: 'Back',
              ),
            ),
          ),

        // ========================================================
        // TITLE
        // ========================================================
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Admin Settings',
                style: TextStyle(
                  fontSize: isDesktop ? 30 : 25,
                  fontWeight: FontWeight.bold,
                  color: _primaryTextColor(isDark),
                ),
              ),

              const SizedBox(height: 7),

              Text(
                'Manage your admin panel preferences and account settings.',
                style: TextStyle(
                  fontSize: 14,
                  color: _secondaryTextColor(isDark),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // ACCOUNT SECTION
  // ============================================================

  Widget _buildAccountSection(bool isDark) {
    return _buildSectionContainer(
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Account', Icons.admin_panel_settings_outlined, isDark),

          const SizedBox(height: 15),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: _secondaryCardColor(isDark),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: _iconBackground(isDark),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person_rounded,
                    color: _accentColor(isDark),
                    size: 29,
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Admin',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: _primaryTextColor(isDark),
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        'Administrator',
                        style: TextStyle(
                          fontSize: 13,
                          color: _secondaryTextColor(isDark),
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _iconBackground(isDark),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.verified_rounded,
                        size: 16,
                        color: _accentColor(isDark),
                      ),

                      const SizedBox(width: 5),

                      Text(
                        'Verified',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: _accentColor(isDark),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // APP INFORMATION
  // ============================================================

  Widget _buildAppInformation(bool isDark) {
    return _buildSectionContainer(
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('App Information', Icons.info_outline_rounded, isDark),

          const SizedBox(height: 15),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: _secondaryCardColor(isDark),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _buildInfoItem(
                  icon: Icons.apps_rounded,
                  title: 'App Name',
                  value: 'Divine Craving',
                  isDark: isDark,
                ),

                _buildDivider(isDark),

                _buildInfoItem(
                  icon: Icons.dashboard_outlined,
                  title: 'Panel',
                  value: 'Admin Panel',
                  isDark: isDark,
                ),

                _buildDivider(isDark),

                _buildInfoItem(
                  icon: Icons.verified_outlined,
                  title: 'Version',
                  value: '1.0.0',
                  isDark: isDark,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PRIVACY & TERMS SECTION
  // ============================================================

  Widget _buildPrivacySection(BuildContext context, bool isDark) {
    return _buildSectionContainer(
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Privacy & Terms', Icons.privacy_tip_outlined, isDark),

          const SizedBox(height: 15),

          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PrivacyTermsScreen(isDark: isDark),
                ),
              );
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: _secondaryCardColor(isDark),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? Colors.white10 : Colors.black12,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: _iconBackground(isDark),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.shield_outlined,
                      color: _accentColor(isDark),
                      size: 26,
                    ),
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Privacy Policy & Terms',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _primaryTextColor(isDark),
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          'Read our privacy policy and terms & conditions.',
                          style: TextStyle(
                            fontSize: 12,
                            color: _secondaryTextColor(isDark),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 18,
                    color: _secondaryTextColor(isDark),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // LOGOUT SECTION
  // ============================================================

  Widget _buildLogoutSection(BuildContext context, bool isDark) {
    return _buildSectionContainer(
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            'Account Actions',
            Icons.manage_accounts_outlined,
            isDark,
          ),

          const SizedBox(height: 15),

          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              _showLogoutDialog(context, isDark);
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF321F21)
                    : const Color(0xFFFFF3F2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF5A3034)
                      : const Color(0xFFFFD6D2),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF4A272A)
                          : const Color(0xFFFFE2DF),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.logout_rounded,
                      color: Colors.red,
                      size: 26,
                    ),
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Logout',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.red.shade700,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          'Sign out from your admin account.',
                          style: TextStyle(
                            fontSize: 12,
                            color: _secondaryTextColor(isDark),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 18,
                    color: Colors.red,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // LOGOUT DIALOG
  // ============================================================

  void _showLogoutDialog(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: _cardColor(isDark),
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),

          title: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF4A272A)
                      : const Color(0xFFFFE2DF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: Colors.red,
                  size: 25,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  'Logout',
                  style: TextStyle(
                    color: _primaryTextColor(isDark),
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),

          content: Text(
            'Are you sure you want to logout from the admin panel?',
            style: TextStyle(
              color: _secondaryTextColor(isDark),
              fontSize: 14,
              height: 1.5,
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: _secondaryTextColor(isDark),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(dialogContext);

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
              icon: const Icon(Icons.logout_rounded, size: 18),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // SECTION CONTAINER
  // ============================================================

  Widget _buildSectionContainer({required bool isDark, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardColor(isDark),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
        ],
      ),
      child: child,
    );
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================

  Widget _sectionTitle(String title, IconData icon, bool isDark) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: _iconBackground(isDark),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, size: 20, color: _accentColor(isDark)),
        ),

        const SizedBox(width: 10),

        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: _primaryTextColor(isDark),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // INFO ITEM
  // ============================================================

  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String value,
    required bool isDark,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _iconBackground(isDark),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, size: 19, color: _accentColor(isDark)),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Text(
            title,
            style: TextStyle(fontSize: 13, color: _secondaryTextColor(isDark)),
          ),
        ),

        Text(
          value,
          textAlign: TextAlign.end,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: _primaryTextColor(isDark),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // DIVIDER
  // ============================================================

  Widget _buildDivider(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Divider(
        height: 1,
        color: isDark ? Colors.white12 : Colors.black12,
      ),
    );
  }
}

// ================================================================
// PRIVACY & TERMS SCREEN
// ================================================================

class PrivacyTermsScreen extends StatelessWidget {
  final bool isDark;

  const PrivacyTermsScreen({super.key, required this.isDark});

  // ============================================================
  // COLORS
  // ============================================================

  Color get backgroundColor =>
      isDark ? const Color(0xFF121212) : const Color(0xFFF8F4EF);

  Color get cardColor => isDark ? const Color(0xFF1E1E1E) : Colors.white;

  Color get primaryTextColor => isDark ? Colors.white : AppColors.brown;

  Color get secondaryTextColor => isDark ? Colors.white70 : AppColors.grey;

  Color get accentColor => isDark ? AppColors.gold : AppColors.brown;

  Color get iconBackground =>
      isDark ? const Color(0xFF352D27) : AppColors.peach;

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      // ========================================================
      // APP BAR
      // ========================================================
      appBar: AppBar(
        backgroundColor: cardColor,
        elevation: 0,
        surfaceTintColor: Colors.transparent,

        leading: IconButton(
          tooltip: 'Back',
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_rounded, color: primaryTextColor),
        ),

        title: Text(
          'Privacy & Terms',
          style: TextStyle(
            color: primaryTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // ========================================================
      // BODY
      // ========================================================
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // =================================================
                  // PRIVACY POLICY
                  // =================================================
                  _buildContentCard(
                    title: 'Privacy Policy',
                    icon: Icons.privacy_tip_outlined,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeading('Your Privacy Matters'),

                        _buildParagraph(
                          'At Divine Craving, we respect your privacy and are committed to protecting your personal information.',
                        ),

                        _buildHeading('Information We Collect'),

                        _buildParagraph(
                          'We may collect information such as your name, contact details, order information and other information that you provide while using the application.',
                        ),

                        _buildHeading('How We Use Information'),

                        _buildParagraph(
                          'Your information may be used to process cake orders, communicate with customers, improve our services and provide a better experience.',
                        ),

                        _buildHeading('Information Protection'),

                        _buildParagraph(
                          'We take reasonable steps to protect your information and keep it secure.',
                        ),

                        _buildHeading('Third Party Services'),

                        _buildParagraph(
                          'Some features may use third-party services. Their use of information is governed by their respective privacy policies.',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // =================================================
                  // TERMS & CONDITIONS
                  // =================================================
                  _buildContentCard(
                    title: 'Terms & Conditions',
                    icon: Icons.description_outlined,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeading('Using Divine Craving'),

                        _buildParagraph(
                          'By using this application, you agree to follow these terms and use the application responsibly.',
                        ),

                        _buildHeading('Orders'),

                        _buildParagraph(
                          'Customers are responsible for providing accurate order information. Orders may be confirmed by the administrator before preparation.',
                        ),

                        _buildHeading('Cake Availability'),

                        _buildParagraph(
                          'Cake availability, prices and other product information may change from time to time.',
                        ),

                        _buildHeading('User Responsibility'),

                        _buildParagraph(
                          'Users should provide accurate information and should not misuse the application.',
                        ),

                        _buildHeading('Changes to Terms'),

                        _buildParagraph(
                          'Divine Craving may update these terms when necessary. Continued use of the application means you accept the updated terms.',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // =================================================
                  // BACK BUTTON
                  // =================================================
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back_rounded, color: accentColor),
                      label: Text(
                        'Back',
                        style: TextStyle(
                          color: accentColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        side: BorderSide(color: accentColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // CONTENT CARD
  // ============================================================

  Widget _buildContentCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: accentColor, size: 23),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: primaryTextColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          child,
        ],
      ),
    );
  }

  // ============================================================
  // HEADING
  // ============================================================

  Widget _buildHeading(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 7),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: primaryTextColor,
        ),
      ),
    );
  }

  // ============================================================
  // PARAGRAPH
  // ============================================================

  Widget _buildParagraph(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 13, height: 1.6, color: secondaryTextColor),
    );
  }
}

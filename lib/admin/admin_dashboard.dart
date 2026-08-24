import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ============================================================
// ROLE SELECTION
// ============================================================

import 'package:divine_craving_project/screens/auth/role_selection_screen.dart';

// ============================================================
// ADMIN SCREENS
// ============================================================

import '../screens/admin_orders_screen.dart';
import '../screens/admin_cakes_screen.dart';
import '../screens/admin_customers_screen.dart';
import '../screens/admin_reviews_screen.dart';
import '../screens/admin_settings_screen.dart';

// ============================================================
// CORE
// ============================================================

import '../core/constants/app_colors.dart';
import '../providers/admin_theme_provider.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int selectedIndex = 0;

  // ============================================================
  // MENU
  // ============================================================

  final List<String> menuTitles = [
    'Home',
    'Orders',
    'Cakes',
    'Customers',
    'Reviews',
    'Settings',
  ];

  final List<IconData> menuIcons = [
    Icons.dashboard_rounded,
    Icons.shopping_bag_rounded,
    Icons.cake_rounded,
    Icons.people_rounded,
    Icons.star_rounded,
    Icons.settings_rounded,
  ];

  // ============================================================
  // NOTIFICATIONS
  // ============================================================

  final List<Map<String, dynamic>> notifications = [
    {
      'title': 'New Order Received',
      'message': 'Ali Ahmed placed a new cake order.',
      'icon': Icons.shopping_bag_rounded,
      'time': '2 min ago',
      'read': false,
    },
    {
      'title': 'New Customer',
      'message': 'A new customer has registered.',
      'icon': Icons.person_add_rounded,
      'time': '15 min ago',
      'read': false,
    },
    {
      'title': 'New Review',
      'message': 'Sara Khan left a 5-star review.',
      'icon': Icons.star_rounded,
      'time': '1 hour ago',
      'read': true,
    },
    {
      'title': 'Cake Added',
      'message': 'Chocolate Fudge Cake was added.',
      'icon': Icons.cake_rounded,
      'time': '2 hours ago',
      'read': true,
    },
  ];

  // ============================================================
  // COLORS
  // ============================================================

  Color backgroundColor(bool dark) {
    return dark ? const Color(0xFF121212) : const Color(0xFFF8F4EF);
  }

  Color cardColor(bool dark) {
    return dark ? const Color(0xFF1E1E1E) : Colors.white;
  }

  Color sidebarColor(bool dark) {
    return dark ? const Color(0xFF181818) : Colors.white;
  }

  Color primaryText(bool dark) {
    return dark ? Colors.white : AppColors.brown;
  }

  Color secondaryText(bool dark) {
    return dark ? Colors.white70 : AppColors.grey;
  }

  Color iconBackground(bool dark) {
    return dark ? const Color(0xFF302820) : AppColors.peach;
  }

  Color accentColor(bool dark) {
    return dark ? AppColors.gold : AppColors.brown;
  }

  // ============================================================
  // UNREAD NOTIFICATION COUNT
  // ============================================================

  int get unreadNotificationCount {
    return notifications.where((item) => item['read'] == false).length;
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  void logout() {
    final themeProvider = context.read<AdminThemeProvider>();

    final bool isDark = themeProvider.themeMode == ThemeMode.dark;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: cardColor(isDark),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(
                    isDark ? 0.15 : 0.08,
                  ),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: Colors.red,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Logout',
                  style: TextStyle(
                    color: primaryText(isDark),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to logout from Admin Dashboard?',
            style: TextStyle(
              color: secondaryText(isDark),
              height: 1.4,
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
                  color: secondaryText(isDark),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RoleSelectionScreen(),
                  ),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // OPEN ADMIN PAGE
  // ============================================================

  Future<void> openPage(int index) async {
    Widget? page;

    switch (index) {
      case 1:
        page = const AdminOrdersScreen();
        break;

      case 2:
        page = const AdminCakesScreen();
        break;

      case 3:
        page = const AdminCustomersScreen();
        break;

      case 4:
        page = const AdminReviewsScreen();
        break;

      case 5:
        page = const AdminSettingsScreen();
        break;
    }

    if (page == null) {
      return;
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => page!,
      ),
    );

    if (!mounted) {
      return;
    }

    setState(() {
      selectedIndex = 0;
    });
  }

  // ============================================================
  // SELECT MENU
  // ============================================================

  void selectMenu(
    int index, {
    bool isDrawer = false,
  }) {
    if (index == 0) {
      setState(() {
        selectedIndex = 0;
      });

      if (isDrawer) {
        Navigator.pop(context);
      }

      return;
    }

    setState(() {
      selectedIndex = index;
    });

    if (isDrawer) {
      Navigator.pop(context);
    }

    openPage(index);
  }

  // ============================================================
  // NOTIFICATIONS
  // ============================================================

  void openNotifications() {
    final provider = context.read<AdminThemeProvider>();

    final bool isDark = provider.themeMode == ThemeMode.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return notificationSheet(
          sheetContext,
          isDark,
        );
      },
    );
  }

  // ============================================================
  // NOTIFICATION SHEET
  // ============================================================

  Widget notificationSheet(
    BuildContext sheetContext,
    bool isDark,
  ) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.72,
      decoration: BoxDecoration(
        color: backgroundColor(isDark),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              18,
              15,
              12,
            ),
            child: Row(
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: iconBackground(isDark),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(
                    Icons.notifications_rounded,
                    color: accentColor(isDark),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Notifications',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: primaryText(isDark),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '$unreadNotificationCount unread notifications',
                        style: TextStyle(
                          fontSize: 12,
                          color: secondaryText(isDark),
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      for (final item in notifications) {
                        item['read'] = true;
                      }
                    });

                    Navigator.pop(sheetContext);
                  },
                  child: Text(
                    'Mark all read',
                    style: TextStyle(
                      color: accentColor(isDark),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: isDark ? Colors.white10 : Colors.black12,
          ),
          Expanded(
            child: notifications.isEmpty
                ? emptyNotifications(isDark)
                : ListView.builder(
                    padding: const EdgeInsets.all(15),
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      return notificationItem(
                        index,
                        isDark,
                        sheetContext,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // EMPTY NOTIFICATIONS
  // ============================================================

  Widget emptyNotifications(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 55,
            color: secondaryText(isDark),
          ),
          const SizedBox(height: 12),
          Text(
            'No notifications',
            style: TextStyle(
              color: primaryText(isDark),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // NOTIFICATION ITEM
  // ============================================================

  Widget notificationItem(
    int index,
    bool isDark,
    BuildContext sheetContext,
  ) {
    final item = notifications[index];

    final bool isRead = item['read'] == true;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        setState(() {
          notifications[index]['read'] = true;
        });

        Navigator.pop(sheetContext);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isRead
              ? cardColor(isDark)
              : isDark
                  ? const Color(0xFF2A241F)
                  : const Color(0xFFFFF8F1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isRead
                ? isDark
                    ? Colors.white10
                    : Colors.black12
                : accentColor(isDark),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: iconBackground(isDark),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(
                item['icon'] as IconData,
                color: accentColor(isDark),
                size: 21,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'] as String,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: primaryText(isDark),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    item['message'] as String,
                    style: TextStyle(
                      fontSize: 12,
                      color: secondaryText(isDark),
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    item['time'] as String,
                    style: TextStyle(
                      fontSize: 10,
                      color: secondaryText(isDark),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // NOTIFICATION BUTTON
  // ============================================================

  Widget notificationButton(bool isDark) {
    return SizedBox(
      width: 48,
      height: 48,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: IconButton(
              onPressed: openNotifications,
              icon: Icon(
                Icons.notifications_none_rounded,
                color: primaryText(isDark),
              ),
            ),
          ),
          if (unreadNotificationCount > 0)
            Positioned(
              right: 2,
              top: 2,
              child: Container(
                constraints: const BoxConstraints(
                  minWidth: 18,
                  minHeight: 18,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 4,
                ),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    unreadNotificationCount > 9
                        ? '9+'
                        : unreadNotificationCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
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
          backgroundColor: backgroundColor(isDark),

          // ==================================================
          // MOBILE DRAWER
          // ==================================================

          drawer: !isDesktop
              ? Drawer(
                  backgroundColor: sidebarColor(isDark),
                  child: SafeArea(
                    child: buildSidebar(
                      isDark,
                      true,
                    ),
                  ),
                )
              : null,

          // ==================================================
          // MOBILE APP BAR
          // ==================================================

          appBar: isDesktop
              ? null
              : AppBar(
                  backgroundColor: cardColor(isDark),
                  elevation: 0,
                  iconTheme: IconThemeData(
                    color: primaryText(isDark),
                  ),
                  title: Text(
                    'Divine Craving',
                    style: TextStyle(
                      color: primaryText(isDark),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {
                        themeProvider.toggleTheme();
                      },
                      icon: Icon(
                        isDark
                            ? Icons.light_mode_rounded
                            : Icons.dark_mode_rounded,
                        color: accentColor(isDark),
                      ),
                    ),
                    notificationButton(isDark),
                    const SizedBox(width: 8),
                  ],
                ),

          // ==================================================
          // BODY
          // ==================================================

          body: Row(
            children: [
              if (isDesktop)
                buildSidebar(
                  isDark,
                  false,
                ),
              Expanded(
                child: buildMainContent(
                  isDark,
                  isDesktop,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // SIDEBAR
  // ============================================================

  Widget buildSidebar(
    bool isDark,
    bool isDrawer,
  ) {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: sidebarColor(isDark),
        border: isDrawer
            ? null
            : Border(
                right: BorderSide(
                  color: isDark ? Colors.white10 : Colors.black12,
                ),
              ),
      ),
      child: Column(
        children: [
          // ==================================================
          // DIVINE CRAVING LOGO
          // ==================================================

          Padding(
            padding: const EdgeInsets.fromLTRB(
              22,
              22,
              22,
              18,
            ),
            child: Row(
              children: [
                // ==================================================
                // PERFECT CIRCLE LOGO
                // ==================================================

                ClipOval(
                  child: SizedBox(
                    width: 58,
                    height: 58,
                    child: Image.asset(
                      'assets/images/divine_craving_logo.png',
                      width: 58,
                      height: 58,

                      // Logo ko circle ke andar properly fit karega
                      fit: BoxFit.cover,

                      // Agar image load na ho to fallback
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 58,
                          height: 58,
                          color: AppColors.gold,
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.cake_rounded,
                            color: AppColors.brown,
                            size: 28,
                          ),
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Divine',
                        style: TextStyle(
                          color: primaryText(isDark),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'CRAVING',
                        style: TextStyle(
                          color: secondaryText(
                            isDark,
                          ),
                          fontSize: 9,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Divider(
            color: isDark ? Colors.white10 : Colors.black12,
          ),

          const SizedBox(height: 15),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'MAIN MENU',
                style: TextStyle(
                  color: secondaryText(isDark),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
              ),
              itemCount: menuTitles.length,
              itemBuilder: (context, index) {
                return buildSidebarItem(
                  index,
                  isDark,
                  isDrawer,
                );
              },
            ),
          ),

          // ==================================================
          // ADMIN PROFILE
          // ==================================================

          Container(
            margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBackground(isDark),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: const BoxDecoration(
                        color: AppColors.gold,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        color: AppColors.brown,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Admin',
                            style: TextStyle(
                              color: primaryText(
                                isDark,
                              ),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Text(
                            'Administrator',
                            style: TextStyle(
                              color: secondaryText(
                                isDark,
                              ),
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.verified_rounded,
                      size: 18,
                      color: accentColor(
                        isDark,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Divider(
                  color: isDark ? Colors.white10 : Colors.black12,
                ),

                const SizedBox(height: 4),

                // ==================================================
                // LOGOUT
                // ==================================================

                InkWell(
                  onTap: logout,
                  borderRadius: BorderRadius.circular(
                    12,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 6,
                    ),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.logout_rounded,
                          color: Colors.red,
                          size: 20,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Logout',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
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
  // SIDEBAR ITEM
  // ============================================================

  Widget buildSidebarItem(
    int index,
    bool isDark,
    bool isDrawer,
  ) {
    final bool selected = selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 5,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(13),
        onTap: () {
          selectMenu(
            index,
            isDrawer: isDrawer,
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 13,
          ),
          decoration: BoxDecoration(
            color: selected
                ? isDark
                    ? const Color(
                        0xFF3A3027,
                      )
                    : AppColors.peach
                : Colors.transparent,
            borderRadius: BorderRadius.circular(
              13,
            ),
          ),
          child: Row(
            children: [
              Icon(
                menuIcons[index],
                size: 21,
                color: selected
                    ? accentColor(
                        isDark,
                      )
                    : secondaryText(
                        isDark,
                      ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Text(
                  menuTitles[index],
                  style: TextStyle(
                    color: selected
                        ? primaryText(
                            isDark,
                          )
                        : secondaryText(
                            isDark,
                          ),
                    fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ),
              if (selected)
                Container(
                  width: 5,
                  height: 5,
                  decoration: const BoxDecoration(
                    color: AppColors.gold,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // MAIN CONTENT
  // ============================================================

  Widget buildMainContent(
    bool isDark,
    bool isDesktop,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(
        isDesktop ? 30 : 18,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dashboard',
                      style: TextStyle(
                        fontSize: isDesktop ? 30 : 25,
                        fontWeight: FontWeight.bold,
                        color: primaryText(
                          isDark,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Welcome back, Admin 👋',
                      style: TextStyle(
                        color: secondaryText(
                          isDark,
                        ),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              if (isDesktop)
                Row(
                  children: [
                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: cardColor(
                          isDark,
                        ),
                        borderRadius: BorderRadius.circular(
                          13,
                        ),
                      ),
                      child: IconButton(
                        onPressed: () {
                          context.read<AdminThemeProvider>().toggleTheme();
                        },
                        icon: Icon(
                          isDark
                              ? Icons.light_mode_rounded
                              : Icons.dark_mode_rounded,
                          color: accentColor(
                            isDark,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: cardColor(
                          isDark,
                        ),
                        borderRadius: BorderRadius.circular(
                          13,
                        ),
                      ),
                      child: notificationButton(
                        isDark,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 30),
          buildStats(isDark),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Recent Orders',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: primaryText(
                      isDark,
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    selectedIndex = 1;
                  });

                  openPage(1);
                },
                child: Text(
                  'View All',
                  style: TextStyle(
                    color: accentColor(
                      isDark,
                    ),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          buildOrderTile(
            isDark,
            'Ali Ahmed',
            'Chocolate Cake',
            'Rs 2,500',
            'Pending',
          ),
          buildOrderTile(
            isDark,
            'Sara Khan',
            'Red Velvet Cake',
            'Rs 3,000',
            'Completed',
          ),
          buildOrderTile(
            isDark,
            'Usman Ali',
            'Birthday Cake',
            'Rs 2,000',
            'Processing',
          ),
          buildOrderTile(
            isDark,
            'Ayesha',
            'Wedding Cake',
            'Rs 8,500',
            'Pending',
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STATS
  // ============================================================

  Widget buildStats(bool isDark) {
    final List<Map<String, dynamic>> stats = [
      {
        'title': 'Total Orders',
        'value': '128',
        'icon': Icons.shopping_bag_rounded,
      },
      {
        'title': 'Total Cakes',
        'value': '46',
        'icon': Icons.cake_rounded,
      },
      {
        'title': 'Customers',
        'value': '342',
        'icon': Icons.people_rounded,
      },
      {
        'title': 'Revenue',
        'value': 'Rs 85,400',
        'icon': Icons.payments_rounded,
      },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        int columns = 1;

        if (constraints.maxWidth >= 1100) {
          columns = 4;
        } else if (constraints.maxWidth >= 650) {
          columns = 2;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: stats.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: columns == 1 ? 3.5 : 2.1,
          ),
          itemBuilder: (context, index) {
            final stat = stats[index];

            return buildStatCard(
              title: stat['title'] as String,
              value: stat['value'] as String,
              icon: stat['icon'] as IconData,
              isDark: isDark,
            );
          },
        );
      },
    );
  }

  // ============================================================
  // STAT CARD
  // ============================================================

  Widget buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: cardColor(isDark),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: iconBackground(
                isDark,
              ),
              borderRadius: BorderRadius.circular(
                14,
              ),
            ),
            child: Icon(
              icon,
              color: accentColor(isDark),
              size: 25,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: secondaryText(
                      isDark,
                    ),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: TextStyle(
                    color: primaryText(
                      isDark,
                    ),
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
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
  // ORDER TILE
  // ============================================================

  Widget buildOrderTile(
    bool isDark,
    String customer,
    String cake,
    String price,
    String status,
  ) {
    final bool completed = status == 'Completed';

    final Color statusColor = completed
        ? Colors.green
        : status == 'Processing'
            ? Colors.orange
            : accentColor(
                isDark,
              );

    return Container(
      margin: const EdgeInsets.only(
        bottom: 10,
      ),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor(isDark),
        borderRadius: BorderRadius.circular(
          16,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: iconBackground(
                isDark,
              ),
              borderRadius: BorderRadius.circular(
                13,
              ),
            ),
            child: Icon(
              Icons.cake_rounded,
              color: accentColor(isDark),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customer,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: primaryText(
                      isDark,
                    ),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  cake,
                  style: TextStyle(
                    color: secondaryText(
                      isDark,
                    ),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: primaryText(
                    isDark,
                  ),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(
                    0.10,
                  ),
                  borderRadius: BorderRadius.circular(
                    7,
                  ),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

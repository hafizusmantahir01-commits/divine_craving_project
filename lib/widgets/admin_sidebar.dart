import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class AdminSidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const AdminSidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(
            color: Color(0xFFE8E1DA),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // =====================================================
          // LOGO / APP NAME
          // =====================================================

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 25,
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.peach,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.cake_rounded,
                    color: AppColors.brown,
                    size: 28,
                  ),
                ),

                const SizedBox(width: 12),

                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Divine Craving',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.brown,
                        ),
                      ),

                      SizedBox(height: 3),

                      Text(
                        'Admin Panel',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(
            height: 1,
            color: Color(0xFFE8E1DA),
          ),

          const SizedBox(height: 20),

          // =====================================================
          // MENU
          // =====================================================

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  _buildMenuItem(
                    context: context,
                    index: 0,
                    icon: Icons.dashboard_outlined,
                    selectedIcon: Icons.dashboard,
                    title: 'Dashboard',
                  ),

                  _buildMenuItem(
                    context: context,
                    index: 1,
                    icon: Icons.cake_outlined,
                    selectedIcon: Icons.cake,
                    title: 'Manage Cakes',
                  ),

                  _buildMenuItem(
                    context: context,
                    index: 2,
                    icon: Icons.shopping_bag_outlined,
                    selectedIcon: Icons.shopping_bag,
                    title: 'Orders',
                  ),

                  _buildMenuItem(
                    context: context,
                    index: 3,
                    icon: Icons.people_outline,
                    selectedIcon: Icons.people,
                    title: 'Customers',
                  ),

                  _buildMenuItem(
                    context: context,
                    index: 4,
                    icon: Icons.reviews_outlined,
                    selectedIcon: Icons.reviews,
                    title: 'Reviews',
                  ),

                  _buildMenuItem(
                    context: context,
                    index: 5,
                    icon: Icons.settings_outlined,
                    selectedIcon: Icons.settings,
                    title: 'Settings',
                  ),
                ],
              ),
            ),
          ),

          // =====================================================
          // ADMIN PROFILE
          // =====================================================

          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F4EF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 23,
                  backgroundColor: AppColors.peach,
                  child: const Icon(
                    Icons.person,
                    color: AppColors.brown,
                  ),
                ),

                const SizedBox(width: 10),

                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Admin',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.brown,
                        ),
                      ),

                      SizedBox(height: 3),

                      Text(
                        'Administrator',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                IconButton(
                  onPressed: () {
                    _showLogoutDialog(context);
                  },
                  icon: const Icon(
                    Icons.logout,
                    color: Colors.red,
                    size: 20,
                  ),
                  tooltip: 'Logout',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // MENU ITEM
  // =====================================================

  Widget _buildMenuItem({
    required BuildContext context,
    required int index,
    required IconData icon,
    required IconData selectedIcon,
    required String title,
  }) {
    final bool isSelected = selectedIndex == index;

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            onItemSelected(index);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 13,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.peach
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Icon(
                  isSelected ? selectedIcon : icon,
                  color: isSelected
                      ? AppColors.brown
                      : AppColors.grey,
                  size: 22,
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w500,
                      color: isSelected
                          ? AppColors.brown
                          : const Color(0xFF555555),
                    ),
                  ),
                ),

                if (isSelected)
                  Container(
                    width: 5,
                    height: 25,
                    decoration: BoxDecoration(
                      color: AppColors.brown,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =====================================================
  // LOGOUT DIALOG
  // =====================================================

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text(
            'Logout',
            style: TextStyle(
              color: AppColors.brown,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Are you sure you want to logout?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: AppColors.grey,
                ),
              ),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);

                // Yahan baad mein LoginScreen par navigation laga sakte hain.
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Logout clicked'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
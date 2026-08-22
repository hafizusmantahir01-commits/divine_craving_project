import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onChanged;

  const BottomNav({
    super.key,
    required this.currentIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    return NavigationBar(
      selectedIndex: currentIndex,

      onDestinationSelected: (index) {
        onChanged(index);
      },

      backgroundColor: isDark
          ? const Color(0xFF211814)
          : Colors.white,

      indicatorColor: isDark
          ? AppColors.brown
          : AppColors.peach,

      elevation: 3,

      labelTextStyle:
          WidgetStatePropertyAll<TextStyle>(
        TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isDark
              ? Colors.white
              : AppColors.brown,
        ),
      ),

      destinations: [
        NavigationDestination(
          icon: Icon(
            Icons.home_outlined,
            color: isDark
                ? Colors.white70
                : AppColors.grey,
          ),
          selectedIcon: Icon(
            Icons.home,
            color: isDark
                ? Colors.white
                : AppColors.brown,
          ),
          label: 'Home',
        ),

        NavigationDestination(
          icon: Icon(
            Icons.grid_view_outlined,
            color: isDark
                ? Colors.white70
                : AppColors.grey,
          ),
          selectedIcon: Icon(
            Icons.grid_view,
            color: isDark
                ? Colors.white
                : AppColors.brown,
          ),
          label: 'Categories',
        ),

        NavigationDestination(
          icon: Icon(
            Icons.favorite_border,
            color: isDark
                ? Colors.white70
                : AppColors.grey,
          ),
          selectedIcon: Icon(
            Icons.favorite,
            color: isDark
                ? Colors.white
                : AppColors.brown,
          ),
          label: 'Favorites',
        ),

        NavigationDestination(
          icon: Icon(
            Icons.shopping_bag_outlined,
            color: isDark
                ? Colors.white70
                : AppColors.grey,
          ),
          selectedIcon: Icon(
            Icons.shopping_bag,
            color: isDark
                ? Colors.white
                : AppColors.brown,
          ),
          label: 'Cart',
        ),

        NavigationDestination(
          icon: Icon(
            Icons.person_outline,
            color: isDark
                ? Colors.white70
                : AppColors.grey,
          ),
          selectedIcon: Icon(
            Icons.person,
            color: isDark
                ? Colors.white
                : AppColors.brown,
          ),
          label: 'Profile',
        ),
      ],
    );
  }
}
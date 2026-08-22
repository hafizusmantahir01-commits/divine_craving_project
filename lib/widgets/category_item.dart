import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class CategoryItem extends StatelessWidget {
  final IconData icon;
  final String title;

  const CategoryItem({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: 72,
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF261D19) : AppColors.lightCream,
              shape: BoxShape.circle,
              border: Border.all(
                color:
                    isDark ? AppColors.peach.withOpacity(0.5) : AppColors.peach,
              ),
            ),
            child: Icon(
              icon,
              color: isDark ? AppColors.peach : AppColors.brown,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white : AppColors.brown,
            ),
          ),
        ],
      ),
    );
  }
}

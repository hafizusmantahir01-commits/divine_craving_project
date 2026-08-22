import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final String action;
  final VoidCallback? onTap;

  const SectionTitle({
    super.key,
    required this.title,
    required this.action,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.brown,
            ),
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            action,
            style: TextStyle(
              color: isDark ? AppColors.peach : AppColors.gold,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

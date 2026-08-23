import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../data/cake_data.dart';
import '../../providers/user_theme_provider.dart';


class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark =
        context.watch<UserThemeProvider>().themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF1B1411) : const Color(0xFFFFFAF6),

      appBar: AppBar(
        elevation: 0,
        backgroundColor:
            isDark ? const Color(0xFF3A251C) : const Color(0xFFFFFAF6),
        foregroundColor: isDark ? Colors.white : AppColors.brown,
        title: const Text(
          'My Orders',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 19,
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          16,
          18,
          16,
          30,
        ),
        children: [
          // ============================================================
          // HEADER
          // ============================================================

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? const [
                        Color(0xFF3A251C),
                        Color(0xFF261D19),
                      ]
                    : const [
                        Color(0xFFFFF2E7),
                        Color(0xFFFFFAF6),
                      ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? Colors.white10 : AppColors.peach,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.brown : AppColors.peach,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.shopping_bag_outlined,
                    size: 27,
                    color: isDark ? AppColors.gold : AppColors.brown,
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Orders',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color:
                              isDark ? Colors.white : AppColors.brown,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        'Track and manage your cake orders.',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.4,
                          color:
                              isDark ? Colors.white70 : AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          Text(
            'Recent Orders',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.brown,
            ),
          ),

          const SizedBox(height: 12),

          // ============================================================
          // ORDER 1
          // ============================================================

          OrderCard(
            cake: CakeData.cakes[0],
            status: 'Preparing',
          ),

          // ============================================================
          // ORDER 2
          // ============================================================

          OrderCard(
            cake: CakeData.cakes[1],
            status: 'Delivered',
          ),
        ],
      ),
    );
  }
}

// ============================================================
// ORDER CARD
// ============================================================

class OrderCard extends StatelessWidget {
  final dynamic cake;
  final String status;

  const OrderCard({
    super.key,
    required this.cake,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark =
        context.watch<UserThemeProvider>().themeMode == ThemeMode.dark;

    final bool isDelivered = status.toLowerCase() == 'delivered';

    final Color primaryColor =
        isDark ? AppColors.gold : AppColors.brown;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF261D19) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.black12,
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
        ],
      ),

      child: Padding(
        padding: const EdgeInsets.all(14),

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==========================================================
            // CAKE IMAGE
            // ==========================================================

            ClipRRect(
              borderRadius: BorderRadius.circular(14),

              child: SizedBox(
                width: 82,
                height: 82,

                child: Image.network(
                  cake.image,
                  fit: BoxFit.cover,

                  errorBuilder: (
                    context,
                    error,
                    stackTrace,
                  ) {
                    return Container(
                      color: isDark
                          ? AppColors.brown
                          : AppColors.peach,
                      child: Icon(
                        Icons.cake_outlined,
                        size: 36,
                        color: primaryColor,
                      ),
                    );
                  },

                  loadingBuilder: (
                    context,
                    child,
                    loadingProgress,
                  ) {
                    if (loadingProgress == null) {
                      return child;
                    }

                    return Container(
                      color: isDark
                          ? AppColors.brown
                          : AppColors.peach,
                      child: Center(
                        child: SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(width: 12),

            // ==========================================================
            // ORDER INFORMATION
            // ==========================================================

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cake Name
                  Text(
                    cake.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? Colors.white
                          : AppColors.brown,
                    ),
                  ),

                  const SizedBox(height: 7),

                  // Price
                  Text(
                    'Rs ${cake.price.toInt()}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? Colors.white70
                          : Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 9),

                  // Status
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: isDelivered
                          ? Colors.green.withOpacity(0.10)
                          : Colors.orange.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isDelivered
                            ? Colors.green
                            : Colors.orange,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 5),

            // ==========================================================
            // CHEVRON
            // ==========================================================

            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Icon(
                Icons.chevron_right,
                size: 22,
                color: isDark
                    ? Colors.white54
                    : AppColors.brown,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../providers/user_theme_provider.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark =
        context.watch<UserThemeProvider>().themeMode == ThemeMode.dark;

    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        backgroundColor:
            isDark ? const Color(0xFF1B1411) : const Color(0xFFFFFAF6),
        appBar: AppBar(
          elevation: 0,
          backgroundColor:
              isDark ? const Color(0xFF3A251C) : const Color(0xFFFFFAF6),
          foregroundColor:
              isDark ? Colors.white : AppColors.brown,
          title: const Text(
            'My Orders',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 19,
            ),
          ),
        ),
        body: _NotLoggedInWidget(
          isDark: isDark,
        ),
      );
    }

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF1B1411) : const Color(0xFFFFFAF6),
      appBar: AppBar(
        elevation: 0,
        backgroundColor:
            isDark ? const Color(0xFF3A251C) : const Color(0xFFFFFAF6),
        foregroundColor:
            isDark ? Colors.white : AppColors.brown,
        title: const Text(
          'My Orders',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 19,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('userId', isEqualTo: user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _ErrorWidget(
              isDark: isDark,
              message: snapshot.error.toString(),
            );
          }

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final List<QueryDocumentSnapshot<Map<String, dynamic>>> orders =
              snapshot.data?.docs ?? [];

          orders.sort((a, b) {
            final Timestamp? aTime =
                a.data()['createdAt'] as Timestamp?;

            final Timestamp? bTime =
                b.data()['createdAt'] as Timestamp?;

            if (aTime == null && bTime == null) {
              return 0;
            }

            if (aTime == null) {
              return 1;
            }

            if (bTime == null) {
              return -1;
            }

            return bTime.compareTo(aTime);
          });

          return ListView(
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
                    color:
                        isDark ? Colors.white10 : AppColors.peach,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color:
                            isDark ? AppColors.brown : AppColors.peach,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.shopping_bag_outlined,
                        size: 27,
                        color:
                            isDark ? AppColors.gold : AppColors.brown,
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your Orders',
                            maxLines: 1,
                            overflow:
                                TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight:
                                  FontWeight.bold,
                              color: isDark
                                  ? Colors.white
                                  : AppColors.brown,
                            ),
                          ),

                          const SizedBox(height: 5),

                          Text(
                            orders.isEmpty
                                ? 'You have not placed any orders yet.'
                                : '${orders.length} order${orders.length == 1 ? '' : 's'} found.',
                            maxLines: 2,
                            overflow:
                                TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              height: 1.4,
                              color: isDark
                                  ? Colors.white70
                                  : AppColors.grey,
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
                  color:
                      isDark ? Colors.white : AppColors.brown,
                ),
              ),

              const SizedBox(height: 12),

              // ============================================================
              // EMPTY ORDERS
              // ============================================================

              if (orders.isEmpty)
                _EmptyOrdersWidget(
                  isDark: isDark,
                ),

              // ============================================================
              // FIREBASE ORDERS
              // ============================================================

              ...orders.map(
                (order) {
                  return OrderCard(
                    orderId: order.id,
                    orderData: order.data(),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

// ============================================================
// ORDER CARD
// ============================================================

class OrderCard extends StatelessWidget {
  final String orderId;
  final Map<String, dynamic> orderData;

  const OrderCard({
    super.key,
    required this.orderId,
    required this.orderData,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark =
        context.watch<UserThemeProvider>().themeMode == ThemeMode.dark;

    final String cakeName =
        orderData['cakeName']?.toString() ??
            orderData['name']?.toString() ??
            'Cake Order';

    final String image =
        orderData['image']?.toString() ??
            orderData['cakeImage']?.toString() ??
            '';

    final String status =
        orderData['status']?.toString() ??
            'Pending';

    final dynamic priceValue =
        orderData['totalPrice'] ??
            orderData['price'] ??
            0;

    final double price =
        priceValue is num
            ? priceValue.toDouble()
            : double.tryParse(
                  priceValue.toString(),
                ) ??
                0;

    final bool isDelivered =
        status.toLowerCase() == 'delivered';

    final bool isCancelled =
        status.toLowerCase() == 'cancelled';

    final Color primaryColor =
        isDark ? AppColors.gold : AppColors.brown;

    Color statusColor;

    if (isDelivered) {
      statusColor = Colors.green;
    } else if (isCancelled) {
      statusColor = Colors.red;
    } else {
      statusColor = Colors.orange;
    }

    return InkWell(
      onTap: () {
        _showOrderDetails(
          context,
          cakeName,
          status,
          price,
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color:
              isDark ? const Color(0xFF261D19) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                isDark ? Colors.white10 : Colors.black12,
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
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              // ==========================================================
              // CAKE IMAGE
              // ==========================================================

              ClipRRect(
                borderRadius:
                    BorderRadius.circular(14),
                child: SizedBox(
                  width: 82,
                  height: 82,
                  child: image.isNotEmpty
                      ? Image.network(
                          image,
                          fit: BoxFit.cover,
                          errorBuilder: (
                            context,
                            error,
                            stackTrace,
                          ) {
                            return _ImagePlaceholder(
                              isDark: isDark,
                              primaryColor: primaryColor,
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
                                child:
                                    SizedBox(
                                  width: 22,
                                  height: 22,
                                  child:
                                      CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color:
                                        primaryColor,
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : _ImagePlaceholder(
                          isDark: isDark,
                          primaryColor: primaryColor,
                        ),
                ),
              ),

              const SizedBox(width: 12),

              // ==========================================================
              // ORDER INFORMATION
              // ==========================================================

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      cakeName,
                      maxLines: 2,
                      overflow:
                          TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight:
                            FontWeight.bold,
                        color: isDark
                            ? Colors.white
                            : AppColors.brown,
                      ),
                    ),

                    const SizedBox(height: 7),

                    Text(
                      'Rs ${price.toStringAsFixed(0)}',
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight:
                            FontWeight.w600,
                        color: isDark
                            ? Colors.white70
                            : Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 9),

                    Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color:
                            statusColor.withOpacity(0.10),
                        borderRadius:
                            BorderRadius.circular(20),
                      ),
                      child: Text(
                        status,
                        maxLines: 1,
                        overflow:
                            TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight:
                              FontWeight.bold,
                          color:
                              statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 5),

              Padding(
                padding:
                    const EdgeInsets.only(top: 5),
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
      ),
    );
  }

  // ============================================================
  // ORDER DETAILS
  // ============================================================

  void _showOrderDetails(
    BuildContext context,
    String cakeName,
    String status,
    double price,
  ) {
    final bool isDark =
        Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor:
              isDark ? const Color(0xFF261D19) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: Text(
            'Order Details',
            style: TextStyle(
              color:
                  isDark ? Colors.white : AppColors.brown,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize:
                MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                cakeName,
                style: TextStyle(
                  color:
                      isDark ? Colors.white : AppColors.brown,
                  fontSize: 16,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                'Order ID: $orderId',
                style: TextStyle(
                  color:
                      isDark ? Colors.white70 : AppColors.grey,
                  fontSize: 12,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Status: $status',
                style: TextStyle(
                  color:
                      isDark ? Colors.white70 : AppColors.grey,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Total: Rs ${price.toStringAsFixed(0)}',
                style: TextStyle(
                  color:
                      isDark ? Colors.white : AppColors.brown,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Close',
              ),
            ),
          ],
        );
      },
    );
  }
}

// ============================================================
// IMAGE PLACEHOLDER
// ============================================================

class _ImagePlaceholder extends StatelessWidget {
  final bool isDark;
  final Color primaryColor;

  const _ImagePlaceholder({
    required this.isDark,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color:
          isDark ? AppColors.brown : AppColors.peach,
      child: Icon(
        Icons.cake_outlined,
        size: 36,
        color: primaryColor,
      ),
    );
  }
}

// ============================================================
// EMPTY ORDERS
// ============================================================

class _EmptyOrdersWidget extends StatelessWidget {
  final bool isDark;

  const _EmptyOrdersWidget({
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 50,
      ),
      decoration: BoxDecoration(
        color:
            isDark ? const Color(0xFF261D19) : Colors.white,
        borderRadius:
            BorderRadius.circular(20),
        border: Border.all(
          color:
              isDark ? Colors.white10 : Colors.black12,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 65,
            color:
                isDark ? AppColors.gold : AppColors.brown,
          ),

          const SizedBox(height: 16),

          Text(
            'No Orders Yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight:
                  FontWeight.bold,
              color:
                  isDark ? Colors.white : AppColors.brown,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Your placed orders will appear here.',
            textAlign:
                TextAlign.center,
            style: TextStyle(
              color:
                  isDark ? Colors.white60 : AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// NOT LOGGED IN
// ============================================================

class _NotLoggedInWidget extends StatelessWidget {
  final bool isDark;

  const _NotLoggedInWidget({
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(24),
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            Icon(
              Icons.account_circle_outlined,
              size: 70,
              color:
                  isDark ? AppColors.gold : AppColors.brown,
            ),

            const SizedBox(height: 18),

            Text(
              'Please Login',
              style: TextStyle(
                fontSize: 20,
                fontWeight:
                    FontWeight.bold,
                color:
                    isDark ? Colors.white : AppColors.brown,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Login to view your orders.',
              textAlign:
                  TextAlign.center,
              style: TextStyle(
                color:
                    isDark ? Colors.white60 : AppColors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// ERROR WIDGET
// ============================================================

class _ErrorWidget extends StatelessWidget {
  final bool isDark;
  final String message;

  const _ErrorWidget({
    required this.isDark,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(24),
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 65,
              color:
                  isDark ? Colors.redAccent : Colors.red,
            ),

            const SizedBox(height: 16),

            Text(
              'Unable to Load Orders',
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
                color:
                    isDark ? Colors.white : AppColors.brown,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              message,
              textAlign:
                  TextAlign.center,
              maxLines: 4,
              overflow:
                  TextOverflow.ellipsis,
              style: TextStyle(
                color:
                    isDark ? Colors.white60 : AppColors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
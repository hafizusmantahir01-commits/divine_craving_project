import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_colors.dart';
import '../providers/admin_theme_provider.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  final TextEditingController searchController = TextEditingController();

  String searchQuery = '';

  // ============================================================
  // ORDERS DATA
  // ============================================================

  final List<OrderItem> orders = [
    OrderItem(
      id: '#ORD-001',
      customer: 'Ali Ahmed',
      phone: '0300-1234567',
      cake: 'Chocolate Cake',
      quantity: 1,
      price: 2500,
      status: 'Pending',
      date: '19 Aug 2026',
    ),
    OrderItem(
      id: '#ORD-002',
      customer: 'Sara Khan',
      phone: '0312-9876543',
      cake: 'Red Velvet Cake',
      quantity: 1,
      price: 3000,
      status: 'Completed',
      date: '18 Aug 2026',
    ),
    OrderItem(
      id: '#ORD-003',
      customer: 'Usman Ali',
      phone: '0333-4567890',
      cake: 'Birthday Cake',
      quantity: 1,
      price: 2000,
      status: 'Processing',
      date: '18 Aug 2026',
    ),
    OrderItem(
      id: '#ORD-004',
      customer: 'Ayesha',
      phone: '0301-1122334',
      cake: 'Wedding Cake',
      quantity: 1,
      price: 8500,
      status: 'Pending',
      date: '17 Aug 2026',
    ),
    OrderItem(
      id: '#ORD-005',
      customer: 'Hassan Raza',
      phone: '0321-5566778',
      cake: 'Vanilla Cake',
      quantity: 2,
      price: 4000,
      status: 'Completed',
      date: '16 Aug 2026',
    ),
    OrderItem(
      id: '#ORD-006',
      customer: 'Maham',
      phone: '0345-9988776',
      cake: 'Strawberry Cake',
      quantity: 1,
      price: 2800,
      status: 'Cancelled',
      date: '15 Aug 2026',
    ),
  ];

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // ============================================================
  // FILTERED ORDERS
  // ============================================================

  List<OrderItem> get filteredOrders {
    final query = searchQuery.trim().toLowerCase();

    if (query.isEmpty) {
      return orders;
    }

    return orders.where((order) {
      return order.id.toLowerCase().contains(query) ||
          order.customer.toLowerCase().contains(query) ||
          order.phone.toLowerCase().contains(query) ||
          order.cake.toLowerCase().contains(query) ||
          order.status.toLowerCase().contains(query);
    }).toList();
  }

  // ============================================================
  // ORDER COUNTS
  // ============================================================

  int get pendingOrders {
    return orders.where((order) => order.status == 'Pending').length;
  }

  int get processingOrders {
    return orders.where((order) => order.status == 'Processing').length;
  }

  int get completedOrders {
    return orders.where((order) => order.status == 'Completed').length;
  }

  double get totalRevenue {
    return orders
        .where((order) => order.status != 'Cancelled')
        .fold<double>(
          0,
          (sum, order) => sum + order.price,
        );
  }

  // ============================================================
  // COLORS
  // ============================================================

  Color backgroundColor(bool isDark) {
    return isDark
        ? const Color(0xFF101010)
        : const Color(0xFFF7F3EF);
  }

  Color cardColor(bool isDark) {
    return isDark ? const Color(0xFF1B1B1B) : Colors.white;
  }

  Color secondaryCardColor(bool isDark) {
    return isDark
        ? const Color(0xFF242424)
        : const Color(0xFFF9F6F2);
  }

  Color primaryTextColor(bool isDark) {
    return isDark ? Colors.white : AppColors.brown;
  }

  Color secondaryTextColor(bool isDark) {
    return isDark ? Colors.white70 : AppColors.grey;
  }

  Color accentColor(bool isDark) {
    return isDark ? AppColors.gold : AppColors.brown;
  }

  Color iconBackground(bool isDark) {
    return isDark
        ? const Color(0xFF332A22)
        : AppColors.peach;
  }

  Color dividerColor(bool isDark) {
    return isDark ? Colors.white12 : Colors.black12;
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminThemeProvider>(
      builder: (
        context,
        themeProvider,
        child,
      ) {
        final bool isDark =
            themeProvider.themeMode == ThemeMode.dark;

        final double width = MediaQuery.of(context).size.width;

        final bool isDesktop = width >= 1000;

        return Scaffold(
          backgroundColor: backgroundColor(isDark),

          // ======================================================
          // APP BAR
          // ======================================================

          appBar: AppBar(
            elevation: 0,
            backgroundColor: cardColor(isDark),
            surfaceTintColor: Colors.transparent,

            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_rounded,
                color: primaryTextColor(isDark),
              ),
            ),

            title: Text(
              'Orders',
              style: TextStyle(
                color: primaryTextColor(isDark),
                fontWeight: FontWeight.bold,
              ),
            ),

            actions: const [
              SizedBox(width: 8),
            ],
          ),

          // ======================================================
          // BODY
          // ======================================================

          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(
                isDesktop ? 30 : 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(
                    isDesktop,
                    isDark,
                  ),

                  const SizedBox(height: 28),

                  _buildStats(isDark),

                  const SizedBox(height: 28),

                  _buildSearchBar(isDark),

                  const SizedBox(height: 25),

                  _buildOrdersSection(
                    isDesktop,
                    isDark,
                  ),
                ],
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

  Widget _buildHeader(
    bool isDesktop,
    bool isDark,
  ) {
    return LayoutBuilder(
      builder: (
        context,
        constraints,
      ) {
        final bool compact = constraints.maxWidth < 600;

        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Manage Orders',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                  color: primaryTextColor(isDark),
                ),
              ),

              const SizedBox(height: 7),

              Text(
                'View and manage all customer orders.',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  color: secondaryTextColor(isDark),
                ),
              ),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Manage Orders',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: isDesktop ? 30 : 25,
                      fontWeight: FontWeight.w800,
                      color: primaryTextColor(isDark),
                    ),
                  ),

                  const SizedBox(height: 7),

                  Text(
                    'View and manage all customer orders.',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: secondaryTextColor(isDark),
                    ),
                  ),
                ],
              ),
            ),

            if (isDesktop) ...[
              const SizedBox(width: 20),

              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: cardColor(isDark),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.shopping_bag_outlined,
                  color: accentColor(isDark),
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  // ============================================================
  // STATS
  // FIXED OVERFLOW VERSION
  // ============================================================

  Widget _buildStats(bool isDark) {
    final stats = [
      _OrderStat(
        title: 'Total Orders',
        value: orders.length.toString(),
        icon: Icons.shopping_bag_outlined,
      ),
      _OrderStat(
        title: 'Pending',
        value: pendingOrders.toString(),
        icon: Icons.pending_actions_rounded,
      ),
      _OrderStat(
        title: 'Processing',
        value: processingOrders.toString(),
        icon: Icons.sync_rounded,
      ),
      _OrderStat(
        title: 'Revenue',
        value: 'Rs ${totalRevenue.toStringAsFixed(0)}',
        icon: Icons.payments_outlined,
      ),
    ];

    return LayoutBuilder(
      builder: (
        context,
        constraints,
      ) {
        final double availableWidth = constraints.maxWidth;

        int columns;

        if (availableWidth >= 1200) {
          columns = 4;
        } else if (availableWidth >= 700) {
          columns = 2;
        } else {
          columns = 1;
        }

        const double spacing = 16;

        final double cardWidth = columns == 1
            ? availableWidth
            : (availableWidth -
                    ((columns - 1) * spacing)) /
                columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: stats.map((stat) {
            return SizedBox(
              width: cardWidth,
              child: _buildStatCard(
                stat,
                isDark,
                cardWidth,
              ),
            );
          }).toList(),
        );
      },
    );
  }

  // ============================================================
  // STAT CARD
  // OVERFLOW SAFE
  // ============================================================

  Widget _buildStatCard(
    _OrderStat stat,
    bool isDark,
    double cardWidth,
  ) {
    final bool verySmall = cardWidth < 260;

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(
        minHeight: 92,
      ),
      padding: EdgeInsets.all(
        verySmall ? 13 : 17,
      ),
      decoration: BoxDecoration(
        color: cardColor(isDark),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: dividerColor(isDark),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: verySmall ? 44 : 52,
            height: verySmall ? 44 : 52,
            decoration: BoxDecoration(
              color: iconBackground(isDark),
              borderRadius: BorderRadius.circular(
                verySmall ? 13 : 15,
              ),
            ),
            child: Icon(
              stat.icon,
              size: verySmall ? 21 : 25,
              color: accentColor(isDark),
            ),
          ),

          SizedBox(
            width: verySmall ? 10 : 14,
          ),

          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stat.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: verySmall ? 11 : 12,
                    color: secondaryTextColor(isDark),
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  stat.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: verySmall ? 18 : 21,
                    fontWeight: FontWeight.w800,
                    color: primaryTextColor(isDark),
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
  // SEARCH BAR
  // ============================================================

  Widget _buildSearchBar(bool isDark) {
    final Color background = isDark
        ? const Color(0xFF242424)
        : Colors.white;

    return TextField(
      controller: searchController,

      onChanged: (value) {
        setState(() {
          searchQuery = value;
        });
      },

      style: TextStyle(
        color: primaryTextColor(isDark),
      ),

      decoration: InputDecoration(
        filled: true,
        fillColor: background,

        hintText:
            'Search by order ID, customer, cake or status...',

        hintStyle: TextStyle(
          color: secondaryTextColor(isDark),
        ),

        prefixIcon: Icon(
          Icons.search_rounded,
          color: accentColor(isDark),
        ),

        suffixIcon: searchQuery.isNotEmpty
            ? IconButton(
                onPressed: () {
                  searchController.clear();

                  setState(() {
                    searchQuery = '';
                  });
                },
                icon: Icon(
                  Icons.close_rounded,
                  color: secondaryTextColor(isDark),
                ),
              )
            : null,

        contentPadding: const EdgeInsets.symmetric(
          vertical: 17,
          horizontal: 16,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: accentColor(isDark),
            width: 1.5,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // ORDERS SECTION
  // ============================================================

  Widget _buildOrdersSection(
    bool isDesktop,
    bool isDark,
  ) {
    final filtered = filteredOrders;

    if (filtered.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 55,
        ),
        decoration: BoxDecoration(
          color: cardColor(isDark),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 55,
              color: accentColor(isDark),
            ),

            const SizedBox(height: 15),

            Text(
              'No orders found',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primaryTextColor(isDark),
              ),
            ),
          ],
        ),
      );
    }

    if (isDesktop) {
      return _buildDesktopTable(
        filtered,
        isDark,
      );
    }

    return Column(
      children: filtered.map((order) {
        return Padding(
          padding: const EdgeInsets.only(
            bottom: 15,
          ),
          child: _buildMobileCard(
            order,
            isDark,
          ),
        );
      }).toList(),
    );
  }

  // ============================================================
  // DESKTOP TABLE
  // ============================================================

  Widget _buildDesktopTable(
    List<OrderItem> filtered,
    bool isDark,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardColor(isDark),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: dividerColor(isDark),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowHeight: 58,
            dataRowMinHeight: 72,
            dataRowMaxHeight: 85,
            columnSpacing: 30,
            horizontalMargin: 18,

            headingRowColor:
                WidgetStateProperty.all(
              secondaryCardColor(isDark),
            ),

            dataRowColor:
                WidgetStateProperty.all(
              cardColor(isDark),
            ),

            columns: [
              _column('Order', isDark),
              _column('Customer', isDark),
              _column('Cake', isDark),
              _column('Price', isDark),
              _column('Status', isDark),
              _column('Date', isDark),
              _column('Action', isDark),
            ],

            rows: filtered.map((order) {
              return DataRow(
                cells: [
                  DataCell(
                    Text(
                      order.id,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: primaryTextColor(isDark),
                      ),
                    ),
                  ),

                  DataCell(
                    SizedBox(
                      width: 150,
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.customer,
                            maxLines: 1,
                            overflow:
                                TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight:
                                  FontWeight.w600,
                              color:
                                  primaryTextColor(
                                isDark,
                              ),
                            ),
                          ),
                          Text(
                            order.phone,
                            maxLines: 1,
                            overflow:
                                TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              color:
                                  secondaryTextColor(
                                isDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  DataCell(
                    SizedBox(
                      width: 130,
                      child: Text(
                        order.cake,
                        maxLines: 1,
                        overflow:
                            TextOverflow.ellipsis,
                        style: TextStyle(
                          color:
                              primaryTextColor(
                            isDark,
                          ),
                        ),
                      ),
                    ),
                  ),

                  DataCell(
                    Text(
                      'Rs ${order.price.toStringAsFixed(0)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: primaryTextColor(isDark),
                      ),
                    ),
                  ),

                  DataCell(
                    _statusBadge(
                      order.status,
                      isDark,
                    ),
                  ),

                  DataCell(
                    Text(
                      order.date,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: primaryTextColor(isDark),
                      ),
                    ),
                  ),

                  DataCell(
                    IconButton(
                      tooltip: 'View Details',
                      onPressed: () {
                        _showOrderDetails(order);
                      },
                      icon: Icon(
                        Icons.visibility_outlined,
                        color: accentColor(isDark),
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // TABLE COLUMN
  // ============================================================

  DataColumn _column(
    String title,
    bool isDark,
  ) {
    return DataColumn(
      label: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: primaryTextColor(isDark),
        ),
      ),
    );
  }

  // ============================================================
  // STATUS BADGE
  // ============================================================

  Widget _statusBadge(
    String status,
    bool isDark,
  ) {
    Color color;

    switch (status) {
      case 'Completed':
        color = Colors.green;
        break;

      case 'Processing':
        color = Colors.orange;
        break;

      case 'Cancelled':
        color = Colors.red;
        break;

      default:
        color = accentColor(isDark);
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Text(
        status,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // ============================================================
  // MOBILE CARD
  // ============================================================

  Widget _buildMobileCard(
    OrderItem order,
    bool isDark,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: cardColor(isDark),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: dividerColor(isDark),
        ),
      ),
      child: Column(
        children: [
          // ======================================================
          // TOP ROW
          // ======================================================

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: iconBackground(isDark),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.cake_rounded,
                  color: accentColor(isDark),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.customer,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color:
                            primaryTextColor(isDark),
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      order.id,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            secondaryTextColor(isDark),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              Flexible(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: _statusBadge(
                    order.status,
                    isDark,
                  ),
                ),
              ),
            ],
          ),

          Divider(
            height: 28,
            color: dividerColor(isDark),
          ),

          // ======================================================
          // INFO
          // ======================================================

          _infoRow(
            Icons.cake_outlined,
            'Cake',
            order.cake,
            isDark,
          ),

          const SizedBox(height: 10),

          _infoRow(
            Icons.phone_outlined,
            'Phone',
            order.phone,
            isDark,
          ),

          const SizedBox(height: 10),

          _infoRow(
            Icons.payments_outlined,
            'Price',
            'Rs ${order.price.toStringAsFixed(0)}',
            isDark,
          ),

          const SizedBox(height: 10),

          _infoRow(
            Icons.calendar_today_outlined,
            'Date',
            order.date,
            isDark,
          ),

          const SizedBox(height: 16),

          // ======================================================
          // VIEW DETAILS
          // ======================================================

          SizedBox(
            width: double.infinity,
            height: 45,
            child: OutlinedButton.icon(
              onPressed: () {
                _showOrderDetails(order);
              },
              icon: const Icon(
                Icons.visibility_outlined,
                size: 18,
              ),
              label: const Text(
                'View Details',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: accentColor(isDark),
                side: BorderSide(
                  color: accentColor(isDark),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // INFO ROW
  // ============================================================

  Widget _infoRow(
    IconData icon,
    String title,
    String value,
    bool isDark,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 18,
          color: accentColor(isDark),
        ),

        const SizedBox(width: 9),

        Text(
          '$title:',
          maxLines: 1,
          style: TextStyle(
            color: secondaryTextColor(isDark),
            fontSize: 13,
          ),
        ),

        const SizedBox(width: 7),

        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: primaryTextColor(isDark),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // ORDER DETAILS
  // ============================================================

  void _showOrderDetails(
    OrderItem order,
  ) {
    final bool isDark =
        context.read<AdminThemeProvider>().themeMode ==
            ThemeMode.dark;

    showDialog(
      context: context,
      builder: (
        dialogContext,
      ) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 24,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 500,
              maxHeight: 650,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: cardColor(isDark),
                borderRadius: BorderRadius.circular(22),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(22),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ==================================================
                    // DIALOG HEADER
                    // ==================================================

                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Order Details',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 21,
                              color:
                                  primaryTextColor(isDark),
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ),

                        IconButton(
                          onPressed: () {
                            Navigator.pop(
                              dialogContext,
                            );
                          },
                          icon: Icon(
                            Icons.close_rounded,
                            color:
                                secondaryTextColor(
                              isDark,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Divider(
                      color: dividerColor(isDark),
                    ),

                    const SizedBox(height: 15),

                    // ==================================================
                    // DETAILS
                    // ==================================================

                    _detailRow(
                      'Order ID',
                      order.id,
                      isDark,
                    ),

                    _detailRow(
                      'Customer',
                      order.customer,
                      isDark,
                    ),

                    _detailRow(
                      'Phone',
                      order.phone,
                      isDark,
                    ),

                    _detailRow(
                      'Cake',
                      order.cake,
                      isDark,
                    ),

                    _detailRow(
                      'Quantity',
                      order.quantity.toString(),
                      isDark,
                    ),

                    _detailRow(
                      'Price',
                      'Rs ${order.price.toStringAsFixed(0)}',
                      isDark,
                    ),

                    _detailRow(
                      'Status',
                      order.status,
                      isDark,
                    ),

                    _detailRow(
                      'Date',
                      order.date,
                      isDark,
                    ),

                    const SizedBox(height: 8),

                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(
                            dialogContext,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              accentColor(isDark),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              12,
                            ),
                          ),
                        ),
                        child: const Text(
                          'Close',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // DETAIL ROW
  // ============================================================

  Widget _detailRow(
    String title,
    String value,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 14,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: secondaryTextColor(isDark),
                fontSize: 13,
              ),
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: primaryTextColor(isDark),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ================================================================
// ORDER MODEL
// ================================================================

class OrderItem {
  final String id;
  final String customer;
  final String phone;
  final String cake;
  final int quantity;
  final double price;
  final String status;
  final String date;

  OrderItem({
    required this.id,
    required this.customer,
    required this.phone,
    required this.cake,
    required this.quantity,
    required this.price,
    required this.status,
    required this.date,
  });
}

// ================================================================
// ORDER STAT MODEL
// ================================================================

class _OrderStat {
  final String title;
  final String value;
  final IconData icon;

  const _OrderStat({
    required this.title,
    required this.value,
    required this.icon,
  });
}
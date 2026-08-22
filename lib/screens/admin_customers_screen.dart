import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_colors.dart';
import '../providers/admin_theme_provider.dart';

class AdminCustomersScreen extends StatefulWidget {
  const AdminCustomersScreen({super.key});

  @override
  State<AdminCustomersScreen> createState() => _AdminCustomersScreenState();
}

class _AdminCustomersScreenState extends State<AdminCustomersScreen> {
  final TextEditingController searchController = TextEditingController();

  String searchQuery = '';

  final List<CustomerItem> customers = [
    CustomerItem(
      id: '#CUS-001',
      name: 'Ali Ahmed',
      phone: '0300-1234567',
      email: 'ali@example.com',
      address: 'Sahiwal, Punjab',
      orders: 5,
      totalSpent: 12500,
      joinedDate: '10 Aug 2026',
    ),
    CustomerItem(
      id: '#CUS-002',
      name: 'Sara Khan',
      phone: '0312-9876543',
      email: 'sara@example.com',
      address: 'Faridia Park, Sahiwal',
      orders: 8,
      totalSpent: 24000,
      joinedDate: '08 Aug 2026',
    ),
    CustomerItem(
      id: '#CUS-003',
      name: 'Usman Ali',
      phone: '0333-4567890',
      email: 'usman@example.com',
      address: 'Civil Lines, Sahiwal',
      orders: 3,
      totalSpent: 8500,
      joinedDate: '05 Aug 2026',
    ),
    CustomerItem(
      id: '#CUS-004',
      name: 'Ayesha',
      phone: '0301-1122334',
      email: 'ayesha@example.com',
      address: 'Jinnah Road, Sahiwal',
      orders: 7,
      totalSpent: 18500,
      joinedDate: '01 Aug 2026',
    ),
    CustomerItem(
      id: '#CUS-005',
      name: 'Hassan Raza',
      phone: '0321-5566778',
      email: 'hassan@example.com',
      address: 'College Road, Sahiwal',
      orders: 4,
      totalSpent: 11200,
      joinedDate: '28 Jul 2026',
    ),
    CustomerItem(
      id: '#CUS-006',
      name: 'Maham',
      phone: '0345-9988776',
      email: 'maham@example.com',
      address: 'Railway Road, Sahiwal',
      orders: 2,
      totalSpent: 6200,
      joinedDate: '25 Jul 2026',
    ),
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<CustomerItem> get filteredCustomers {
    final query = searchQuery.trim().toLowerCase();

    if (query.isEmpty) {
      return customers;
    }

    return customers.where((customer) {
      return customer.id.toLowerCase().contains(query) ||
          customer.name.toLowerCase().contains(query) ||
          customer.phone.toLowerCase().contains(query) ||
          customer.email.toLowerCase().contains(query) ||
          customer.address.toLowerCase().contains(query);
    }).toList();
  }

  int get totalOrders {
    return customers.fold(
      0,
      (sum, customer) => sum + customer.orders,
    );
  }

  double get totalRevenue {
    return customers.fold(
      0,
      (sum, customer) => sum + customer.totalSpent,
    );
  }

  int get activeCustomers {
    return customers.where((customer) {
      return customer.orders > 0;
    }).length;
  }

  Color backgroundColor(bool isDark) {
    return isDark
        ? const Color(0xFF101010)
        : const Color(0xFFF7F3EF);
  }

  Color cardColor(bool isDark) {
    return isDark
        ? const Color(0xFF1B1B1B)
        : Colors.white;
  }

  Color secondaryCardColor(bool isDark) {
    return isDark
        ? const Color(0xFF242424)
        : const Color(0xFFF9F6F2);
  }

  Color primaryTextColor(bool isDark) {
    return isDark
        ? Colors.white
        : AppColors.brown;
  }

  Color secondaryTextColor(bool isDark) {
    return isDark
        ? Colors.white70
        : AppColors.grey;
  }

  Color accentColor(bool isDark) {
    return isDark
        ? AppColors.gold
        : AppColors.brown;
  }

  Color iconBackground(bool isDark) {
    return isDark
        ? const Color(0xFF332A22)
        : AppColors.peach;
  }

  Color dividerColor(bool isDark) {
    return isDark
        ? Colors.white12
        : Colors.black12;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminThemeProvider>(
      builder: (context, themeProvider, child) {
        final bool isDark =
            themeProvider.themeMode == ThemeMode.dark;

        final double width =
            MediaQuery.of(context).size.width;

        final bool isDesktop = width >= 1000;

        return Scaffold(
          backgroundColor: backgroundColor(isDark),

          // AppBar
          // Dark/Light mode button removed from right side.
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
              'Customers',
              style: TextStyle(
                color: primaryTextColor(isDark),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(
                isDesktop ? 30 : 18,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
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

                  _buildCustomersSection(
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
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                'Manage Customers',
                style: TextStyle(
                  fontSize: isDesktop ? 30 : 25,
                  fontWeight: FontWeight.w800,
                  color: primaryTextColor(isDark),
                ),
              ),

              const SizedBox(height: 7),

              Text(
                'View and manage all registered customers.',
                style: TextStyle(
                  fontSize: 14,
                  color: secondaryTextColor(isDark),
                ),
              ),
            ],
          ),
        ),

        if (isDesktop)
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: cardColor(isDark),
              borderRadius:
                  BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.people_alt_outlined,
              color: accentColor(isDark),
            ),
          ),
      ],
    );
  }

  // ============================================================
  // STATS
  // ============================================================

  Widget _buildStats(bool isDark) {
    final stats = [
      _CustomerStat(
        title: 'Total Customers',
        value: customers.length.toString(),
        icon: Icons.people_alt_outlined,
      ),
      _CustomerStat(
        title: 'Total Orders',
        value: totalOrders.toString(),
        icon: Icons.shopping_bag_outlined,
      ),
      _CustomerStat(
        title: 'Total Revenue',
        value:
            'Rs ${totalRevenue.toStringAsFixed(0)}',
        icon: Icons.payments_outlined,
      ),
      _CustomerStat(
        title: 'Active Customers',
        value: activeCustomers.toString(),
        icon: Icons.person_outline_rounded,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        int columns;

        if (constraints.maxWidth >= 1100) {
          columns = 4;
        } else if (constraints.maxWidth >= 650) {
          columns = 2;
        } else {
          columns = 1;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics:
              const NeverScrollableScrollPhysics(),
          itemCount: stats.length,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: columns == 1
                ? 4.2
                : columns == 2
                    ? 2.1
                    : 1.9,
          ),
          itemBuilder: (context, index) {
            return _buildStatCard(
              stats[index],
              isDark,
            );
          },
        );
      },
    );
  }

  Widget _buildStatCard(
    _CustomerStat stat,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor(isDark),
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: dividerColor(isDark),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: iconBackground(isDark),
              borderRadius:
                  BorderRadius.circular(15),
            ),
            child: Icon(
              stat.icon,
              size: 25,
              color: accentColor(isDark),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  stat.title,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color:
                        secondaryTextColor(
                      isDark,
                    ),
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  stat.value,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight:
                        FontWeight.w800,
                    color:
                        primaryTextColor(
                      isDark,
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
  // SEARCH BAR
  // ============================================================

  Widget _buildSearchBar(bool isDark) {
    final Color background =
        isDark
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
            'Search by name, phone, email or ID...',

        hintStyle: TextStyle(
          color: secondaryTextColor(isDark),
        ),

        prefixIcon: Icon(
          Icons.search_rounded,
          color: accentColor(isDark),
        ),

        suffixIcon:
            searchQuery.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      searchController.clear();

                      setState(() {
                        searchQuery = '';
                      });
                    },
                    icon: Icon(
                      Icons.close_rounded,
                      color:
                          secondaryTextColor(
                        isDark,
                      ),
                    ),
                  )
                : null,

        contentPadding:
            const EdgeInsets.symmetric(
          vertical: 17,
        ),

        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(16),
          borderSide: BorderSide(
            color: accentColor(isDark),
            width: 1.5,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // CUSTOMERS SECTION
  // ============================================================

  Widget _buildCustomersSection(
    bool isDesktop,
    bool isDark,
  ) {
    final filtered = filteredCustomers;

    if (filtered.isEmpty) {
      return _buildEmptyState(isDark);
    }

    if (isDesktop) {
      return _buildDesktopTable(
        filtered,
        isDark,
      );
    }

    return Column(
      children: filtered.map((customer) {
        return Padding(
          padding:
              const EdgeInsets.only(
            bottom: 16,
          ),
          child:
              _buildMobileCustomerCard(
            customer,
            isDark,
          ),
        );
      }).toList(),
    );
  }

  // ============================================================
  // EMPTY STATE
  // ============================================================

  Widget _buildEmptyState(bool isDark) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.symmetric(
        vertical: 70,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: cardColor(isDark),
        borderRadius:
            BorderRadius.circular(20),
        border: Border.all(
          color: dividerColor(isDark),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.people_outline_rounded,
            size: 55,
            color: accentColor(isDark),
          ),

          const SizedBox(height: 18),

          Text(
            'No customers found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: primaryTextColor(isDark),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Try changing your search.',
            style: TextStyle(
              color:
                  secondaryTextColor(isDark),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DESKTOP TABLE
  // ============================================================

  Widget _buildDesktopTable(
    List<CustomerItem> filtered,
    bool isDark,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardColor(isDark),
        borderRadius:
            BorderRadius.circular(20),
        border: Border.all(
          color: dividerColor(isDark),
        ),
      ),
      child: ClipRRect(
        borderRadius:
            BorderRadius.circular(20),
        child: SingleChildScrollView(
          scrollDirection:
              Axis.horizontal,
          child: DataTable(
            headingRowHeight: 58,
            dataRowMinHeight: 72,
            dataRowMaxHeight: 85,
            columnSpacing: 35,
            horizontalMargin: 20,

            headingRowColor:
                WidgetStateProperty.all(
              secondaryCardColor(isDark),
            ),

            dataRowColor:
                WidgetStateProperty.all(
              cardColor(isDark),
            ),

            columns: [
              _dataColumn(
                'Customer',
                isDark,
              ),
              _dataColumn(
                'Contact',
                isDark,
              ),
              _dataColumn(
                'Orders',
                isDark,
              ),
              _dataColumn(
                'Total Spent',
                isDark,
              ),
              _dataColumn(
                'Joined',
                isDark,
              ),
              _dataColumn(
                'Action',
                isDark,
              ),
            ],

            rows: filtered.map((customer) {
              return DataRow(
                cells: [
                  DataCell(
                    Row(
                      mainAxisSize:
                          MainAxisSize.min,
                      children: [
                        _customerAvatar(
                          customer,
                          isDark,
                        ),

                        const SizedBox(
                          width: 12,
                        ),

                        Column(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .center,
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            Text(
                              customer.name,
                              style: TextStyle(
                                fontWeight:
                                    FontWeight
                                        .w600,
                                color:
                                    primaryTextColor(
                                  isDark,
                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 3,
                            ),

                            Text(
                              customer.id,
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
                      ],
                    ),
                  ),

                  DataCell(
                    Column(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .center,
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        Text(
                          customer.phone,
                          style: TextStyle(
                            color:
                                primaryTextColor(
                              isDark,
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 3,
                        ),

                        Text(
                          customer.email,
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

                  DataCell(
                    _numberBadge(
                      customer.orders
                          .toString(),
                      isDark,
                    ),
                  ),

                  DataCell(
                    Text(
                      'Rs ${customer.totalSpent.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold,
                        color:
                            primaryTextColor(
                          isDark,
                        ),
                      ),
                    ),
                  ),

                  DataCell(
                    Text(
                      customer.joinedDate,
                      style: TextStyle(
                        color:
                            primaryTextColor(
                          isDark,
                        ),
                      ),
                    ),
                  ),

                  DataCell(
                    Row(
                      mainAxisSize:
                          MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip:
                              'View Details',
                          onPressed: () {
                            _showCustomerDetails(
                              customer,
                            );
                          },
                          icon: Icon(
                            Icons
                                .visibility_outlined,
                            color:
                                accentColor(
                              isDark,
                            ),
                          ),
                        ),

                        IconButton(
                          tooltip:
                              'Delete Customer',
                          onPressed: () {
                            _deleteCustomer(
                              customer,
                            );
                          },
                          icon: const Icon(
                            Icons
                                .delete_outline_rounded,
                            color: Colors.red,
                          ),
                        ),
                      ],
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

  DataColumn _dataColumn(
    String title,
    bool isDark,
  ) {
    return DataColumn(
      label: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color:
              primaryTextColor(isDark),
        ),
      ),
    );
  }

  // ============================================================
  // NUMBER BADGE
  // ============================================================

  Widget _numberBadge(
    String number,
    bool isDark,
  ) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: iconBackground(isDark),
        borderRadius:
            BorderRadius.circular(10),
      ),
      child: Text(
        number,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: accentColor(isDark),
        ),
      ),
    );
  }

  // ============================================================
  // MOBILE CUSTOMER CARD
  // ============================================================

  Widget _buildMobileCustomerCard(
    CustomerItem customer,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: cardColor(isDark),
        borderRadius:
            BorderRadius.circular(20),
        border: Border.all(
          color: dividerColor(isDark),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _customerAvatar(
                customer,
                isDark,
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer.name,
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold,
                        fontSize: 16,
                        color:
                            primaryTextColor(
                          isDark,
                        ),
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      customer.id,
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            secondaryTextColor(
                          isDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              _numberBadge(
                '${customer.orders}',
                isDark,
              ),
            ],
          ),

          Divider(
            height: 26,
            color: dividerColor(isDark),
          ),

          _mobileInfoRow(
            Icons.phone_outlined,
            'Phone',
            customer.phone,
            isDark,
          ),

          const SizedBox(height: 11),

          _mobileInfoRow(
            Icons.email_outlined,
            'Email',
            customer.email,
            isDark,
          ),

          const SizedBox(height: 11),

          _mobileInfoRow(
            Icons.location_on_outlined,
            'Address',
            customer.address,
            isDark,
          ),

          const SizedBox(height: 11),

          _mobileInfoRow(
            Icons.payments_outlined,
            'Spent',
            'Rs ${customer.totalSpent.toStringAsFixed(0)}',
            isDark,
          ),

          const SizedBox(height: 17),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    _showCustomerDetails(
                      customer,
                    );
                  },
                  icon: const Icon(
                    Icons.visibility_outlined,
                    size: 18,
                  ),
                  label:
                      const Text(
                    'View Details',
                  ),
                  style:
                      OutlinedButton.styleFrom(
                    foregroundColor:
                        accentColor(isDark),
                    side: BorderSide(
                      color:
                          accentColor(
                        isDark,
                      ),
                    ),
                    minimumSize:
                        const Size(
                      0,
                      46,
                    ),
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius
                              .circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              SizedBox(
                height: 46,
                width: 46,
                child: IconButton(
                  onPressed: () {
                    _deleteCustomer(
                      customer,
                    );
                  },
                  style:
                      IconButton.styleFrom(
                    backgroundColor:
                        Colors.red
                            .withOpacity(
                      isDark
                          ? 0.15
                          : 0.08,
                    ),
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius
                              .circular(12),
                    ),
                  ),
                  icon: const Icon(
                    Icons
                        .delete_outline_rounded,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CUSTOMER AVATAR
  // ============================================================

  Widget _customerAvatar(
    CustomerItem customer,
    bool isDark,
  ) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: iconBackground(isDark),
        borderRadius:
            BorderRadius.circular(14),
      ),
      child: Center(
        child: Text(
          customer.name
              .substring(0, 1)
              .toUpperCase(),
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: accentColor(isDark),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // MOBILE INFO ROW
  // ============================================================

  Widget _mobileInfoRow(
    IconData icon,
    String title,
    String value,
    bool isDark,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 19,
          color: accentColor(isDark),
        ),

        const SizedBox(width: 10),

        Text(
          '$title:',
          style: TextStyle(
            fontSize: 13,
            color:
                secondaryTextColor(isDark),
          ),
        ),

        const SizedBox(width: 7),

        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow:
                TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight:
                  FontWeight.w600,
              color:
                  primaryTextColor(isDark),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // CUSTOMER DETAILS
  // ============================================================

  void _showCustomerDetails(
    CustomerItem customer,
  ) {
    final bool isDark =
        context
            .read<AdminThemeProvider>()
            .themeMode ==
        ThemeMode.dark;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor:
              cardColor(isDark),
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(24),
          ),
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(
              maxWidth: 550,
            ),
            child:
                SingleChildScrollView(
              padding:
                  const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Customer Details',
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight:
                                FontWeight.bold,
                            color:
                                primaryTextColor(
                              isDark,
                            ),
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
                          Icons
                              .close_rounded,
                          color:
                              secondaryTextColor(
                            isDark,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Center(
                    child:
                        _customerAvatar(
                      customer,
                      isDark,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Center(
                    child: Text(
                      customer.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight:
                            FontWeight.bold,
                        color:
                            primaryTextColor(
                          isDark,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 5),

                  Center(
                    child: Text(
                      customer.id,
                      style: TextStyle(
                        color:
                            secondaryTextColor(
                          isDark,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  _detailSection(
                    isDark: isDark,
                    icon:
                        Icons.person_outline,
                    title:
                        'Personal Information',
                    child: Column(
                      children: [
                        _infoRow(
                          'Name',
                          customer.name,
                          isDark,
                        ),
                        _infoRow(
                          'Phone',
                          customer.phone,
                          isDark,
                        ),
                        _infoRow(
                          'Email',
                          customer.email,
                          isDark,
                        ),
                        _infoRow(
                          'Address',
                          customer.address,
                          isDark,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  _detailSection(
                    isDark: isDark,
                    icon: Icons
                        .shopping_bag_outlined,
                    title:
                        'Order Information',
                    child: Column(
                      children: [
                        _infoRow(
                          'Total Orders',
                          customer.orders
                              .toString(),
                          isDark,
                        ),
                        _infoRow(
                          'Total Spent',
                          'Rs ${customer.totalSpent.toStringAsFixed(0)}',
                          isDark,
                        ),
                        _infoRow(
                          'Joined',
                          customer.joinedDate,
                          isDark,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  SizedBox(
                    width:
                        double.infinity,
                    height: 52,
                    child:
                        ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(
                          dialogContext,
                        );

                        _deleteCustomer(
                          customer,
                        );
                      },
                      icon: const Icon(
                        Icons
                            .delete_outline_rounded,
                      ),
                      label: const Text(
                        'Delete Customer',
                        style: TextStyle(
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                      style:
                          ElevatedButton
                              .styleFrom(
                        backgroundColor:
                            Colors.red,
                        foregroundColor:
                            Colors.white,
                        elevation: 0,
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(
                            14,
                          ),
                        ),
                      ),
                    ),
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
  // DETAIL SECTION
  // ============================================================

  Widget _detailSection({
    required bool isDark,
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            secondaryCardColor(isDark),
        borderRadius:
            BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 19,
                color: accentColor(isDark),
              ),

              const SizedBox(width: 8),

              Text(
                title,
                style: TextStyle(
                  fontWeight:
                      FontWeight.bold,
                  color:
                      primaryTextColor(
                    isDark,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 13),

          child,
        ],
      ),
    );
  }

  // ============================================================
  // DETAIL INFO ROW
  // ============================================================

  Widget _infoRow(
    String title,
    String value,
    bool isDark,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 9,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color:
                    secondaryTextColor(
                  isDark,
                ),
              ),
            ),
          ),

          Flexible(
            child: Text(
              value,
              textAlign:
                  TextAlign.end,
              overflow:
                  TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight:
                    FontWeight.bold,
                color:
                    primaryTextColor(
                  isDark,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DELETE CUSTOMER
  // ============================================================

  void _deleteCustomer(
    CustomerItem customer,
  ) {
    final bool isDark =
        context
            .read<AdminThemeProvider>()
            .themeMode ==
        ThemeMode.dark;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor:
              cardColor(isDark),

          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20),
          ),

          title: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration:
                    BoxDecoration(
                  color: Colors.red
                      .withOpacity(
                    isDark
                        ? 0.15
                        : 0.08,
                  ),
                  borderRadius:
                      BorderRadius
                          .circular(12),
                ),
                child: const Icon(
                  Icons
                      .warning_amber_rounded,
                  color: Colors.red,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  'Delete Customer?',
                  style: TextStyle(
                    color:
                        primaryTextColor(
                      isDark,
                    ),
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          content: Text(
            'Are you sure you want to delete ${customer.name}? This action cannot be undone.',
            style: TextStyle(
              color:
                  secondaryTextColor(
                isDark,
              ),
              height: 1.4,
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color:
                      secondaryTextColor(
                    isDark,
                  ),
                ),
              ),
            ),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  customers.remove(
                    customer,
                  );
                });

                Navigator.pop(
                  dialogContext,
                );

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Customer deleted successfully',
                    ),
                    behavior:
                        SnackBarBehavior
                            .floating,
                  ),
                );
              },
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.red,
                foregroundColor:
                    Colors.white,
                elevation: 0,
              ),
              child:
                  const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

// ============================================================
// CUSTOMER MODEL
// ============================================================

class CustomerItem {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String address;
  final int orders;
  final double totalSpent;
  final String joinedDate;

  CustomerItem({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.orders,
    required this.totalSpent,
    required this.joinedDate,
  });
}

// ============================================================
// CUSTOMER STAT MODEL
// ============================================================

class _CustomerStat {
  final String title;
  final String value;
  final IconData icon;

  const _CustomerStat({
    required this.title,
    required this.value,
    required this.icon,
  });
}
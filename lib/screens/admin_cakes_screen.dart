import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_colors.dart';
import '../providers/admin_theme_provider.dart';

class AdminCakesScreen extends StatefulWidget {
  const AdminCakesScreen({super.key});

  @override
  State<AdminCakesScreen> createState() => _AdminCakesScreenState();
}

class _AdminCakesScreenState extends State<AdminCakesScreen> {
  final TextEditingController searchController = TextEditingController();

  String searchQuery = '';
  String selectedFilter = 'All';

  final List<CakeItem> cakes = [
    CakeItem(
      name: 'Chocolate Fudge Cake',
      category: 'Chocolate',
      price: 2500,
      image:
          'https://images.unsplash.com/photo-1578985545062-69928b1d9587?auto=format&fit=crop&w=600&q=80',
      available: true,
    ),
    CakeItem(
      name: 'Red Velvet Cake',
      category: 'Red Velvet',
      price: 3000,
      image:
          'https://images.unsplash.com/photo-1586788224331-947f68671cf1?auto=format&fit=crop&w=600&q=80',
      available: true,
    ),
    CakeItem(
      name: 'Birthday Cake',
      category: 'Birthday',
      price: 2000,
      image:
          'https://images.unsplash.com/photo-1551024506-0bccd828d307?auto=format&fit=crop&w=600&q=80',
      available: true,
    ),
    CakeItem(
      name: 'Wedding Cake',
      category: 'Wedding',
      price: 8500,
      image:
          'https://images.unsplash.com/photo-1535254973040-607b474cb50d?auto=format&fit=crop&w=600&q=80',
      available: false,
    ),
    CakeItem(
      name: 'Strawberry Cake',
      category: 'Fruit',
      price: 2800,
      image:
          'https://images.unsplash.com/photo-1565958011703-44f9829ba187?auto=format&fit=crop&w=600&q=80',
      available: true,
    ),
    CakeItem(
      name: 'Vanilla Cream Cake',
      category: 'Vanilla',
      price: 2200,
      image:
          'https://images.unsplash.com/photo-1464349095431-e9a21285b5f3?auto=format&fit=crop&w=600&q=80',
      available: true,
    ),
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // ============================================================
  // FILTERED CAKES
  // ============================================================

  List<CakeItem> get filteredCakes {
    final query = searchQuery.toLowerCase().trim();

    return cakes.where((cake) {
      final matchesSearch =
          cake.name.toLowerCase().contains(query) ||
          cake.category.toLowerCase().contains(query);

      bool matchesFilter = true;

      if (selectedFilter == 'Available') {
        matchesFilter = cake.available;
      } else if (selectedFilter == 'Unavailable') {
        matchesFilter = !cake.available;
      }

      return matchesSearch && matchesFilter;
    }).toList();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminThemeProvider>(
      builder: (context, themeProvider, child) {
        final dark = themeProvider.themeMode == ThemeMode.dark;

        final width = MediaQuery.of(context).size.width;
        final isDesktop = width >= 900;

        return Scaffold(
          backgroundColor:
              dark ? const Color(0xFF0D0F12) : const Color(0xFFF8F4EF),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isDesktop ? 30 : 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(isDesktop, dark),

                  const SizedBox(height: 25),

                  _buildStats(dark),

                  const SizedBox(height: 25),

                  _buildSearchBar(isDesktop, dark),

                  const SizedBox(height: 20),

                  // Active filter
                  if (selectedFilter != 'All')
                    _buildActiveFilter(dark),

                  const SizedBox(height: 10),

                  _buildCakeGrid(dark),
                ],
              ),
            ),
          ),

          floatingActionButton: !isDesktop
              ? FloatingActionButton.extended(
                  onPressed: _showAddCakeDialog,
                  backgroundColor: AppColors.brown,
                  foregroundColor: Colors.white,
                  icon: const Icon(Icons.add),
                  label: const Text(
                    'Add Cake',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              : null,
        );
      },
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader(bool isDesktop, bool dark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: dark ? const Color(0xFF20242A) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: dark
                  ? const Color(0xFF30343B)
                  : const Color(0xFFE8E0D9),
            ),
          ),
          child: IconButton(
            tooltip: 'Back',
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_rounded,
              color: dark ? Colors.white : AppColors.brown,
            ),
          ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Manage Cakes',
                style: TextStyle(
                  fontSize: isDesktop ? 30 : 24,
                  fontWeight: FontWeight.w900,
                  color: dark ? Colors.white : AppColors.brown,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                'Add, edit and manage all your cakes.',
                style: TextStyle(
                  color: dark ? Colors.white70 : AppColors.grey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),

        if (isDesktop)
          ElevatedButton.icon(
            onPressed: _showAddCakeDialog,
            icon: const Icon(Icons.add),
            label: const Text(
              'Add New Cake',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brown,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
      ],
    );
  }

  // ============================================================
  // STATS
  // ============================================================

  Widget _buildStats(bool dark) {
    final available = cakes.where((cake) => cake.available).length;
    final unavailable = cakes.length - available;

    final stats = [
      _CakeStat(
        title: 'Total Cakes',
        value: cakes.length.toString(),
        icon: Icons.cake_outlined,
      ),
      _CakeStat(
        title: 'Available',
        value: available.toString(),
        icon: Icons.check_circle_outline,
      ),
      _CakeStat(
        title: 'Unavailable',
        value: unavailable.toString(),
        icon: Icons.remove_circle_outline,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 600 ? 3 : 1;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: stats.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: columns == 1 ? 4.2 : 2.5,
          ),
          itemBuilder: (context, index) {
            return _buildStatCard(stats[index], dark);
          },
        );
      },
    );
  }

  // ============================================================
  // STAT CARD
  // ============================================================

  Widget _buildStatCard(_CakeStat stat, bool dark) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF181B20) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: dark ? const Color(0xFF30343B) : const Color(0xFFE8E0D9),
        ),
        boxShadow: [
          if (!dark)
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color:
                  dark ? AppColors.peach.withOpacity(0.18) : AppColors.peach,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              stat.icon,
              color: dark ? AppColors.gold : AppColors.brown,
              size: 25,
            ),
          ),
          const SizedBox(width: 14),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                stat.title,
                style: TextStyle(
                  color: dark ? Colors.white70 : AppColors.grey,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                stat.value,
                style: TextStyle(
                  color: dark ? Colors.white : AppColors.brown,
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SEARCH + FILTER
  // ============================================================

  Widget _buildSearchBar(bool isDesktop, bool dark) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: searchController,
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
            style: TextStyle(
              color: dark ? Colors.white : AppColors.brown,
            ),
            decoration: InputDecoration(
              hintText: 'Search cakes...',
              hintStyle: TextStyle(
                color: dark ? Colors.white54 : AppColors.grey,
              ),
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: AppColors.gold,
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
                        Icons.clear,
                        color: dark ? Colors.white70 : AppColors.grey,
                      ),
                    )
                  : null,
              filled: true,
              fillColor: dark ? const Color(0xFF181B20) : Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: dark
                      ? const Color(0xFF30343B)
                      : Colors.transparent,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: dark
                      ? const Color(0xFF30343B)
                      : Colors.transparent,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  color: AppColors.gold,
                  width: 2,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        // ========================================================
        // WORKING FILTER BUTTON
        // ========================================================

        Container(
          height: 55,
          width: 55,
          decoration: BoxDecoration(
            color: dark ? const Color(0xFF181B20) : Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: dark
                  ? const Color(0xFF30343B)
                  : const Color(0xFFE8E0D9),
            ),
          ),
          child: PopupMenuButton<String>(
            tooltip: 'Filter Cakes',
            color: dark ? const Color(0xFF22262C) : Colors.white,
            icon: Icon(
              Icons.filter_list_rounded,
              color: selectedFilter != 'All'
                  ? AppColors.gold
                  : dark
                      ? Colors.white
                      : AppColors.brown,
            ),
            onSelected: (value) {
              setState(() {
                selectedFilter = value;
              });
            },
            itemBuilder: (context) {
              return [
                _buildFilterMenuItem(
                  value: 'All',
                  title: 'All Cakes',
                  icon: Icons.cake_outlined,
                  dark: dark,
                ),
                _buildFilterMenuItem(
                  value: 'Available',
                  title: 'Available',
                  icon: Icons.check_circle_outline,
                  dark: dark,
                ),
                _buildFilterMenuItem(
                  value: 'Unavailable',
                  title: 'Unavailable',
                  icon: Icons.remove_circle_outline,
                  dark: dark,
                ),
              ];
            },
          ),
        ),
      ],
    );
  }

  // ============================================================
  // FILTER MENU ITEM
  // ============================================================

  PopupMenuItem<String> _buildFilterMenuItem({
    required String value,
    required String title,
    required IconData icon,
    required bool dark,
  }) {
    final selected = selectedFilter == value;

    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: selected
                ? AppColors.gold
                : dark
                    ? Colors.white70
                    : AppColors.brown,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: selected
                    ? AppColors.gold
                    : dark
                        ? Colors.white
                        : AppColors.brown,
                fontWeight:
                    selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          if (selected)
            const Icon(
              Icons.check,
              size: 18,
              color: AppColors.gold,
            ),
        ],
      ),
    );
  }

  // ============================================================
  // ACTIVE FILTER
  // ============================================================

  Widget _buildActiveFilter(bool dark) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: dark
                ? AppColors.gold.withOpacity(0.15)
                : AppColors.peach,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.filter_list_rounded,
                size: 17,
                color: dark ? AppColors.gold : AppColors.brown,
              ),
              const SizedBox(width: 6),
              Text(
                selectedFilter,
                style: TextStyle(
                  color: dark ? AppColors.gold : AppColors.brown,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 5),
              InkWell(
                onTap: () {
                  setState(() {
                    selectedFilter = 'All';
                  });
                },
                child: Icon(
                  Icons.close,
                  size: 17,
                  color: dark ? AppColors.gold : AppColors.brown,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // CAKE GRID
  // ============================================================

  Widget _buildCakeGrid(bool dark) {
    final items = filteredCakes;

    if (items.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical: 70,
          horizontal: 20,
        ),
        decoration: BoxDecoration(
          color: dark ? const Color(0xFF181B20) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: dark
                ? const Color(0xFF30343B)
                : const Color(0xFFE8E0D9),
          ),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.search_off_rounded,
              size: 60,
              color: AppColors.gold,
            ),
            const SizedBox(height: 15),
            Text(
              'No cakes found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: dark ? Colors.white : AppColors.brown,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try changing your search or filter.',
              style: TextStyle(
                color: dark ? Colors.white70 : AppColors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        int columns;

        if (constraints.maxWidth >= 1200) {
          columns = 4;
        } else if (constraints.maxWidth >= 800) {
          columns = 3;
        } else if (constraints.maxWidth >= 550) {
          columns = 2;
        } else {
          columns = 1;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 18,
            mainAxisSpacing: 18,
            childAspectRatio: columns == 1 ? 1.25 : 0.72,
          ),
          itemBuilder: (context, index) {
            return _buildCakeCard(items[index], dark);
          },
        );
      },
    );
  }

  // ============================================================
  // CAKE CARD
  // ============================================================

  Widget _buildCakeCard(CakeItem cake, bool dark) {
    return Container(
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF181B20) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: dark
              ? const Color(0xFF30343B)
              : const Color(0xFFE8E0D9),
        ),
        boxShadow: [
          if (!dark)
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.network(
                    cake.image,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) {
                      return Container(
                        color: dark
                            ? const Color(0xFF302923)
                            : AppColors.peach,
                        child: Center(
                          child: Icon(
                            Icons.cake_outlined,
                            size: 65,
                            color: dark
                                ? AppColors.gold
                                : AppColors.brown,
                          ),
                        ),
                      );
                    },
                    loadingBuilder:
                        (context, child, progress) {
                      if (progress == null) {
                        return child;
                      }

                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.gold,
                        ),
                      );
                    },
                  ),
                ),

                if (dark)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.15),
                    ),
                  ),

                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: cake.available
                          ? Colors.green.withOpacity(0.9)
                          : Colors.red.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      cake.available
                          ? 'Available'
                          : 'Unavailable',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.45),
                      shape: BoxShape.circle,
                    ),
                    child: PopupMenuButton<String>(
                      color: dark
                          ? const Color(0xFF252A30)
                          : Colors.white,
                      icon: const Icon(
                        Icons.more_vert_rounded,
                        color: Colors.white,
                      ),
                      onSelected: (value) {
                        if (value == 'edit') {
                          _showEditCakeDialog(cake);
                        }

                        if (value == 'toggle') {
                          _toggleAvailability(cake);
                        }

                        if (value == 'delete') {
                          _deleteCake(cake);
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: Text(
                            'Edit Cake',
                            style: TextStyle(
                              color: dark
                                  ? Colors.white
                                  : AppColors.brown,
                            ),
                          ),
                        ),
                        PopupMenuItem(
                          value: 'toggle',
                          child: Text(
                            cake.available
                                ? 'Mark Unavailable'
                                : 'Mark Available',
                            style: TextStyle(
                              color: dark
                                  ? Colors.white
                                  : AppColors.brown,
                            ),
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text(
                            'Delete',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    cake.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: dark
                          ? Colors.white
                          : AppColors.brown,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 7),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: dark
                          ? AppColors.peach.withOpacity(0.20)
                          : AppColors.peach.withOpacity(0.70),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      cake.category,
                      style: TextStyle(
                        color: dark
                            ? Colors.white
                            : AppColors.brown,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const Spacer(),

                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Rs ${cake.price.toStringAsFixed(0)}',
                          style: TextStyle(
                            color: dark
                                ? Colors.white
                                : AppColors.brown,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: dark
                              ? AppColors.peach
                                  .withOpacity(0.18)
                              : AppColors.peach,
                          borderRadius:
                              BorderRadius.circular(11),
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            _showEditCakeDialog(cake);
                          },
                          icon: Icon(
                            Icons.edit_outlined,
                            size: 18,
                            color: dark
                                ? AppColors.gold
                                : AppColors.brown,
                          ),
                        ),
                      ),
                    ],
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
  // ADD CAKE
  // ============================================================

  void _showAddCakeDialog() {
    final nameController = TextEditingController();
    final categoryController = TextEditingController();
    final priceController = TextEditingController();

    bool available = true;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            final dark =
                context.read<AdminThemeProvider>().themeMode ==
                    ThemeMode.dark;

            return AlertDialog(
              backgroundColor:
                  dark ? const Color(0xFF181B20) : Colors.white,
              surfaceTintColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(26),
              ),
              title: Text(
                'Add New Cake',
                style: TextStyle(
                  color:
                      dark ? Colors.white : AppColors.brown,
                  fontWeight: FontWeight.w900,
                ),
              ),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: 450,
                  child: Column(
                    children: [
                      _dialogField(
                        controller: nameController,
                        label: 'Cake Name',
                        hint: 'e.g. Chocolate Fudge Cake',
                        icon: Icons.cake_outlined,
                        dark: dark,
                      ),
                      const SizedBox(height: 15),
                      _dialogField(
                        controller: categoryController,
                        label: 'Category',
                        hint: 'e.g. Chocolate',
                        icon: Icons.category_outlined,
                        dark: dark,
                      ),
                      const SizedBox(height: 15),
                      _dialogField(
                        controller: priceController,
                        label: 'Price',
                        hint: 'e.g. 2500',
                        icon: Icons.payments_outlined,
                        keyboardType:
                            TextInputType.number,
                        dark: dark,
                      ),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: dark
                              ? const Color(0xFF22262C)
                              : const Color(0xFFF8F4EF),
                          borderRadius:
                              BorderRadius.circular(15),
                        ),
                        child: SwitchListTile(
                          title: Text(
                            'Available',
                            style: TextStyle(
                              color: dark
                                  ? Colors.white
                                  : AppColors.brown,
                              fontWeight:
                                  FontWeight.w700,
                            ),
                          ),
                          subtitle: Text(
                            'Customers can order this cake',
                            style: TextStyle(
                              color: dark
                                  ? Colors.white60
                                  : AppColors.grey,
                            ),
                          ),
                          value: available,
                          activeColor: AppColors.gold,
                          onChanged: (value) {
                            setDialogState(() {
                              available = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
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
                      color: dark
                          ? Colors.white70
                          : AppColors.grey,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    final name =
                        nameController.text.trim();
                    final category =
                        categoryController.text.trim();
                    final price = double.tryParse(
                      priceController.text.trim(),
                    );

                    if (name.isEmpty ||
                        category.isEmpty ||
                        price == null) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please fill all fields correctly',
                          ),
                        ),
                      );
                      return;
                    }

                    setState(() {
                      cakes.add(
                        CakeItem(
                          name: name,
                          category: category,
                          price: price,
                          image:
                              'https://images.unsplash.com/photo-1578985545062-69928b1d9587?auto=format&fit=crop&w=600&q=80',
                          available: available,
                        ),
                      );
                    });

                    Navigator.pop(dialogContext);

                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                        content:
                            Text('Cake added successfully'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Cake'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brown,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ============================================================
  // DIALOG FIELD
  // ============================================================

  Widget _dialogField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required bool dark,
    TextInputType keyboardType =
        TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(
        color: dark ? Colors.white : AppColors.brown,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(
          color: dark ? Colors.white70 : AppColors.grey,
        ),
        hintStyle: TextStyle(
          color: dark ? Colors.white38 : AppColors.grey,
        ),
        prefixIcon: Icon(
          icon,
          color: AppColors.gold,
        ),
        filled: true,
        fillColor: dark
            ? const Color(0xFF22262C)
            : const Color(0xFFF8F4EF),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: AppColors.gold,
            width: 2,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // EDIT CAKE
  // ============================================================

  void _showEditCakeDialog(CakeItem cake) {
    final nameController =
        TextEditingController(text: cake.name);

    final categoryController =
        TextEditingController(text: cake.category);

    final priceController = TextEditingController(
      text: cake.price.toStringAsFixed(0),
    );

    bool available = cake.available;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            final dark =
                context.read<AdminThemeProvider>().themeMode ==
                    ThemeMode.dark;

            return AlertDialog(
              backgroundColor:
                  dark ? const Color(0xFF181B20) : Colors.white,
              surfaceTintColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(26),
              ),
              title: Text(
                'Edit Cake',
                style: TextStyle(
                  color:
                      dark ? Colors.white : AppColors.brown,
                  fontWeight: FontWeight.w900,
                ),
              ),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: 450,
                  child: Column(
                    children: [
                      _dialogField(
                        controller: nameController,
                        label: 'Cake Name',
                        hint: 'Cake name',
                        icon: Icons.cake_outlined,
                        dark: dark,
                      ),
                      const SizedBox(height: 15),
                      _dialogField(
                        controller: categoryController,
                        label: 'Category',
                        hint: 'Category',
                        icon: Icons.category_outlined,
                        dark: dark,
                      ),
                      const SizedBox(height: 15),
                      _dialogField(
                        controller: priceController,
                        label: 'Price',
                        hint: 'Price',
                        icon: Icons.payments_outlined,
                        keyboardType:
                            TextInputType.number,
                        dark: dark,
                      ),
                      const SizedBox(height: 10),
                      SwitchListTile(
                        title: Text(
                          'Available',
                          style: TextStyle(
                            color: dark
                                ? Colors.white
                                : AppColors.brown,
                            fontWeight:
                                FontWeight.w700,
                          ),
                        ),
                        value: available,
                        activeColor: AppColors.gold,
                        onChanged: (value) {
                          setDialogState(() {
                            available = value;
                          });
                        },
                      ),
                    ],
                  ),
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
                      color: dark
                          ? Colors.white70
                          : AppColors.grey,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    final name =
                        nameController.text.trim();
                    final category =
                        categoryController.text.trim();

                    final price = double.tryParse(
                      priceController.text.trim(),
                    );

                    if (name.isEmpty ||
                        category.isEmpty ||
                        price == null) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please enter valid information',
                          ),
                        ),
                      );
                      return;
                    }

                    setState(() {
                      cake.name = name;
                      cake.category = category;
                      cake.price = price;
                      cake.available = available;
                    });

                    Navigator.pop(dialogContext);

                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                        content:
                            Text('Cake updated successfully'),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brown,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Save Changes'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ============================================================
  // DELETE
  // ============================================================

  void _deleteCake(CakeItem cake) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final dark =
            context.read<AdminThemeProvider>().themeMode ==
                ThemeMode.dark;

        return AlertDialog(
          backgroundColor:
              dark ? const Color(0xFF181B20) : Colors.white,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: Text(
            'Delete Cake?',
            style: TextStyle(
              color:
                  dark ? Colors.white : AppColors.brown,
              fontWeight: FontWeight.w900,
            ),
          ),
          content: Text(
            'Are you sure you want to delete "${cake.name}"?',
            style: TextStyle(
              color: dark
                  ? Colors.white70
                  : AppColors.grey,
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
                  color: dark
                      ? Colors.white70
                      : AppColors.grey,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  cakes.remove(cake);
                });

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  const SnackBar(
                    content:
                        Text('Cake deleted successfully'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // TOGGLE AVAILABILITY
  // ============================================================

  void _toggleAvailability(CakeItem cake) {
    setState(() {
      cake.available = !cake.available;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          cake.available
              ? '${cake.name} is now available'
              : '${cake.name} is now unavailable',
        ),
      ),
    );
  }
}

// ================================================================
// CAKE MODEL
// ================================================================

class CakeItem {
  String name;
  String category;
  double price;
  final String image;
  bool available;

  CakeItem({
    required this.name,
    required this.category,
    required this.price,
    required this.image,
    required this.available,
  });
}

// ================================================================
// STAT MODEL
// ================================================================

class _CakeStat {
  final String title;
  final String value;
  final IconData icon;

  const _CakeStat({
    required this.title,
    required this.value,
    required this.icon,
  });
}
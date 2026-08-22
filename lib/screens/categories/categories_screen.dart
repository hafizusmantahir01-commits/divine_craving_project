import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../data/cake_data.dart';
import '../../models/cake_model.dart';
import '../../widgets/cake_card.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  // ============================================================
  // SELECTED CATEGORY
  // ============================================================

  String selectedCategory = 'All';

  // ============================================================
  // CATEGORIES
  // ============================================================

  final List<String> categories = [
    'All',
    'Birthday',
    'Anniversary',
    'Wedding',
    'Custom',
  ];

  // ============================================================
  // RESPONSIVE GRID
  // ============================================================

  int getCrossAxisCount(double width) {
    if (width < 600) {
      return 2;
    } else if (width < 900) {
      return 3;
    } else if (width < 1200) {
      return 4;
    } else if (width < 1600) {
      return 5;
    } else {
      return 6;
    }
  }

  // ============================================================
  // FILTER CAKES BY CATEGORY
  // ============================================================

  List<CakeModel> get filteredCakes {
    if (selectedCategory == 'All') {
      return List<CakeModel>.from(CakeData.cakes);
    }

    return CakeData.cakes.where((cake) {
      final cakeCategory =
          cake.category.toString().trim().toLowerCase();

      final selected =
          selectedCategory.trim().toLowerCase();

      return cakeCategory == selected;
    }).toList();
  }

  // ============================================================
  // CATEGORY SELECT
  // ============================================================

  void _selectCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  // ============================================================
  // OPEN SEARCH
  // ============================================================

  void _openSearch() {
    showSearch(
      context: context,
      delegate: CakeSearchDelegate(),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final screenWidth = MediaQuery.of(context).size.width;

    final columns = getCrossAxisCount(screenWidth);

    final cakes = filteredCakes;

    final primaryColor =
        isDark ? Colors.white : AppColors.brown;

    final accentColor =
        isDark ? const Color(0xFFFFBFA3) : AppColors.brown;

    return SafeArea(
      child: Column(
        children: [
          // ======================================================
          // HEADER
          // ======================================================

          Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              20,
              20,
              15,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedCategory == 'All'
                        ? 'All Cakes'
                        : '$selectedCategory Cakes',
                    style: TextStyle(
                      fontSize:
                          screenWidth >= 900 ? 30 : 26,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ),

                // =================================================
                // SEARCH ICON ONLY
                // =================================================

                Container(
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF261D19)
                        : AppColors.lightCream,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: _openSearch,
                    tooltip: 'Search Cakes',
                    icon: Icon(
                      Icons.search_rounded,
                      color: accentColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ======================================================
          // CATEGORY CHIPS
          // ======================================================

          SizedBox(
            height: 48,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];

                final isSelected =
                    selectedCategory == category;

                return Padding(
                  padding: const EdgeInsets.only(
                    right: 10,
                  ),
                  child: ChoiceChip(
                    label: Text(
                      category,
                    ),

                    selected: isSelected,

                    selectedColor: isDark
                        ? AppColors.peach
                        : AppColors.brown,

                    backgroundColor: isDark
                        ? const Color(0xFF261D19)
                        : AppColors.lightCream,

                    side: BorderSide(
                      color: isSelected
                          ? Colors.transparent
                          : isDark
                              ? Colors.white10
                              : Colors.black12,
                    ),

                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(22),
                    ),

                    labelStyle: TextStyle(
                      color: isSelected
                          ? (isDark
                              ? AppColors.brown
                              : Colors.white)
                          : (isDark
                              ? Colors.white
                              : AppColors.brown),
                      fontWeight: FontWeight.w700,
                    ),

                    onSelected: (_) {
                      _selectCategory(category);
                    },
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 15),

          // ======================================================
          // CATEGORY RESULT HEADER
          // ======================================================

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedCategory == 'All'
                        ? 'All Cakes'
                        : '$selectedCategory Cakes',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: primaryColor,
                    ),
                  ),
                ),

                Text(
                  '${cakes.length} ${cakes.length == 1 ? 'cake' : 'cakes'}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? Colors.white60
                        : Colors.black54,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 5),

          // ======================================================
          // CAKES GRID
          // ======================================================

          Expanded(
            child: cakes.isEmpty
                ? _EmptyCategory(
                    category: selectedCategory,
                  )
                : GridView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal:
                          screenWidth >= 900 ? 30 : 20,
                      vertical: 20,
                    ),
                    physics:
                        const BouncingScrollPhysics(),

                    itemCount: cakes.length,

                    gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing:
                          screenWidth >= 900 ? 20 : 14,
                      mainAxisSpacing:
                          screenWidth >= 900 ? 20 : 14,
                      childAspectRatio:
                          screenWidth >= 900
                              ? 0.72
                              : 0.68,
                    ),

                    itemBuilder: (context, index) {
                      return CakeCard(
                        cake: cakes[index],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// EMPTY CATEGORY
// ============================================================

class _EmptyCategory extends StatelessWidget {
  final String category;

  const _EmptyCategory({
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isDark =
        theme.brightness == Brightness.dark;

    final accentColor = isDark
        ? const Color(0xFFFFBFA3)
        : AppColors.brown;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.peach
                        .withOpacity(0.10)
                    : AppColors.peach
                        .withOpacity(0.20),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.cake_outlined,
                size: 55,
                color: accentColor,
              ),
            ),

            const SizedBox(height: 22),

            Text(
              'No $category cakes found',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color:
                    theme.colorScheme.onSurface,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'There are no cakes available in this category right now.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: theme
                    .textTheme
                    .bodyMedium
                    ?.color
                    ?.withOpacity(0.65),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// FULL SEARCH DELEGATE
// ============================================================

class CakeSearchDelegate
    extends SearchDelegate<String> {
  CakeSearchDelegate()
      : super(
          searchFieldLabel: 'Search cakes...',
          searchFieldStyle:
              const TextStyle(
            fontSize: 16,
          ),
        );

  // ==========================================================
  // SEARCH ACTION
  // ==========================================================

  @override
  List<Widget>? buildActions(
    BuildContext context,
  ) {
    return [
      if (query.isNotEmpty)
        IconButton(
          tooltip: 'Clear',
          onPressed: () {
            query = '';
          },
          icon: const Icon(
            Icons.clear_rounded,
          ),
        ),
    ];
  }

  // ==========================================================
  // BACK
  // ==========================================================

  @override
  Widget? buildLeading(
    BuildContext context,
  ) {
    return IconButton(
      tooltip: 'Back',
      onPressed: () {
        close(context, '');
      },
      icon: const Icon(
        Icons.arrow_back_rounded,
      ),
    );
  }

  // ==========================================================
  // RESULTS
  // ==========================================================

  @override
  Widget buildResults(
    BuildContext context,
  ) {
    return _buildSearchResults(context);
  }

  // ==========================================================
  // SUGGESTIONS
  // ==========================================================

  @override
  Widget buildSuggestions(
    BuildContext context,
  ) {
    return _buildSearchResults(context);
  }

  // ==========================================================
  // SEARCH RESULTS
  // ==========================================================

  Widget _buildSearchResults(
    BuildContext context,
  ) {
    final searchQuery =
        query.trim().toLowerCase();

    final results = searchQuery.isEmpty
        ? <CakeModel>[]
        : CakeData.cakes.where((cake) {
            final name =
                cake.name.toLowerCase();

            final category = cake.category
                .toString()
                .toLowerCase();

            return name.contains(
                  searchQuery,
                ) ||
                category.contains(
                  searchQuery,
                );
          }).toList();

    final theme = Theme.of(context);

    final isDark =
        theme.brightness ==
            Brightness.dark;

    final accentColor = isDark
        ? const Color(0xFFFFBFA3)
        : AppColors.brown;

    // ==========================================================
    // EMPTY SEARCH
    // ==========================================================

    if (searchQuery.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_rounded,
              size: 70,
              color: accentColor,
            ),

            const SizedBox(height: 15),

            Text(
              'Search for a cake',
              style: TextStyle(
                fontSize: 21,
                fontWeight:
                    FontWeight.bold,
                color: theme
                    .colorScheme
                    .onSurface,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Type a cake name or category above.',
              style: TextStyle(
                color: theme
                    .textTheme
                    .bodyMedium
                    ?.color,
              ),
            ),
          ],
        ),
      );
    }

    // ==========================================================
    // NO RESULTS
    // ==========================================================

    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 70,
              color: accentColor,
            ),

            const SizedBox(height: 15),

            Text(
              'No cakes found',
              style: TextStyle(
                fontSize: 21,
                fontWeight:
                    FontWeight.bold,
                color: theme
                    .colorScheme
                    .onSurface,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Try another cake name or category.',
              style: TextStyle(
                color: theme
                    .textTheme
                    .bodyMedium
                    ?.color,
              ),
            ),
          ],
        ),
      );
    }

    // ==========================================================
    // RESPONSIVE COLUMNS
    // ==========================================================

    final width =
        MediaQuery.of(context).size.width;

    int columns;

    if (width < 600) {
      columns = 2;
    } else if (width < 900) {
      columns = 3;
    } else if (width < 1200) {
      columns = 4;
    } else if (width < 1600) {
      columns = 5;
    } else {
      columns = 6;
    }

    // ==========================================================
    // SEARCH RESULT GRID
    // ==========================================================

    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.fromLTRB(
            20,
            15,
            20,
            5,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Search Results',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight:
                        FontWeight.bold,
                    color: theme
                        .colorScheme
                        .onSurface,
                  ),
                ),
              ),

              Text(
                '${results.length} ${results.length == 1 ? 'cake' : 'cakes'}',
                style: TextStyle(
                  color: theme
                      .textTheme
                      .bodyMedium
                      ?.color
                      ?.withOpacity(0.65),
                  fontWeight:
                      FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: GridView.builder(
            padding:
                const EdgeInsets.all(20),
            physics:
                const BouncingScrollPhysics(),
            itemCount: results.length,

            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio:
                  width >= 900
                      ? 0.72
                      : 0.68,
            ),

            itemBuilder:
                (context, index) {
              return CakeCard(
                cake: results[index],
              );
            },
          ),
        ),
      ],
    );
  }
}
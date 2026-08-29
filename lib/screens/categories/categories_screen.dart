 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../models/cake_model.dart';
import '../../widgets/cake_card.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() =>
      _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  // ============================================================
  // FIRESTORE
  // ============================================================

  final CollectionReference<Map<String, dynamic>> _cakesCollection =
      FirebaseFirestore.instance.collection('cakes');

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
  // CONVERT FIRESTORE DOCUMENT TO CAKE MODEL
  // ============================================================

  CakeModel _cakeFromFirestore(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data() ?? {};

    return CakeModel(
      id: (data['id'] ?? document.id).toString(),
      name: (data['name'] ?? '').toString(),
      category: (data['category'] ?? '').toString(),
      image: (data['image'] ?? '').toString(),
      price: _toDouble(data['price']),
      rating: _toDouble(data['rating']),
      reviews: _toInt(data['reviews']),
      description:
          (data['description'] ?? '').toString(),
    );
  }

  // ============================================================
  // SAFE DOUBLE CONVERSION
  // ============================================================

  double _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
          value?.toString() ?? '',
        ) ??
        0.0;
  }

  // ============================================================
  // SAFE INT CONVERSION
  // ============================================================

  int _toInt(dynamic value) {
    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
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

  void _openSearch(
    List<CakeModel> cakes,
  ) {
    showSearch(
      context: context,
      delegate: CakeSearchDelegate(
        cakes: cakes,
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isDark =
        theme.brightness == Brightness.dark;

    final screenWidth =
        MediaQuery.of(context).size.width;

    final columns =
        getCrossAxisCount(screenWidth);

    final primaryColor = isDark
        ? Colors.white
        : AppColors.brown;

    final accentColor = isDark
        ? const Color(0xFFFFBFA3)
        : AppColors.brown;

    return SafeArea(
      child: StreamBuilder<
          QuerySnapshot<Map<String, dynamic>>>(
        stream: _cakesCollection.snapshots(),

        builder: (context, snapshot) {
          // ====================================================
          // LOADING
          // ====================================================

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // ====================================================
          // ERROR
          // ====================================================

          if (snapshot.hasError) {
            return _FirebaseError(
              error: snapshot.error.toString(),
            );
          }

          // ====================================================
          // NO DATA
          // ====================================================

          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {
            return _EmptyFirebaseCakes();
          }

          // ====================================================
          // FIRESTORE CAKES
          // ====================================================

          final allCakes = snapshot.data!.docs
              .map(_cakeFromFirestore)
              .where(
                (cake) => cake.name.isNotEmpty,
              )
              .toList();

          // ====================================================
          // FILTER CATEGORY
          // ====================================================

          final cakes =
              selectedCategory == 'All'
                  ? allCakes
                  : allCakes.where((cake) {
                      final cakeCategory = cake.category
                          .trim()
                          .toLowerCase();

                      final selected = selectedCategory
                          .trim()
                          .toLowerCase();

                      return cakeCategory ==
                          selected;
                    }).toList();

          return Column(
            children: [
              // ==================================================
              // HEADER
              // ==================================================

              Padding(
                padding:
                    const EdgeInsets.fromLTRB(
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
                              screenWidth >= 900
                                  ? 30
                                  : 26,
                          fontWeight:
                              FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ),

                    // ==========================================
                    // SEARCH
                    // ==========================================

                    Container(
                      decoration:
                          BoxDecoration(
                        color: isDark
                            ? const Color(
                                0xFF261D19,
                              )
                            : AppColors
                                .lightCream,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {
                          _openSearch(
                            allCakes,
                          );
                        },
                        tooltip:
                            'Search Cakes',
                        icon: Icon(
                          Icons.search_rounded,
                          color: accentColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ==================================================
              // CATEGORY CHIPS
              // ==================================================

              SizedBox(
                height: 48,
                child: ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  scrollDirection:
                      Axis.horizontal,
                  physics:
                      const BouncingScrollPhysics(),
                  itemCount:
                      categories.length,
                  itemBuilder:
                      (context, index) {
                    final category =
                        categories[index];

                    final isSelected =
                        selectedCategory ==
                            category;

                    return Padding(
                      padding:
                          const EdgeInsets.only(
                        right: 10,
                      ),
                      child: ChoiceChip(
                        label: Text(
                          category,
                        ),
                        selected:
                            isSelected,
                        selectedColor:
                            isDark
                                ? AppColors
                                    .peach
                                : AppColors
                                    .brown,
                        backgroundColor:
                            isDark
                                ? const Color(
                                    0xFF261D19,
                                  )
                                : AppColors
                                    .lightCream,
                        side:
                            BorderSide(
                          color: isSelected
                              ? Colors
                                  .transparent
                              : isDark
                                  ? Colors
                                      .white10
                                  : Colors
                                      .black12,
                        ),
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(
                            22,
                          ),
                        ),
                        labelStyle:
                            TextStyle(
                          color: isSelected
                              ? (isDark
                                  ? AppColors
                                      .brown
                                  : Colors
                                      .white)
                              : (isDark
                                  ? Colors
                                      .white
                                  : AppColors
                                      .brown),
                          fontWeight:
                              FontWeight.w700,
                        ),
                        onSelected: (_) {
                          _selectCategory(
                            category,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 15),

              // ==================================================
              // RESULT HEADER
              // ==================================================

              Padding(
                padding:
                    const EdgeInsets.symmetric(
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
                          fontWeight:
                              FontWeight.w700,
                          color:
                              primaryColor,
                        ),
                      ),
                    ),
                    Text(
                      '${cakes.length} ${cakes.length == 1 ? 'cake' : 'cakes'}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight:
                            FontWeight.w600,
                        color: isDark
                            ? Colors.white60
                            : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 5),

              // ==================================================
              // CAKES GRID
              // ==================================================

              Expanded(
                child: cakes.isEmpty
                    ? _EmptyCategory(
                        category:
                            selectedCategory,
                      )
                    : GridView.builder(
                        padding:
                            EdgeInsets.symmetric(
                          horizontal:
                              screenWidth >= 900
                                  ? 30
                                  : 20,
                          vertical: 20,
                        ),
                        physics:
                            const BouncingScrollPhysics(),
                        itemCount:
                            cakes.length,
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              columns,
                          crossAxisSpacing:
                              screenWidth >= 900
                                  ? 20
                                  : 14,
                          mainAxisSpacing:
                              screenWidth >= 900
                                  ? 20
                                  : 14,
                          childAspectRatio:
                              screenWidth >= 900
                                  ? 0.72
                                  : 0.68,
                        ),
                        itemBuilder:
                            (context, index) {
                          return CakeCard(
                            cake:
                                cakes[index],
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ============================================================
// EMPTY CATEGORY
// ============================================================

class _EmptyCategory
    extends StatelessWidget {
  final String category;

  const _EmptyCategory({
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final theme =
        Theme.of(context);

    final isDark =
        theme.brightness ==
            Brightness.dark;

    final accentColor = isDark
        ? const Color(0xFFFFBFA3)
        : AppColors.brown;

    return Center(
      child: SingleChildScrollView(
        padding:
            const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration:
                  BoxDecoration(
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
              textAlign:
                  TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight:
                    FontWeight.w900,
                color: theme
                    .colorScheme
                    .onSurface,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'There are no cakes available in this category right now.',
              textAlign:
                  TextAlign.center,
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
// FIREBASE EMPTY
// ============================================================

class _EmptyFirebaseCakes
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme =
        Theme.of(context);

    final isDark =
        theme.brightness ==
            Brightness.dark;

    final accentColor = isDark
        ? const Color(0xFFFFBFA3)
        : AppColors.brown;

    return Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cake_outlined,
            size: 70,
            color: accentColor,
          ),

          const SizedBox(height: 15),

          Text(
            'No cakes available',
            style: TextStyle(
              fontSize: 22,
              fontWeight:
                  FontWeight.w900,
              color: theme
                  .colorScheme
                  .onSurface,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Add cakes to your Firebase database.',
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
}

// ============================================================
// FIREBASE ERROR
// ============================================================

class _FirebaseError
    extends StatelessWidget {
  final String error;

  const _FirebaseError({
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    final theme =
        Theme.of(context);

    final isDark =
        theme.brightness ==
            Brightness.dark;

    final accentColor = isDark
        ? const Color(0xFFFFBFA3)
        : AppColors.brown;

    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 65,
              color: accentColor,
            ),

            const SizedBox(height: 15),

            Text(
              'Unable to load cakes',
              textAlign:
                  TextAlign.center,
              style: TextStyle(
                fontSize: 21,
                fontWeight:
                    FontWeight.w900,
                color: theme
                    .colorScheme
                    .onSurface,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Please check your Firebase connection.',
              textAlign:
                  TextAlign.center,
              style: TextStyle(
                color: theme
                    .textTheme
                    .bodyMedium
                    ?.color,
              ),
            ),

            const SizedBox(height: 10),

            if (error.isNotEmpty)
              Text(
                error,
                textAlign:
                    TextAlign.center,
                maxLines: 3,
                overflow:
                    TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  color: theme
                      .textTheme
                      .bodySmall
                      ?.color,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// SEARCH DELEGATE
// ============================================================

class CakeSearchDelegate
    extends SearchDelegate<String> {
  final List<CakeModel> cakes;

  CakeSearchDelegate({
    required this.cakes,
  }) : super(
          searchFieldLabel:
              'Search cakes...',
          searchFieldStyle:
              const TextStyle(
            fontSize: 16,
          ),
        );

  // ==========================================================
  // ACTIONS
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
  // LEADING
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
    return _buildSearchResults(
      context,
    );
  }

  // ==========================================================
  // SUGGESTIONS
  // ==========================================================

  @override
  Widget buildSuggestions(
    BuildContext context,
  ) {
    return _buildSearchResults(
      context,
    );
  }

  // ==========================================================
  // SEARCH RESULTS
  // ==========================================================

  Widget _buildSearchResults(
    BuildContext context,
  ) {
    final searchQuery =
        query.trim().toLowerCase();

    final theme =
        Theme.of(context);

    final isDark =
        theme.brightness ==
            Brightness.dark;

    final accentColor = isDark
        ? const Color(0xFFFFBFA3)
        : AppColors.brown;

    // ========================================================
    // EMPTY SEARCH
    // ========================================================

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

    // ========================================================
    // FILTER RESULTS
    // ========================================================

    final results =
        cakes.where((cake) {
      final name =
          cake.name.toLowerCase();

      final category =
          cake.category
              .toLowerCase();

      final description =
          cake.description
              .toLowerCase();

      return name.contains(
            searchQuery,
          ) ||
          category.contains(
            searchQuery,
          ) ||
          description.contains(
            searchQuery,
          );
    }).toList();

    // ========================================================
    // NO RESULTS
    // ========================================================

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

    // ========================================================
    // RESPONSIVE COLUMNS
    // ========================================================

    final width =
        MediaQuery.of(context)
            .size
            .width;

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

    // ========================================================
    // RESULT GRID
    // ========================================================

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
            itemCount:
                results.length,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:
                  columns,
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
                cake:
                    results[index],
              );
            },
          ),
        ),
      ],
    );
  }
}
 

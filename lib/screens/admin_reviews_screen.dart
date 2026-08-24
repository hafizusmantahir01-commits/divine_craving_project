import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_colors.dart';
import '../providers/admin_theme_provider.dart';

class AdminReviewsScreen extends StatefulWidget {
  const AdminReviewsScreen({super.key});

  @override
  State<AdminReviewsScreen> createState() => _AdminReviewsScreenState();
}

class _AdminReviewsScreenState extends State<AdminReviewsScreen> {
  final TextEditingController searchController = TextEditingController();

  String searchQuery = '';
  String selectedFilter = 'All';

  final List<ReviewItem> reviews = [
    ReviewItem(
      name: 'Ali Ahmed',
      cake: 'Chocolate Cake',
      rating: 5,
      review:
          'Amazing cake! Taste was really delicious and the presentation was beautiful.',
      date: 'Today',
    ),
    ReviewItem(
      name: 'Sara Khan',
      cake: 'Red Velvet Cake',
      rating: 4,
      review: 'Very beautiful cake and good taste. Everyone loved it.',
      date: 'Yesterday',
    ),
    ReviewItem(
      name: 'Usman Ali',
      cake: 'Birthday Cake',
      rating: 5,
      review:
          'The cake looked exactly like the picture. Really happy with the order.',
      date: '2 days ago',
    ),
    ReviewItem(
      name: 'Ayesha',
      cake: 'Wedding Cake',
      rating: 3,
      review: 'Cake was good but delivery was a little late.',
      date: '3 days ago',
    ),
    ReviewItem(
      name: 'Hassan Raza',
      cake: 'Vanilla Cake',
      rating: 5,
      review: 'Perfect taste and beautiful presentation. Highly recommended.',
      date: '5 days ago',
    ),
  ];

  final List<String> filters = [
    'All',
    '5',
    '4',
    '3',
    '2',
    '1',
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // ============================================================
  // FILTERED REVIEWS
  // ============================================================

  List<ReviewItem> get filteredReviews {
    final query = searchQuery.trim().toLowerCase();

    return reviews.where((review) {
      final matchesSearch = review.name.toLowerCase().contains(query) ||
          review.cake.toLowerCase().contains(query) ||
          review.review.toLowerCase().contains(query);

      final matchesFilter =
          selectedFilter == 'All' || review.rating.toString() == selectedFilter;

      return matchesSearch && matchesFilter;
    }).toList();
  }

  int get fiveStarCount {
    return reviews.where((review) => review.rating == 5).length;
  }

  double get averageRating {
    if (reviews.isEmpty) {
      return 0;
    }

    int total = 0;

    for (final review in reviews) {
      total += review.rating;
    }

    return total / reviews.length;
  }

  // ============================================================
  // COLORS
  // ============================================================

  Color backgroundColor(bool isDark) {
    return isDark ? const Color(0xFF101114) : const Color(0xFFF7F3EF);
  }

  Color cardColor(bool isDark) {
    return isDark ? const Color(0xFF1B1D22) : Colors.white;
  }

  Color secondaryCardColor(bool isDark) {
    return isDark ? const Color(0xFF252830) : const Color(0xFFF9F6F2);
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
    return isDark ? const Color(0xFF352C27) : AppColors.peach;
  }

  Color dividerColor(bool isDark) {
    return isDark ? const Color(0xFF30343D) : const Color(0xFFE8E1DB);
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminThemeProvider>(
      builder: (context, themeProvider, child) {
        final bool isDark = themeProvider.themeMode == ThemeMode.dark;

        final double width = MediaQuery.of(context).size.width;

        final bool isDesktop = width >= 1000;

        return Scaffold(
          backgroundColor: backgroundColor(isDark),
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
              tooltip: 'Back',
            ),
            title: Text(
              'Reviews',
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(
                    isDesktop,
                    isDark,
                  ),
                  const SizedBox(height: 28),
                  _buildSummary(isDark),
                  const SizedBox(height: 28),
                  _buildSearchAndFilter(isDark),
                  const SizedBox(height: 25),
                  _buildReviewsSection(isDark),
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
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(
        isDesktop ? 25 : 20,
      ),
      decoration: BoxDecoration(
        color: cardColor(isDark),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: dividerColor(isDark),
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: isDesktop ? 62 : 55,
            height: isDesktop ? 62 : 55,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.brown,
                  AppColors.brown.withOpacity(0.75),
                ],
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.rate_review_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Customer Reviews',
                  style: TextStyle(
                    fontSize: isDesktop ? 28 : 22,
                    fontWeight: FontWeight.w900,
                    color: primaryTextColor(isDark),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'View customer feedback and manage cake reviews.',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: secondaryTextColor(isDark),
                  ),
                ),
              ],
            ),
          ),
          if (isDesktop)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: iconBackground(isDark),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.reviews_outlined,
                    color: accentColor(isDark),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${reviews.length} Reviews',
                    style: TextStyle(
                      color: primaryTextColor(isDark),
                      fontWeight: FontWeight.bold,
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
  // SUMMARY
  // ============================================================

  Widget _buildSummary(bool isDark) {
    final List<_ReviewStat> stats = [
      _ReviewStat(
        title: 'Total Reviews',
        value: reviews.length.toString(),
        icon: Icons.rate_review_outlined,
      ),
      _ReviewStat(
        title: 'Average Rating',
        value: averageRating.toStringAsFixed(1),
        icon: Icons.star_rounded,
      ),
      _ReviewStat(
        title: '5 Star Reviews',
        value: fiveStarCount.toString(),
        icon: Icons.star_outline_rounded,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final double availableWidth = constraints.maxWidth;

        // ======================================================
        // MOBILE
        // ======================================================

        if (availableWidth < 600) {
          return Column(
            children: stats.map((stat) {
              return Padding(
                padding: const EdgeInsets.only(
                  bottom: 14,
                ),
                child: _buildStatCard(
                  stat,
                  isDark,
                  height: 88,
                ),
              );
            }).toList(),
          );
        }

        // ======================================================
        // TABLET
        // ======================================================

        if (availableWidth < 1000) {
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: stats.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              mainAxisExtent: 105,
            ),
            itemBuilder: (context, index) {
              return _buildStatCard(
                stats[index],
                isDark,
                height: 105,
              );
            },
          );
        }

        // ======================================================
        // DESKTOP
        // ======================================================

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: stats.map((stat) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: stat == stats.last ? 0 : 16,
                ),
                child: _buildStatCard(
                  stat,
                  isDark,
                  height: 105,
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  // ============================================================
  // STAT CARD - OVERFLOW FIXED
  // ============================================================

  Widget _buildStatCard(
    _ReviewStat stat,
    bool isDark, {
    required double height,
  }) {
    return Container(
      width: double.infinity,
      height: height,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: cardColor(isDark),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: dividerColor(isDark),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              isDark ? 0.18 : 0.035,
            ),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // ICON
          Flexible(
            flex: 0,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: iconBackground(isDark),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                stat.icon,
                size: 24,
                color: accentColor(isDark),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // TEXT
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  stat.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.2,
                    color: secondaryTextColor(isDark),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  stat.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 21,
                    height: 1.1,
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
  // SEARCH + FILTER
  // ============================================================

  Widget _buildSearchAndFilter(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: cardColor(isDark),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: dividerColor(isDark),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(
                  isDark ? 0.15 : 0.025,
                ),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: searchController,
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
            style: TextStyle(
              color: primaryTextColor(isDark),
            ),
            cursorColor: accentColor(isDark),
            decoration: InputDecoration(
              hintText: 'Search customer, cake or review...',
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
              filled: true,
              fillColor: cardColor(isDark),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 17,
                horizontal: 10,
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
          ),
        ),
        const SizedBox(height: 15),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: filters.map((filter) {
              final bool selected = selectedFilter == filter;

              final String label =
                  filter == 'All' ? 'All Reviews' : '$filter Stars';

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(label),
                  selected: selected,
                  onSelected: (_) {
                    setState(() {
                      selectedFilter = filter;
                    });
                  },
                  selectedColor: accentColor(isDark),
                  backgroundColor: cardColor(isDark),
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : primaryTextColor(isDark),
                    fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                  ),
                  side: BorderSide(
                    color:
                        selected ? accentColor(isDark) : dividerColor(isDark),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // REVIEWS SECTION
  // ============================================================

  Widget _buildReviewsSection(bool isDark) {
    final List<ReviewItem> filtered = filteredReviews;

    if (filtered.isEmpty) {
      return _buildEmptyState(isDark);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1100) {
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filtered.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.75,
            ),
            itemBuilder: (context, index) {
              return _buildReviewCard(
                filtered[index],
                isDark,
              );
            },
          );
        }

        return Column(
          children: filtered.map((review) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildReviewCard(
                review,
                isDark,
              ),
            );
          }).toList(),
        );
      },
    );
  }

  // ============================================================
  // REVIEW CARD
  // ============================================================

  Widget _buildReviewCard(
    ReviewItem review,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor(isDark),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: dividerColor(isDark),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              isDark ? 0.18 : 0.035,
            ),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _reviewAvatar(
                review,
                isDark,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: primaryTextColor(
                          isDark,
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      review.cake,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: secondaryTextColor(
                          isDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                color: cardColor(isDark),
                icon: Icon(
                  Icons.more_vert_rounded,
                  color: secondaryTextColor(
                    isDark,
                  ),
                ),
                onSelected: (value) {
                  if (value == 'delete') {
                    _deleteReview(review);
                  }
                },
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          const Icon(
                            Icons.delete_outline_rounded,
                            color: Colors.red,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Delete Review',
                            style: TextStyle(
                              color: primaryTextColor(
                                isDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ];
                },
              ),
            ],
          ),
          const SizedBox(height: 15),
          Divider(
            color: dividerColor(isDark),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  5,
                  (index) {
                    return Icon(
                      index < review.rating
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      color: AppColors.gold,
                      size: 21,
                    );
                  },
                ),
              ),
              const SizedBox(width: 9),
              Text(
                '${review.rating}.0',
                style: TextStyle(
                  color: primaryTextColor(isDark),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              Text(
                review.date,
                style: TextStyle(
                  color: secondaryTextColor(
                    isDark,
                  ),
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            review.review,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: primaryTextColor(isDark),
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // REVIEW AVATAR
  // ============================================================

  Widget _reviewAvatar(
    ReviewItem review,
    bool isDark,
  ) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: iconBackground(isDark),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Text(
          review.name.substring(0, 1).toUpperCase(),
          style: TextStyle(
            color: accentColor(isDark),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // DELETE REVIEW
  // ============================================================

  void _deleteReview(ReviewItem review) {
    final bool isDark =
        context.read<AdminThemeProvider>().themeMode == ThemeMode.dark;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: cardColor(isDark),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(
                    isDark ? 0.15 : 0.08,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.red,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Delete Review?',
                  style: TextStyle(
                    color: primaryTextColor(isDark),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to delete this review? This action cannot be undone.',
            style: TextStyle(
              color: secondaryTextColor(isDark),
              height: 1.4,
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(
            20,
            0,
            20,
            15,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: secondaryTextColor(isDark),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  reviews.remove(review);
                });

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Review deleted successfully',
                    ),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // EMPTY STATE
  // ============================================================

  Widget _buildEmptyState(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 70,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: cardColor(isDark),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: dividerColor(isDark),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 75,
            height: 75,
            decoration: BoxDecoration(
              color: iconBackground(isDark),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.rate_review_outlined,
              size: 38,
              color: accentColor(isDark),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'No Reviews Found',
            style: TextStyle(
              color: primaryTextColor(isDark),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try changing your search or filter.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: secondaryTextColor(isDark),
            ),
          ),
        ],
      ),
    );
  }
}

// ================================================================
// REVIEW MODEL
// ================================================================

class ReviewItem {
  final String name;
  final String cake;
  final int rating;
  final String review;
  final String date;

  const ReviewItem({
    required this.name,
    required this.cake,
    required this.rating,
    required this.review,
    required this.date,
  });
}

// ================================================================
// REVIEW STAT MODEL
// ================================================================

class _ReviewStat {
  final String title;
  final String value;
  final IconData icon;

  const _ReviewStat({
    required this.title,
    required this.value,
    required this.icon,
  });
}

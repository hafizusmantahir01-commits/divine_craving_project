import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../data/cake_data.dart';
import '../../data/brownie_data.dart';
import '../../models/brownie_model.dart';
import '../../providers/favorite_provider.dart';
import '../../widgets/cake_card.dart';
import '../../widgets/category_item.dart';
import '../../widgets/section_title.dart';

class HomeScreen extends StatelessWidget {
  final Function(int) onNavigation;

  const HomeScreen({
    super.key,
    required this.onNavigation,
  });

  // ==========================================================
  // NOTIFICATION DIALOG
  // ==========================================================

  void _showNotificationDialog(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: theme.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.brown.withOpacity(0.25)
                      : AppColors.lightCream,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.notifications_active_rounded,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Notifications',
                  style: TextStyle(
                    color: theme.textTheme.titleLarge?.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            'You have no new notifications right now.',
            style: TextStyle(
              color: theme.textTheme.bodyMedium?.color,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                'Close',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ==========================================================
  // FILTER BOTTOM SHEET
  // ==========================================================

  void _showFilterBottomSheet(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.cardColor,
      isScrollControlled: true,
      showDragHandle: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(26),
        ),
      ),
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              12,
              20,
              25,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 45,
                    height: 5,
                    decoration: BoxDecoration(
                      color:
                          isDark ? Colors.white24 : Colors.black12,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  'Filter & Sort',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.titleLarge?.color,
                  ),
                ),

                const SizedBox(height: 18),

                _filterItem(
                  context: bottomSheetContext,
                  icon: Icons.sort_by_alpha_rounded,
                  title: 'Sort by Name',
                  subtitle: 'A - Z',
                  isDark: isDark,
                  onTap: () {
                    Navigator.of(bottomSheetContext).pop();

                    _showMessage(
                      context,
                      'Products sorted by name',
                    );
                  },
                ),

                const SizedBox(height: 6),

                _filterItem(
                  context: bottomSheetContext,
                  icon: Icons.attach_money_rounded,
                  title: 'Sort by Price',
                  subtitle: 'Low to High',
                  isDark: isDark,
                  onTap: () {
                    Navigator.of(bottomSheetContext).pop();

                    _showMessage(
                      context,
                      'Products sorted by price',
                    );
                  },
                ),

                const SizedBox(height: 6),

                _filterItem(
                  context: bottomSheetContext,
                  icon: Icons.star_rounded,
                  title: 'Top Rated',
                  subtitle: 'Highest rated cakes',
                  isDark: isDark,
                  onTap: () {
                    Navigator.of(bottomSheetContext).pop();

                    _showMessage(
                      context,
                      'Showing top rated cakes',
                    );
                  },
                ),

                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  // ==========================================================
  // FILTER ITEM
  // ==========================================================

  Widget _filterItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.brown.withOpacity(0.25)
              : AppColors.lightCream,
          borderRadius: BorderRadius.circular(13),
        ),
        child: Icon(
          icon,
          color: theme.colorScheme.primary,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: theme.textTheme.bodyLarge?.color,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: theme.textTheme.bodyMedium?.color,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: theme.textTheme.bodyMedium?.color,
      ),
      onTap: onTap,
    );
  }

  // ==========================================================
  // SNACKBAR
  // ==========================================================

  void _showMessage(
    BuildContext context,
    String message,
  ) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }

  // ==========================================================
  // CATEGORY
  // ==========================================================

  Widget _categoryItem({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
  }) {
    final category = CategoryItem(
      icon: icon,
      title: title,
    );

    if (onTap == null) {
      return category;
    }

    return GestureDetector(
      onTap: onTap,
      child: category,
    );
  }

  // ==========================================================
  // BROWNIE CARD
  // ==========================================================

  Widget _brownieCard(
    BuildContext context,
    BrownieModel brownie,
    bool isDark,
  ) {
    final theme = Theme.of(context);

    final Color cardColor =
        isDark ? const Color(0xFF241B18) : Colors.white;

    final Color titleColor =
        isDark ? Colors.white : theme.colorScheme.primary;

    final Color bodyColor =
        isDark ? Colors.white70 : AppColors.grey;

    return Consumer<FavoriteProvider>(
      builder: (context, favoriteProvider, child) {
        final bool isFavorite =
            favoriteProvider.isBrownieFavorite(
          brownie.id,
        );

        return Material(
          color: cardColor,
          borderRadius: BorderRadius.circular(18),
          elevation: isDark ? 0 : 2,
          shadowColor: Colors.black12,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () {},
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                // ==================================================
                // IMAGE
                // ==================================================

                Expanded(
                  flex: 6,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.network(
                          brownie.image,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) {
                            return Container(
                              color: isDark
                                  ? const Color(0xFF30231F)
                                  : AppColors.lightCream,
                              child: Icon(
                                Icons.cookie_outlined,
                                size: 45,
                                color: bodyColor,
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
                                  ? const Color(0xFF30231F)
                                  : AppColors.lightCream,
                              child: const Center(
                                child:
                                    CircularProgressIndicator(),
                              ),
                            );
                          },
                        ),
                      ),

                      // ==================================================
                      // FAVORITE BUTTON
                      // ==================================================

                      Positioned(
                        top: 10,
                        right: 10,
                        child: Material(
                          color: Colors.black.withOpacity(0.55),
                          shape: const CircleBorder(),
                          child: InkWell(
                            customBorder:
                                const CircleBorder(),
                            onTap: () {
                              favoriteProvider
                                  .toggleBrownieFavorite(
                                brownie,
                              );
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.all(8),
                              child: Icon(
                                isFavorite
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_border_rounded,
                                color: isFavorite
                                    ? Colors.redAccent
                                    : Colors.white,
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ==================================================
                // INFORMATION
                // ==================================================

                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      12,
                      10,
                      12,
                      10,
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          brownie.name,
                          maxLines: 1,
                          overflow:
                              TextOverflow.ellipsis,
                          style: TextStyle(
                            color: titleColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          brownie.description,
                          maxLines: 2,
                          overflow:
                              TextOverflow.ellipsis,
                          style: TextStyle(
                            color: bodyColor,
                            fontSize: 11,
                            height: 1.25,
                          ),
                        ),

                        const Spacer(),

                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Rs. ${brownie.price}',
                              style: TextStyle(
                                color:
                                    theme.colorScheme.primary,
                                fontSize: 14,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.brown
                                        .withOpacity(0.3)
                                    : AppColors.lightCream,
                                borderRadius:
                                    BorderRadius.circular(9),
                              ),
                              child: Icon(
                                Icons.add_rounded,
                                size: 20,
                                color: theme
                                    .colorScheme.primary,
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
          ),
        );
      },
    );
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth =
        MediaQuery.of(context).size.width;

    final isDark =
        theme.brightness == Brightness.dark;

    final bool isDesktop = screenWidth >= 900;
    final bool isLargeDesktop =
        screenWidth >= 1200;

    final double horizontalPadding =
        isDesktop ? 40 : 20;

    int columns;

    if (screenWidth >= 1400) {
      columns = 4;
    } else if (screenWidth >= 1000) {
      columns = 3;
    } else {
      columns = 2;
    }

    final Color headingColor =
        isDark
            ? Colors.white
            : theme.colorScheme.primary;

    final Color bodyColor = isDark
        ? Colors.white70
        : theme.textTheme.bodyMedium?.color ??
            AppColors.grey;

    final Color iconColor =
        isDark
            ? Colors.white
            : theme.colorScheme.primary;

    final Color fieldColor =
        isDark
            ? const Color(0xFF241B18)
            : Colors.white;

    final Color softColor =
        isDark
            ? const Color(0xFF2D211C)
            : AppColors.lightCream;

    return Scaffold(
      backgroundColor:
          theme.scaffoldBackgroundColor,

      body: SafeArea(
        child: CustomScrollView(
          physics:
              const BouncingScrollPhysics(),
          slivers: [
            // ==================================================
            // HEADER
            // ==================================================

            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                20,
                horizontalPadding,
                10,
              ),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Good Evening 👋',
                            style: TextStyle(
                              color: bodyColor,
                              fontSize: 13,
                              fontWeight:
                                  FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'What are you craving today?',
                            maxLines: 2,
                            overflow:
                                TextOverflow.ellipsis,
                            style: TextStyle(
                              color: headingColor,
                              fontSize:
                                  isLargeDesktop
                                      ? 28
                                      : 21,
                              fontWeight:
                                  FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 15),

                    Material(
                      color:
                          Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          _showNotificationDialog(
                            context,
                          );
                        },
                        borderRadius:
                            BorderRadius.circular(50),
                        child: Container(
                          width: 46,
                          height: 46,
                          decoration:
                              BoxDecoration(
                            color: softColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark
                                  ? Colors.white10
                                  : Colors.black12,
                            ),
                          ),
                          child: Icon(
                            Icons
                                .notifications_none_rounded,
                            color: iconColor,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ==================================================
            // SEARCH
            // ==================================================

            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                10,
                horizontalPadding,
                20,
              ),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        style: TextStyle(
                          color: isDark
                              ? Colors.white
                              : Colors.black87,
                        ),
                        decoration:
                            InputDecoration(
                          hintText:
                              'Search for cakes...',
                          hintStyle:
                              TextStyle(
                            color: isDark
                                ? Colors.white54
                                : AppColors.grey,
                          ),
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: isDark
                                ? Colors.white70
                                : AppColors.brown,
                          ),
                          filled: true,
                          fillColor:
                              fieldColor,
                          contentPadding:
                              const EdgeInsets
                                  .symmetric(
                            vertical: 15,
                            horizontal: 10,
                          ),
                          border:
                              OutlineInputBorder(
                            borderRadius:
                                BorderRadius
                                    .circular(15),
                            borderSide:
                                BorderSide(
                              color: isDark
                                  ? Colors.white10
                                  : Colors.black12,
                            ),
                          ),
                          enabledBorder:
                              OutlineInputBorder(
                            borderRadius:
                                BorderRadius
                                    .circular(15),
                            borderSide:
                                BorderSide(
                              color: isDark
                                  ? Colors.white10
                                  : Colors.black12,
                            ),
                          ),
                          focusedBorder:
                              OutlineInputBorder(
                            borderRadius:
                                BorderRadius
                                    .circular(15),
                            borderSide:
                                BorderSide(
                              color: theme
                                  .colorScheme
                                  .primary,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Material(
                      color:
                          Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          _showFilterBottomSheet(
                            context,
                          );
                        },
                        borderRadius:
                            BorderRadius.circular(15),
                        child: Container(
                          width: 54,
                          height: 54,
                          decoration:
                              BoxDecoration(
                            color: softColor,
                            borderRadius:
                                BorderRadius.circular(15),
                            border: Border.all(
                              color: isDark
                                  ? Colors.white10
                                  : Colors.black12,
                            ),
                          ),
                          child: Icon(
                            Icons.tune_rounded,
                            color: iconColor,
                            size: 23,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ==================================================
            // BANNER
            // ==================================================

            SliverPadding(
              padding:
                  EdgeInsets.symmetric(
                horizontal:
                    horizontalPadding,
              ),
              sliver: SliverToBoxAdapter(
                child: Container(
                  height:
                      isDesktop ? 215 : 175,
                  padding: EdgeInsets.all(
                    isDesktop ? 28 : 20,
                  ),
                  decoration:
                      BoxDecoration(
                    color: AppColors.brown,
                    borderRadius:
                        BorderRadius.circular(24),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -15,
                        top: 0,
                        bottom: 0,
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(
                                  24),
                          child: Image.network(
                            'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=1000',
                            width:
                                isDesktop
                                    ? 280
                                    : 190,
                            height:
                                double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      Positioned.fill(
                        child: IgnorePointer(
                          child: Container(
                            decoration:
                                BoxDecoration(
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                          24),
                              gradient:
                                  LinearGradient(
                                begin: Alignment
                                    .centerLeft,
                                end: Alignment
                                    .centerRight,
                                colors: [
                                  AppColors.brown,
                                  AppColors.brown
                                      .withOpacity(
                                          0.82),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          Text(
                            'Delicious Cakes',
                            style: TextStyle(
                              color:
                                  Colors.white,
                              fontSize:
                                  isDesktop
                                      ? 27
                                      : 21,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                              height: 6),
                          SizedBox(
                            width:
                                isDesktop
                                    ? 230
                                    : 180,
                            child: Text(
                              'Made with love, just for you!',
                              style: TextStyle(
                                color: Colors
                                    .white
                                    .withOpacity(
                                        0.85),
                                fontSize:
                                    isDesktop
                                        ? 15
                                        : 13,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Material(
                            color:
                                AppColors.peach,
                            borderRadius:
                                BorderRadius
                                    .circular(
                                        10),
                            child: InkWell(
                              onTap: () {
                                onNavigation(
                                    1);
                              },
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                          10),
                              child:
                                  const Padding(
                                padding:
                                    EdgeInsets
                                        .symmetric(
                                  horizontal: 15,
                                  vertical: 9,
                                ),
                                child: Text(
                                  'Order Now',
                                  style:
                                      TextStyle(
                                    color:
                                        AppColors
                                            .brown,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ==================================================
            // CATEGORIES
            // ==================================================

            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                28,
                horizontalPadding,
                15,
              ),
              sliver:
                  SliverToBoxAdapter(
                child: SectionTitle(
                  title: 'Categories',
                  action: 'See all',
                  onTap: () {
                    onNavigation(1);
                  },
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: LayoutBuilder(
                builder:
                    (context, constraints) {
                  if (constraints.maxWidth >=
                      700) {
                    return Padding(
                      padding:
                          EdgeInsets.symmetric(
                        horizontal:
                            isDesktop
                                ? 35
                                : 20,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Center(
                              child:
                                  _categoryItem(
                                icon: Icons
                                    .cake_outlined,
                                title:
                                    'Birthday',
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child:
                                  _categoryItem(
                                icon: Icons
                                    .favorite_border,
                                title:
                                    'Anniversary',
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child:
                                  _categoryItem(
                                icon: Icons
                                    .diamond_outlined,
                                title:
                                    'Wedding',
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child:
                                  _categoryItem(
                                icon: Icons
                                    .auto_awesome,
                                title:
                                    'Custom',
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child:
                                  _categoryItem(
                                icon:
                                    Icons.apps,
                                title:
                                    'All Cakes',
                                onTap: () {
                                  onNavigation(
                                      1);
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child:
                                  _categoryItem(
                                icon: Icons
                                    .cookie_outlined,
                                title:
                                    'All Brownies',
                                onTap: () {
                                  onNavigation(
                                      1);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return SizedBox(
                    height: 105,
                    child: ListView(
                      padding:
                          const EdgeInsets
                              .symmetric(
                        horizontal: 20,
                      ),
                      scrollDirection:
                          Axis.horizontal,
                      physics:
                          const BouncingScrollPhysics(),
                      children: [
                        _categoryItem(
                          icon:
                              Icons.cake_outlined,
                          title:
                              'Birthday',
                        ),
                        _categoryItem(
                          icon: Icons
                              .favorite_border,
                          title:
                              'Anniversary',
                        ),
                        _categoryItem(
                          icon: Icons
                              .diamond_outlined,
                          title:
                              'Wedding',
                        ),
                        _categoryItem(
                          icon: Icons
                              .auto_awesome,
                          title:
                              'Custom',
                        ),
                        _categoryItem(
                          icon:
                              Icons.apps,
                          title:
                              'All Cakes',
                          onTap: () {
                            onNavigation(1);
                          },
                        ),
                        _categoryItem(
                          icon: Icons
                              .cookie_outlined,
                          title:
                              'All Brownies',
                          onTap: () {
                            onNavigation(1);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // ==================================================
            // POPULAR CAKES
            // ==================================================

            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                28,
                horizontalPadding,
                15,
              ),
              sliver:
                  SliverToBoxAdapter(
                child: SectionTitle(
                  title:
                      'Popular Cakes',
                  action: 'See all',
                  onTap: () {
                    onNavigation(1);
                  },
                ),
              ),
            ),

            SliverPadding(
              padding:
                  EdgeInsets.symmetric(
                horizontal:
                    horizontalPadding,
              ),
              sliver: SliverGrid(
                delegate:
                    SliverChildBuilderDelegate(
                  (context, index) {
                    return CakeCard(
                      cake:
                          CakeData.cakes[index],
                    );
                  },
                  childCount:
                      CakeData.cakes.length > 4
                          ? 4
                          : CakeData.cakes.length,
                ),
                gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      columns,
                  crossAxisSpacing:
                      isDesktop
                          ? 20
                          : 14,
                  mainAxisSpacing:
                      isDesktop
                          ? 20
                          : 14,
                  childAspectRatio:
                      isLargeDesktop
                          ? 0.78
                          : isDesktop
                              ? 0.72
                              : 0.68,
                ),
              ),
            ),

            // ==================================================
            // POPULAR BROWNIES
            // ==================================================

            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                35,
                horizontalPadding,
                15,
              ),
              sliver:
                  SliverToBoxAdapter(
                child: SectionTitle(
                  title:
                      'Popular Brownies',
                  action: 'See all',
                  onTap: () {
                    onNavigation(1);
                  },
                ),
              ),
            ),

            SliverPadding(
              padding:
                  EdgeInsets.symmetric(
                horizontal:
                    horizontalPadding,
              ),
              sliver: SliverGrid(
                delegate:
                    SliverChildBuilderDelegate(
                  (context, index) {
                    final brownie =
                        BrownieData
                            .brownies[index];

                    return _brownieCard(
                      context,
                      brownie,
                      isDark,
                    );
                  },
                  childCount:
                      BrownieData.brownies
                                  .length >
                              4
                          ? 4
                          : BrownieData
                              .brownies
                              .length,
                ),
                gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      columns,
                  crossAxisSpacing:
                      isDesktop
                          ? 20
                          : 14,
                  mainAxisSpacing:
                      isDesktop
                          ? 20
                          : 14,
                  childAspectRatio:
                      isLargeDesktop
                          ? 0.78
                          : isDesktop
                              ? 0.72
                              : 0.68,
                ),
              ),
            ),

            // ==================================================
            // FOOTER
            // ==================================================

            SliverToBoxAdapter(
              child: Padding(
                padding:
                    EdgeInsets.only(
                  top: 35,
                  bottom:
                      isDesktop
                          ? 50
                          : 30,
                ),
                child: Center(
                  child: Text(
                    'Made with ❤️ for cake lovers',
                    style: TextStyle(
                      color: bodyColor,
                      fontSize: 12,
                      fontWeight:
                          FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import '../../core/constants/app_colors.dart';
import '../../data/cake_data.dart';
import '../../providers/favorite_provider.dart';
import '../../widgets/cake_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // ==========================================
    // RESPONSIVE COLUMNS
    // ==========================================

    int crossAxisCount;

    if (screenWidth >= 1400) {
      // Large Desktop
      crossAxisCount = 5;
    } else if (screenWidth >= 1000) {
      // Laptop / Desktop
      crossAxisCount = 4;
    } else if (screenWidth >= 700) {
      // Tablet
      crossAxisCount = 3;
    } else {
      // Mobile
      crossAxisCount = 2;
    }

    // ==========================================
    // RESPONSIVE SPACING
    // ==========================================

    final double horizontalPadding = screenWidth >= 1000 ? 40 : 20;

    final double spacing = screenWidth >= 1000 ? 20 : 14;

    // ==========================================
    // GET FAVORITE CAKES
    // ==========================================

    final favoriteProvider = context.watch<FavoriteProvider>();

    final favoriteCakes = favoriteProvider.getFavoriteCakes(CakeData.cakes);

    return SafeArea(
      child: Column(
        children: [
          // ======================================
          // HEADER
          // ======================================

          Padding(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              20,
              horizontalPadding,
              15,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'My Favorites',
                style: TextStyle(
                  fontSize: screenWidth >= 700 ? 28 : 26,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),

          // ======================================
          // EMPTY FAVORITES
          // ======================================

          if (favoriteCakes.isEmpty)
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withValues(alpha: 0.10),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.favorite_border_rounded,
                          size: 48,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'No Favorites Yet',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: screenWidth >= 700 ? 24 : 21,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap the heart icon on a cake to add it to your favorites.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.color
                              ?.withValues(alpha: 0.65),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )

          // ======================================
          // FAVORITES GRID
          // ======================================

          else
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: 5,
                ),
                itemCount: favoriteCakes.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: spacing,
                  mainAxisSpacing: spacing,
                  childAspectRatio: screenWidth >= 1000 ? 0.75 : 0.68,
                ),
                itemBuilder: (context, index) {
                  return CakeCard(
                    cake: favoriteCakes[index],
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

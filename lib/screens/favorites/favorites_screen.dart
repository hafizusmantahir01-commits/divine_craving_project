import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../data/brownie_data.dart';
import '../../data/cake_data.dart';
import '../../models/brownie_model.dart';
import '../../providers/favorite_provider.dart';
import '../../widgets/cake_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  // ==========================================================
  // BROWNIE FAVORITE CARD
  // ==========================================================

  Widget _brownieCard(
    BuildContext context,
    BrownieModel brownie,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Consumer<FavoriteProvider>(
      builder: (context, provider, child) {
        final isFavorite = provider.isBrownieFavorite(
          brownie.id,
        );

        return Card(
          elevation: isDark ? 0 : 2,
          color: isDark ? const Color(0xFF241B18) : Colors.white,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 6,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.network(
                        brownie.image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppColors.lightCream,
                            child: const Center(
                              child: Icon(
                                Icons.cookie_outlined,
                                size: 45,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Material(
                        color: Colors.black.withOpacity(0.55),
                        shape: const CircleBorder(),
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () {
                            provider.toggleBrownieFavorite(
                              brownie,
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Icon(
                              isFavorite
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              color:
                                  isFavorite ? Colors.redAccent : Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        brownie.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color:
                              isDark ? Colors.white : theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        brownie.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isDark ? Colors.white70 : AppColors.grey,
                          fontSize: 11,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Rs. ${brownie.price}',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    int crossAxisCount;

    if (screenWidth >= 1400) {
      crossAxisCount = 5;
    } else if (screenWidth >= 1000) {
      crossAxisCount = 4;
    } else if (screenWidth >= 700) {
      crossAxisCount = 3;
    } else {
      crossAxisCount = 2;
    }

    final double horizontalPadding = screenWidth >= 1000 ? 40 : 20;

    final double spacing = screenWidth >= 1000 ? 20 : 14;

    final favoriteProvider = context.watch<FavoriteProvider>();

    final favoriteCakes = favoriteProvider.getFavoriteCakes(
      CakeData.cakes,
    );

    final favoriteBrownies = favoriteProvider.getFavoriteBrownies(
      BrownieData.brownies,
    );

    final bool isEmpty = favoriteCakes.isEmpty && favoriteBrownies.isEmpty;

    return SafeArea(
      child: Column(
        children: [
          // ==================================================
          // HEADER
          // ==================================================

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

          // ==================================================
          // EMPTY
          // ==================================================

          if (isEmpty)
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
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(
                                alpha: 0.10,
                              ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.favorite_border_rounded,
                          size: 48,
                          color: Theme.of(
                            context,
                          ).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'No Favorites Yet',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: screenWidth >= 700 ? 24 : 21,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(
                            context,
                          ).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Tap the heart icon on a cake or brownie to add it to your favorites.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.color?.withValues(
                                alpha: 0.65,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )

          // ==================================================
          // FAVORITES
          // ==================================================

          else
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: 5,
                ),
                itemCount: favoriteCakes.length + favoriteBrownies.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: spacing,
                  mainAxisSpacing: spacing,
                  childAspectRatio: screenWidth >= 1000 ? 0.75 : 0.68,
                ),
                itemBuilder: (context, index) {
                  // CAKES FIRST
                  if (index < favoriteCakes.length) {
                    return CakeCard(
                      cake: favoriteCakes[index],
                    );
                  }

                  // BROWNIES AFTER CAKES
                  final brownieIndex = index - favoriteCakes.length;

                  return _brownieCard(
                    context,
                    favoriteBrownies[brownieIndex],
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

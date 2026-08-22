import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_colors.dart';
import '../models/cake_model.dart';
import '../providers/cart_provider.dart';
import '../providers/favorite_provider.dart';
import '../screens/cake_details/cake_details_screen.dart';
import '../screens/cart/cart_screen.dart';

class CakeCard extends StatelessWidget {
  final CakeModel cake;

  const CakeCard({
    super.key,
    required this.cake,
  });

  @override
  Widget build(BuildContext context) {
    final favoriteProvider =
        context.watch<FavoriteProvider>();

    final cartProvider =
        context.watch<CartProvider>();

    final isFavorite =
        favoriteProvider.isFavorite(cake.id);

    final isInCart =
        cartProvider.contains(cake);

    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                CakeDetailsScreen(
              cake: cake,
            ),
          ),
        );
      },

      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius:
              BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.brown
                  .withValues(alpha: 0.08),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            // ==================================================
            // IMAGE
            // ==================================================

            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),

                    child: Image.network(
                      cake.image,

                      width: double.infinity,

                      height: double.infinity,

                      fit: BoxFit.cover,

                      errorBuilder:
                          (_, __, ___) {
                        return Center(
                          child: Icon(
                            Icons.cake_rounded,
                            size: 40,
                            color: theme
                                .colorScheme
                                .primary,
                          ),
                        );
                      },
                    ),
                  ),

                  // ==================================================
                  // FAVORITE
                  // ==================================================

                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      decoration:
                          BoxDecoration(
                        color:
                            theme.cardColor,
                        shape:
                            BoxShape.circle,
                      ),

                      child: IconButton(
                        tooltip: isFavorite
                            ? 'Remove from favorites'
                            : 'Add to favorites',

                        onPressed: () {
                          context
                              .read<
                                  FavoriteProvider>()
                              .toggleFavorite(
                                cake,
                              );
                        },

                        icon: Icon(
                          isFavorite
                              ? Icons
                                  .favorite_rounded
                              : Icons
                                  .favorite_border_rounded,

                          color: isFavorite
                              ? Colors.red
                              : theme
                                  .colorScheme
                                  .primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ==================================================
            // NAME
            // ==================================================

            Padding(
              padding:
                  const EdgeInsets.fromLTRB(
                12,
                10,
                12,
                2,
              ),

              child: Text(
                cake.name,
                maxLines: 1,
                overflow:
                    TextOverflow.ellipsis,

                style: TextStyle(
                  fontWeight:
                      FontWeight.bold,
                  color: theme
                      .colorScheme
                      .primary,
                ),
              ),
            ),

            // ==================================================
            // RATING + PRICE
            // ==================================================

            Padding(
              padding:
                  const EdgeInsets.fromLTRB(
                12,
                5,
                12,
                8,
              ),

              child: Row(
                children: [
                  const Icon(
                    Icons.star_rounded,
                    size: 16,
                    color: AppColors.gold,
                  ),

                  const SizedBox(width: 4),

                  Text(
                    '${cake.rating}',
                    style: TextStyle(
                      fontSize: 12,
                      color: theme
                          .textTheme
                          .bodyMedium
                          ?.color,
                    ),
                  ),

                  const Spacer(),

                  Text(
                    'Rs ${cake.price.toInt()}',
                    style: TextStyle(
                      fontWeight:
                          FontWeight.bold,
                      color: theme
                          .colorScheme
                          .primary,
                    ),
                  ),
                ],
              ),
            ),

            // ==================================================
            // ADD TO CART
            // ==================================================

            Padding(
              padding:
                  const EdgeInsets.fromLTRB(
                12,
                0,
                12,
                12,
              ),

              child: SizedBox(
                width: double.infinity,
                height: 42,

                child: FilledButton.icon(
                  onPressed: () {
                    if (isInCart) {
                      ScaffoldMessenger.of(
                        context,
                      ).hideCurrentSnackBar();

                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Cake is already in your cart.',
                          ),
                        ),
                      );

                      return;
                    }

                    // ==================================================
                    // ADD ITEM
                    // ==================================================

                    context
                        .read<CartProvider>()
                        .addToCart(cake);

                    ScaffoldMessenger.of(
                      context,
                    ).hideCurrentSnackBar();

                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${cake.name} added to cart',
                        ),

                        duration:
                            const Duration(
                          seconds: 2,
                        ),

                        action:
                            SnackBarAction(
                          label: 'VIEW CART',

                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const CartScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },

                  icon: Icon(
                    isInCart
                        ? Icons.check_rounded
                        : Icons
                            .shopping_cart_outlined,
                    size: 18,
                  ),

                  label: Text(
                    isInCart
                        ? 'Added to Cart'
                        : 'Add to Cart',

                    style:
                        const TextStyle(
                      fontWeight:
                          FontWeight.w800,
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
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_colors.dart';
import '../models/brownie_model.dart';
import '../providers/cart_provider.dart';
import '../providers/favorite_provider.dart';
import '../screens/cart/cart_screen.dart';

class BrownieCard extends StatelessWidget {
  final BrownieModel brownie;

  const BrownieCard({
    super.key,
    required this.brownie,
  });

  void _showAddedMessage(
    BuildContext context,
  ) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            '${brownie.name} added to cart',
          ),
          duration:
              const Duration(seconds: 2),
          behavior:
              SnackBarBehavior.floating,
          action: SnackBarAction(
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
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isDark =
        theme.brightness == Brightness.dark;

    final favoriteProvider =
        context.watch<FavoriteProvider>();

    final cartProvider =
        context.watch<CartProvider>();

    final isFavorite =
        favoriteProvider
            .isBrownieFavorite(
      brownie.id,
    );

    final isInCart =
        cartProvider.containsBrownie(
      brownie,
    );

    final cardColor = isDark
        ? const Color(0xFF241B18)
        : Colors.white;

    final titleColor = isDark
        ? Colors.white
        : theme.colorScheme.primary;

    final bodyColor = isDark
        ? Colors.white70
        : AppColors.grey;

    return Material(
      color: cardColor,
      elevation: isDark ? 0 : 2,
      shadowColor: Colors.black12,
      borderRadius:
          BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius:
            BorderRadius.circular(20),
        onTap: () {},
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            // ==================================================
            // IMAGE
            // ==================================================

            Expanded(
              flex: 5,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    brownie.image,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (
                      context,
                      error,
                      stackTrace,
                    ) {
                      return Container(
                        color: isDark
                            ? const Color(
                                0xFF30231F,
                              )
                            : AppColors
                                .lightCream,
                        child: Icon(
                          Icons
                              .cookie_outlined,
                          size: 42,
                          color: bodyColor,
                        ),
                      );
                    },
                    loadingBuilder: (
                      context,
                      child,
                      loadingProgress,
                    ) {
                      if (loadingProgress ==
                          null) {
                        return child;
                      }

                      return Container(
                        color: isDark
                            ? const Color(
                                0xFF30231F,
                              )
                            : AppColors
                                .lightCream,
                        child:
                            const Center(
                          child:
                              CircularProgressIndicator(),
                        ),
                      );
                    },
                  ),

                  // ==================================================
                  // FAVORITE
                  // ==================================================

                  Positioned(
                    top: 10,
                    right: 10,
                    child: Material(
                      color: theme.cardColor
                          .withOpacity(
                        0.92,
                      ),
                      shape:
                          const CircleBorder(),
                      child: InkWell(
                        customBorder:
                            const CircleBorder(),
                        onTap: () {
                          context
                              .read<
                                  FavoriteProvider>()
                              .toggleBrownieFavorite(
                                brownie,
                              );
                        },
                        child: Padding(
                          padding:
                              const EdgeInsets
                                  .all(8),
                          child: Icon(
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
                            size: 21,
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
              flex: 5,
              child: Padding(
                padding:
                    const EdgeInsets.fromLTRB(
                  12,
                  9,
                  12,
                  10,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    // NAME
                    Text(
                      brownie.name,
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style: TextStyle(
                        color: titleColor,
                        fontSize: 14,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      height: 4,
                    ),

                    // DESCRIPTION
                    Text(
                      brownie.description,
                      maxLines: 2,
                      overflow:
                          TextOverflow.ellipsis,
                      style: TextStyle(
                        color: bodyColor,
                        fontSize: 11,
                        height: 1.2,
                      ),
                    ),

                    const Spacer(),

                    // RATING + PRICE
                    Row(
                      children: [
                        const Icon(
                          Icons
                              .star_rounded,
                          color:
                              AppColors.gold,
                          size: 16,
                        ),

                        const SizedBox(
                          width: 3,
                        ),

                        Text(
                          brownie.rating
                              .toString(),
                          style:
                              TextStyle(
                            color:
                                bodyColor,
                            fontSize: 11,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),

                        const Spacer(),

                        Text(
                          'Rs. ${brownie.price.toInt()}',
                          style:
                              TextStyle(
                            color: theme
                                .colorScheme
                                .primary,
                            fontSize: 13,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    // ==================================================
                    // ADD TO CART BUTTON
                    // ==================================================

                    SizedBox(
                      width:
                          double.infinity,
                      height: 38,
                      child:
                          FilledButton.icon(
                        onPressed: () {
                          if (isInCart) {
                            ScaffoldMessenger
                                .of(
                              context,
                            )
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Brownie is already in your cart.',
                                  ),
                                ),
                              );

                            return;
                          }

                          context
                              .read<
                                  CartProvider>()
                              .addBrownieToCart(
                                brownie,
                              );

                          _showAddedMessage(
                            context,
                          );
                        },
                        icon: Icon(
                          isInCart
                              ? Icons
                                  .check_rounded
                              : Icons
                                  .shopping_cart_outlined,
                          size: 17,
                        ),
                        label: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            isInCart
                                ? 'Added to Cart'
                                : 'Add to Cart',
                            style:
                                const TextStyle(
                              fontWeight:
                                  FontWeight
                                      .w800,
                              fontSize: 12,
                            ),
                          ),
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
    );
  }
}
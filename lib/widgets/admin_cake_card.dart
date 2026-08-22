import 'dart:io';

import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class CakeCard extends StatelessWidget {
  final String name;
  final String category;
  final String price;
  final String rating;
  final String? imagePath;

  final VoidCallback? onTap;
  final VoidCallback? onFavorite;
  final VoidCallback? onAddToCart;

  const CakeCard({
    super.key,
    required this.name,
    required this.category,
    required this.price,
    required this.rating,
    this.imagePath,
    this.onTap,
    this.onFavorite,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      color: Colors.white,
      shadowColor: Colors.black.withOpacity(0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =====================================================
            // IMAGE
            // =====================================================

            Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 190,
                  child: _buildCakeImage(),
                ),

                // Favorite Button
                Positioned(
                  top: 12,
                  right: 12,
                  child: Material(
                    color: Colors.white,
                    shape: const CircleBorder(),
                    elevation: 2,
                    child: IconButton(
                      onPressed: onFavorite,
                      icon: const Icon(
                        Icons.favorite_border,
                        color: Colors.redAccent,
                      ),
                      tooltip: 'Favorite',
                    ),
                  ),
                ),

                // Category
                Positioned(
                  left: 12,
                  bottom: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.brown,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      category,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // =====================================================
            // DETAILS
            // =====================================================

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cake Name
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.brown,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Rating
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 19,
                      ),

                      const SizedBox(width: 5),

                      Text(
                        rating,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(width: 6),

                      const Text(
                        'Rating',
                        style: TextStyle(
                          color: AppColors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Price + Cart
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          price,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.brown,
                          ),
                        ),
                      ),

                      // Add To Cart
                      SizedBox(
                        height: 44,
                        child: ElevatedButton.icon(
                          onPressed: onAddToCart,
                          icon: const Icon(
                            Icons.shopping_cart_outlined,
                            size: 19,
                          ),
                          label: const Text(
                            'Add',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.brown,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // CAKE IMAGE
  // =====================================================

  Widget _buildCakeImage() {
    if (imagePath != null &&
        imagePath!.isNotEmpty &&
        File(imagePath!).existsSync()) {
      return Image.file(
        File(imagePath!),
        fit: BoxFit.cover,
      );
    }

    return Container(
      color: AppColors.peach,
      child: const Center(
        child: Icon(
          Icons.cake_outlined,
          size: 70,
          color: AppColors.brown,
        ),
      ),
    );
  }
}
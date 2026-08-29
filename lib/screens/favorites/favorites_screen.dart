import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../models/brownie_model.dart';
import '../../models/cake_model.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  FirebaseAuth get _auth => FirebaseAuth.instance;

  // ==========================================================
  // REMOVE FAVORITE
  // ==========================================================

  Future<void> _removeFavorite(
    BuildContext context,
    String favoriteId,
  ) async {
    try {
      await _firestore
          .collection('favorites')
          .doc(favoriteId)
          .delete();

      if (!context.mounted) return;

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text(
              'Removed from favorites',
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
    } on FirebaseException catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              e.message ??
                  'Unable to remove favorite.',
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
    } catch (_) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text(
              'Something went wrong.',
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
    }
  }

  // ==========================================================
  // CAKE FAVORITE CARD
  // ==========================================================

  Widget _cakeCard(
    BuildContext context,
    CakeModel cake,
    String favoriteId,
  ) {
    final theme = Theme.of(context);

    final bool isDark =
        theme.brightness == Brightness.dark;

    return Card(
      elevation: isDark ? 0 : 2,
      color:
          isDark
              ? const Color(0xFF241B18)
              : Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
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
                    cake.image,
                    fit: BoxFit.cover,
                    errorBuilder: (
                      context,
                      error,
                      stackTrace,
                    ) {
                      return Container(
                        color:
                            AppColors.lightCream,
                        child: const Center(
                          child: Icon(
                            Icons.cake_outlined,
                            size: 45,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // ==================================================
                // REMOVE FAVORITE
                // ==================================================

                Positioned(
                  top: 10,
                  right: 10,
                  child: Material(
                    color:
                        Colors.black.withOpacity(
                      0.55,
                    ),
                    shape:
                        const CircleBorder(),
                    child: InkWell(
                      customBorder:
                          const CircleBorder(),
                      onTap: () {
                        _removeFavorite(
                          context,
                          favoriteId,
                        );
                      },
                      child: const Padding(
                        padding:
                            EdgeInsets.all(8),
                        child: Icon(
                          Icons.favorite_rounded,
                          color:
                              Colors.redAccent,
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
              padding:
                  const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    cake.name,
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isDark
                          ? Colors.white
                          : theme.colorScheme.primary,
                      fontWeight:
                          FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(
                    height: 5,
                  ),

                  Text(
                    cake.description,
                    maxLines: 2,
                    overflow:
                        TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isDark
                          ? Colors.white70
                          : AppColors.grey,
                      fontSize: 11,
                    ),
                  ),

                  const Spacer(),

                  Text(
                    'Rs. ${cake.price.toStringAsFixed(0)}',
                    style: TextStyle(
                      color:
                          theme.colorScheme.primary,
                      fontWeight:
                          FontWeight.bold,
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
  }

  // ==========================================================
  // BROWNIE FAVORITE CARD
  // ==========================================================

  Widget _brownieCard(
    BuildContext context,
    BrownieModel brownie,
    String favoriteId,
  ) {
    final theme = Theme.of(context);

    final bool isDark =
        theme.brightness == Brightness.dark;

    return Card(
      elevation: isDark ? 0 : 2,
      color:
          isDark
              ? const Color(0xFF241B18)
              : Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
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
                    errorBuilder: (
                      context,
                      error,
                      stackTrace,
                    ) {
                      return Container(
                        color:
                            AppColors.lightCream,
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

                // ==================================================
                // REMOVE FAVORITE
                // ==================================================

                Positioned(
                  top: 10,
                  right: 10,
                  child: Material(
                    color:
                        Colors.black.withOpacity(
                      0.55,
                    ),
                    shape:
                        const CircleBorder(),
                    child: InkWell(
                      customBorder:
                          const CircleBorder(),
                      onTap: () {
                        _removeFavorite(
                          context,
                          favoriteId,
                        );
                      },
                      child: const Padding(
                        padding:
                            EdgeInsets.all(8),
                        child: Icon(
                          Icons.favorite_rounded,
                          color:
                              Colors.redAccent,
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
              padding:
                  const EdgeInsets.all(12),
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
                      color: isDark
                          ? Colors.white
                          : theme.colorScheme.primary,
                      fontWeight:
                          FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(
                    height: 5,
                  ),

                  Text(
                    brownie.description,
                    maxLines: 2,
                    overflow:
                        TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isDark
                          ? Colors.white70
                          : AppColors.grey,
                      fontSize: 11,
                    ),
                  ),

                  const Spacer(),

                  Text(
                    'Rs. ${brownie.price.toStringAsFixed(0)}',
                    style: TextStyle(
                      color:
                          theme.colorScheme.primary,
                      fontWeight:
                          FontWeight.bold,
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
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    final User? user =
        _auth.currentUser;

    final screenWidth =
        MediaQuery.of(context).size.width;

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

    final double horizontalPadding =
        screenWidth >= 1000 ? 40 : 20;

    final double spacing =
        screenWidth >= 1000 ? 20 : 14;

    // ==========================================================
    // USER NOT LOGGED IN
    // ==========================================================

    if (user == null) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding:
                  const EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border_rounded,
                    size: 70,
                    color:
                        Theme.of(context)
                            .colorScheme
                            .primary,
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  Text(
                    'Please Login',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight:
                          FontWeight.bold,
                      color:
                          Theme.of(context)
                              .colorScheme
                              .primary,
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  const Text(
                    'Login to view your favorites.',
                    textAlign:
                        TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // ==========================================================
    // FIRESTORE FAVORITES
    // ==========================================================

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
              alignment:
                  Alignment.centerLeft,
              child: Text(
                'My Favorites',
                style: TextStyle(
                  fontSize:
                      screenWidth >= 700
                          ? 28
                          : 26,
                  fontWeight:
                      FontWeight.bold,
                  color:
                      Theme.of(context)
                          .colorScheme
                          .primary,
                ),
              ),
            ),
          ),

          // ==================================================
          // FIRESTORE STREAM
          // ==================================================

          Expanded(
            child: StreamBuilder<
                QuerySnapshot<
                    Map<String, dynamic>>>(
              stream: _firestore
                  .collection('favorites')
                  .where(
                    'userId',
                    isEqualTo: user.uid,
                  )
                  .snapshots(),
              builder: (
                context,
                snapshot,
              ) {
                // ==================================================
                // LOADING
                // ==================================================

                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child:
                        CircularProgressIndicator(),
                  );
                }

                // ==================================================
                // ERROR
                // ==================================================

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding:
                          const EdgeInsets.all(30),
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 60,
                            color:
                                Colors.red,
                          ),

                          const SizedBox(
                            height: 15,
                          ),

                          Text(
                            'Unable to load favorites',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight:
                                  FontWeight.bold,
                              color:
                                  Theme.of(context)
                                      .colorScheme
                                      .primary,
                            ),
                          ),

                          const SizedBox(
                            height: 8,
                          ),

                          Text(
                            snapshot.error.toString(),
                            textAlign:
                                TextAlign.center,
                            maxLines: 3,
                            overflow:
                                TextOverflow.ellipsis,
                            style: const TextStyle(
                              color:
                                  Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final favorites =
                    snapshot.data?.docs ??
                        [];

                // ==================================================
                // EMPTY
                // ==================================================

                if (favorites.isEmpty) {
                  return Center(
                    child: Padding(
                      padding:
                          const EdgeInsets.all(30),
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 90,
                            height: 90,
                            decoration:
                                BoxDecoration(
                              color:
                                  Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(
                                        0.10,
                                      ),
                              shape:
                                  BoxShape.circle,
                            ),
                            child: Icon(
                              Icons
                                  .favorite_border_rounded,
                              size: 48,
                              color:
                                  Theme.of(context)
                                      .colorScheme
                                      .primary,
                            ),
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          Text(
                            'No Favorites Yet',
                            textAlign:
                                TextAlign.center,
                            style: TextStyle(
                              fontSize:
                                  screenWidth >= 700
                                      ? 24
                                      : 21,
                              fontWeight:
                                  FontWeight.bold,
                              color:
                                  Theme.of(context)
                                      .colorScheme
                                      .primary,
                            ),
                          ),

                          const SizedBox(
                            height: 8,
                          ),

                          Text(
                            'Tap the heart icon on a cake or brownie to add it to your favorites.',
                            textAlign:
                                TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color:
                                  Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color
                                      ?.withOpacity(
                                        0.65,
                                      ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // ==================================================
                // FAVORITES GRID
                // ==================================================

                return GridView.builder(
                  padding:
                      EdgeInsets.symmetric(
                    horizontal:
                        horizontalPadding,
                    vertical: 5,
                  ),
                  itemCount:
                      favorites.length,
                  gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        crossAxisCount,
                    crossAxisSpacing:
                        spacing,
                    mainAxisSpacing:
                        spacing,
                    childAspectRatio:
                        screenWidth >= 1000
                            ? 0.75
                            : 0.68,
                  ),
                  itemBuilder: (
                    context,
                    index,
                  ) {
                    final favoriteDoc =
                        favorites[index];

                    final data =
                        favoriteDoc.data();

                    final String type =
                        data['type']
                                ?.toString()
                                .toLowerCase() ??
                            'cake';

                    // ==================================================
                    // CAKE
                    // ==================================================

                    if (type == 'cake') {
                      final CakeModel cake =
                          CakeModel(
                        id: data['productId']
                                ?.toString() ??
                            favoriteDoc.id,
                        name: data['name']
                                ?.toString() ??
                            'Cake',
                        category:
                            data['category']
                                    ?.toString() ??
                                '',
                        image:
                            data['image']
                                    ?.toString() ??
                                '',
                        price:
                            _getDouble(
                          data['price'],
                        ),
                        rating:
                            _getDouble(
                          data['rating'],
                        ),
                        reviews:
                            _getInt(
                          data['reviews'],
                        ),
                        description:
                            data['description']
                                    ?.toString() ??
                                '',
                      );

                      return _cakeCard(
                        context,
                        cake,
                        favoriteDoc.id,
                      );
                    }

                    // ==================================================
                    // BROWNIE
                    // ==================================================

                    final BrownieModel brownie =
                        BrownieModel(
                      id: _getInt(
                        data['productId'],
                      ),
                      name:
                          data['name']
                                  ?.toString() ??
                              'Brownie',
                      description:
                          data['description']
                                  ?.toString() ??
                              '',
                      price:
                          _getDouble(
                        data['price'],
                      ),
                      image:
                          data['image']
                                  ?.toString() ??
                              '',
                      category:
                          data['category']
                                  ?.toString() ??
                              '',
                      rating:
                          _getDouble(
                        data['rating'],
                      ),
                    );

                    return _brownieCard(
                      context,
                      brownie,
                      favoriteDoc.id,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // SAFE DOUBLE CONVERSION
  // ==========================================================

  static double _getDouble(
    dynamic value,
  ) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }

  // ==========================================================
  // SAFE INTEGER CONVERSION
  // ==========================================================

  static int _getInt(
    dynamic value,
  ) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }
}
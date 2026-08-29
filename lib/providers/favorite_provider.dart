import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/cake_model.dart';
import '../models/brownie_model.dart';

class FavoriteProvider extends ChangeNotifier {
  FavoriteProvider() {
    _initializeFavorites();
  }

  // ==========================================================
  // FIREBASE
  // ==========================================================

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  // ==========================================================
  // LOCAL FAVORITES
  // ==========================================================

  final Set<String> _favoriteCakeIds =
      <String>{};

  final Set<int> _favoriteBrownieIds =
      <int>{};

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // ==========================================================
  // CURRENT USER
  // ==========================================================

  User? get _currentUser =>
      _auth.currentUser;

  String? get _uid =>
      _currentUser?.uid;

  // ==========================================================
  // FIRESTORE FAVORITES REFERENCE
  // ==========================================================

  CollectionReference<Map<String, dynamic>>?
      get _favoritesReference {
    final uid = _uid;

    if (uid == null) {
      return null;
    }

    return _firestore
        .collection('users')
        .doc(uid)
        .collection('favorites');
  }

  // ==========================================================
  // CAKE FAVORITE CHECK
  // ==========================================================

  bool isFavorite(String cakeId) {
    return _favoriteCakeIds.contains(cakeId);
  }

  bool isCakeFavorite(String cakeId) {
    return _favoriteCakeIds.contains(cakeId);
  }

  // ==========================================================
  // TOGGLE CAKE FAVORITE
  // ==========================================================

  Future<void> toggleFavorite(
    CakeModel cake,
  ) async {
    final uid = _uid;

    if (uid == null) {
      debugPrint(
        'Cannot change favorite: user is not logged in.',
      );
      return;
    }

    final favorites = _favoritesReference;

    if (favorites == null) {
      return;
    }

    final documentId =
        'cake_${cake.id}';

    final document =
        favorites.doc(documentId);

    final alreadyFavorite =
        _favoriteCakeIds.contains(cake.id);

    // ========================================================
    // REMOVE FAVORITE
    // ========================================================

    if (alreadyFavorite) {
      _favoriteCakeIds.remove(cake.id);

      notifyListeners();

      try {
        await document.delete();
      } catch (e) {
        // Restore local state if Firebase fails
        _favoriteCakeIds.add(cake.id);

        notifyListeners();

        debugPrint(
          'Remove cake favorite error: $e',
        );
      }

      return;
    }

    // ========================================================
    // ADD FAVORITE
    // ========================================================

    _favoriteCakeIds.add(cake.id);

    notifyListeners();

    try {
      await document.set({
        'type': 'cake',
        'productId': cake.id,
        'name': cake.name,
        'category': cake.category,
        'image': cake.image,
        'price': cake.price,
        'rating': cake.rating,
        'reviews': cake.reviews,
        'description': cake.description,
        'createdAt':
            FieldValue.serverTimestamp(),
        'updatedAt':
            FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // Remove local favorite if Firebase fails
      _favoriteCakeIds.remove(cake.id);

      notifyListeners();

      debugPrint(
        'Add cake favorite error: $e',
      );
    }
  }

  // ==========================================================
  // GET FAVORITE CAKES
  // ==========================================================

  List<CakeModel> getFavoriteCakes(
    List<CakeModel> cakes,
  ) {
    return cakes
        .where(
          (cake) =>
              _favoriteCakeIds.contains(
            cake.id,
          ),
        )
        .toList();
  }

  // ==========================================================
  // BROWNIE FAVORITE CHECK
  // ==========================================================

  bool isBrownieFavorite(
    int brownieId,
  ) {
    return _favoriteBrownieIds.contains(
      brownieId,
    );
  }

  // ==========================================================
  // TOGGLE BROWNIE FAVORITE
  // ==========================================================

  Future<void> toggleBrownieFavorite(
    BrownieModel brownie,
  ) async {
    final uid = _uid;

    if (uid == null) {
      debugPrint(
        'Cannot change favorite: user is not logged in.',
      );
      return;
    }

    final favorites = _favoritesReference;

    if (favorites == null) {
      return;
    }

    final documentId =
        'brownie_${brownie.id}';

    final document =
        favorites.doc(documentId);

    final alreadyFavorite =
        _favoriteBrownieIds.contains(
      brownie.id,
    );

    // ========================================================
    // REMOVE BROWNIE FAVORITE
    // ========================================================

    if (alreadyFavorite) {
      _favoriteBrownieIds.remove(
        brownie.id,
      );

      notifyListeners();

      try {
        await document.delete();
      } catch (e) {
        // Restore local state if Firebase fails
        _favoriteBrownieIds.add(
          brownie.id,
        );

        notifyListeners();

        debugPrint(
          'Remove brownie favorite error: $e',
        );
      }

      return;
    }

    // ========================================================
    // ADD BROWNIE FAVORITE
    // ========================================================

    _favoriteBrownieIds.add(
      brownie.id,
    );

    notifyListeners();

    try {
      await document.set({
        'type': 'brownie',
        'productId': brownie.id,
        'name': brownie.name,
        'description': brownie.description,
        'price': brownie.price,
        'image': brownie.image,
        'category': brownie.category,
        'rating': brownie.rating,
        'createdAt':
            FieldValue.serverTimestamp(),
        'updatedAt':
            FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // Remove local favorite if Firebase fails
      _favoriteBrownieIds.remove(
        brownie.id,
      );

      notifyListeners();

      debugPrint(
        'Add brownie favorite error: $e',
      );
    }
  }

  // ==========================================================
  // GET FAVORITE BROWNIES
  // ==========================================================

  List<BrownieModel> getFavoriteBrownies(
    List<BrownieModel> brownies,
  ) {
    return brownies
        .where(
          (brownie) =>
              _favoriteBrownieIds.contains(
            brownie.id,
          ),
        )
        .toList();
  }

  // ==========================================================
  // TOTAL FAVORITES
  // ==========================================================

  int get totalFavorites {
    return _favoriteCakeIds.length +
        _favoriteBrownieIds.length;
  }

  // ==========================================================
  // INITIALIZE FAVORITES
  // ==========================================================

  Future<void> _initializeFavorites() async {
    final user = _currentUser;

    if (user == null) {
      return;
    }

    await loadFavorites();
  }

  // ==========================================================
  // LOAD FAVORITES FROM FIREBASE
  // ==========================================================

  Future<void> loadFavorites() async {
    final favorites =
        _favoritesReference;

    if (favorites == null) {
      return;
    }

    try {
      _isLoading = true;

      notifyListeners();

      final snapshot =
          await favorites.get();

      _favoriteCakeIds.clear();
      _favoriteBrownieIds.clear();

      for (final document
          in snapshot.docs) {
        final data =
            document.data();

        final type =
            data['type'];

        final productId =
            data['productId'];

        if (type == 'cake') {
          if (productId != null) {
            _favoriteCakeIds.add(
              productId.toString(),
            );
          }
        }

        if (type == 'brownie') {
          if (productId is num) {
            _favoriteBrownieIds.add(
              productId.toInt(),
            );
          } else {
            final id =
                int.tryParse(
              productId.toString(),
            );

            if (id != null) {
              _favoriteBrownieIds.add(
                id,
              );
            }
          }
        }
      }
    } catch (e) {
      debugPrint(
        'Favorite loading error: $e',
      );
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  // ==========================================================
  // REFRESH FOR USER
  // ==========================================================

  Future<void> refreshForUser() async {
    _favoriteCakeIds.clear();

    _favoriteBrownieIds.clear();

    notifyListeners();

    await loadFavorites();
  }

  // ==========================================================
  // CLEAR ALL FAVORITES
  // ==========================================================

  Future<void> clearFavorites() async {
    _favoriteCakeIds.clear();

    _favoriteBrownieIds.clear();

    notifyListeners();

    final favorites =
        _favoritesReference;

    if (favorites == null) {
      return;
    }

    try {
      final snapshot =
          await favorites.get();

      final batch =
          _firestore.batch();

      for (final document
          in snapshot.docs) {
        batch.delete(
          document.reference,
        );
      }

      await batch.commit();
    } catch (e) {
      debugPrint(
        'Clear favorites error: $e',
      );
    }
  }
}
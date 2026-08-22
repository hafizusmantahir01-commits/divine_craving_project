import 'package:flutter/material.dart';

import '../models/cake_model.dart';
import '../models/brownie_model.dart';

class FavoriteProvider extends ChangeNotifier {
  final Set<String> _favoriteCakeIds = <String>{};

  final Set<int> _favoriteBrownieIds = <int>{};

  // CakeCard compatibility
  bool isFavorite(String cakeId) {
    return _favoriteCakeIds.contains(cakeId);
  }

  bool isCakeFavorite(String cakeId) {
    return _favoriteCakeIds.contains(cakeId);
  }

  void toggleFavorite(CakeModel cake) {
    if (_favoriteCakeIds.contains(cake.id)) {
      _favoriteCakeIds.remove(cake.id);
    } else {
      _favoriteCakeIds.add(cake.id);
    }

    notifyListeners();
  }

  List<CakeModel> getFavoriteCakes(
    List<CakeModel> cakes,
  ) {
    return cakes
        .where(
          (cake) => _favoriteCakeIds.contains(cake.id),
        )
        .toList();
  }

  // ==========================================================
  // BROWNIES
  // ==========================================================

  bool isBrownieFavorite(int brownieId) {
    return _favoriteBrownieIds.contains(brownieId);
  }

  void toggleBrownieFavorite(BrownieModel brownie) {
    if (_favoriteBrownieIds.contains(brownie.id)) {
      _favoriteBrownieIds.remove(brownie.id);
    } else {
      _favoriteBrownieIds.add(brownie.id);
    }

    notifyListeners();
  }

  List<BrownieModel> getFavoriteBrownies(
    List<BrownieModel> brownies,
  ) {
    return brownies
        .where(
          (brownie) =>
              _favoriteBrownieIds.contains(brownie.id),
        )
        .toList();
  }

  int get totalFavorites {
    return _favoriteCakeIds.length +
        _favoriteBrownieIds.length;
  }
}
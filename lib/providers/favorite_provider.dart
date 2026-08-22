import 'package:flutter/material.dart';
import '../models/cake_model.dart';

class FavoriteProvider extends ChangeNotifier {
  final Set<String> _favoriteIds = {};

  bool isFavorite(String cakeId) {
    return _favoriteIds.contains(cakeId);
  }

  void toggleFavorite(CakeModel cake) {
    if (_favoriteIds.contains(cake.id)) {
      _favoriteIds.remove(cake.id);
    } else {
      _favoriteIds.add(cake.id);
    }

    notifyListeners();
  }

  List<CakeModel> getFavoriteCakes(List<CakeModel> cakes) {
    return cakes.where((cake) => _favoriteIds.contains(cake.id)).toList();
  }
}

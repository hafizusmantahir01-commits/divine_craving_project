import 'package:flutter/foundation.dart';

import '../models/cake_model.dart';
import '../models/brownie_model.dart';

class CartProvider extends ChangeNotifier {
  CartProvider();

  // ==========================================================
  // CAKES
  // ==========================================================

  final List<CakeModel> _items = [];
  final Map<String, int> _quantities = {};

  List<CakeModel> get items =>
      List.unmodifiable(_items);

  int get itemCount => _items.length;

  bool get isEmpty =>
      _items.isEmpty && _brownieItems.isEmpty;

  bool contains(CakeModel cake) {
    return _items.any(
      (item) => item.id == cake.id,
    );
  }

  void addToCart(CakeModel cake) {
    if (contains(cake)) {
      increaseQuantity(cake);
      return;
    }

    _items.add(cake);
    _quantities[cake.id] = 1;

    notifyListeners();
  }

  void removeFromCart(CakeModel cake) {
    _items.removeWhere(
      (item) => item.id == cake.id,
    );

    _quantities.remove(cake.id);

    notifyListeners();
  }

  int quantityOf(CakeModel cake) {
    return _quantities[cake.id] ?? 1;
  }

  void increaseQuantity(CakeModel cake) {
    if (!contains(cake)) return;

    final quantity = quantityOf(cake);

    _quantities[cake.id] =
        quantity + 1;

    notifyListeners();
  }

  void decreaseQuantity(CakeModel cake) {
    if (!contains(cake)) return;

    final quantity = quantityOf(cake);

    if (quantity <= 1) {
      removeFromCart(cake);
      return;
    }

    _quantities[cake.id] =
        quantity - 1;

    notifyListeners();
  }

  // ==========================================================
  // BROWNIES
  // ==========================================================

  final List<BrownieModel> _brownieItems = [];

  final Map<int, int> _brownieQuantities = {};

  List<BrownieModel> get brownieItems =>
      List.unmodifiable(_brownieItems);

  bool containsBrownie(
    BrownieModel brownie,
  ) {
    return _brownieItems.any(
      (item) => item.id == brownie.id,
    );
  }

  void addBrownieToCart(
    BrownieModel brownie,
  ) {
    if (containsBrownie(brownie)) {
      increaseBrownieQuantity(brownie);
      return;
    }

    _brownieItems.add(brownie);

    _brownieQuantities[brownie.id] = 1;

    notifyListeners();
  }

  void removeBrownieFromCart(
    BrownieModel brownie,
  ) {
    _brownieItems.removeWhere(
      (item) => item.id == brownie.id,
    );

    _brownieQuantities.remove(
      brownie.id,
    );

    notifyListeners();
  }

  int brownieQuantityOf(
    BrownieModel brownie,
  ) {
    return _brownieQuantities[
            brownie.id] ??
        1;
  }

  void increaseBrownieQuantity(
    BrownieModel brownie,
  ) {
    if (!containsBrownie(brownie)) {
      return;
    }

    final quantity =
        brownieQuantityOf(brownie);

    _brownieQuantities[brownie.id] =
        quantity + 1;

    notifyListeners();
  }

  void decreaseBrownieQuantity(
    BrownieModel brownie,
  ) {
    if (!containsBrownie(brownie)) {
      return;
    }

    final quantity =
        brownieQuantityOf(brownie);

    if (quantity <= 1) {
      removeBrownieFromCart(brownie);
      return;
    }

    _brownieQuantities[brownie.id] =
        quantity - 1;

    notifyListeners();
  }

  // ==========================================================
  // TOTAL ITEMS
  // ==========================================================

  int get totalItemCount {
    return _items.length +
        _brownieItems.length;
  }

  // ==========================================================
  // CLEAR CART
  // ==========================================================

  void clearCart() {
    _items.clear();
    _quantities.clear();

    _brownieItems.clear();
    _brownieQuantities.clear();

    notifyListeners();
  }

  // ==========================================================
  // CAKE SUBTOTAL
  // ==========================================================

  double get cakeSubtotal {
    double total = 0;

    for (final cake in _items) {
      total +=
          cake.price * quantityOf(cake);
    }

    return total;
  }

  // ==========================================================
  // BROWNIE SUBTOTAL
  // ==========================================================

  double get brownieSubtotal {
    double total = 0;

    for (final brownie in _brownieItems) {
      total += brownie.price *
          brownieQuantityOf(brownie);
    }

    return total;
  }

  // ==========================================================
  // SUBTOTAL
  // ==========================================================

  double get subtotal {
    return cakeSubtotal +
        brownieSubtotal;
  }

  // ==========================================================
  // DELIVERY
  // ==========================================================

  double get deliveryFee {
    if (totalItemCount == 0) {
      return 0;
    }

    return 200;
  }

  // ==========================================================
  // TOTAL
  // ==========================================================

  double get total {
    return subtotal + deliveryFee;
  }
}
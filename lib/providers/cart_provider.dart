import 'package:flutter/foundation.dart';
import '../models/cake_model.dart';

class CartProvider extends ChangeNotifier {
  CartProvider();

  final List<CakeModel> _items = [];
  final Map<String, int> _quantities = {};

  List<CakeModel> get items => List.unmodifiable(_items);

  int get itemCount => _items.length;

  bool get isEmpty => _items.isEmpty;

  bool contains(CakeModel cake) {
    return _items.any((item) => item.id == cake.id);
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
    _items.removeWhere((item) => item.id == cake.id);
    _quantities.remove(cake.id);

    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    _quantities.clear();

    notifyListeners();
  }

  int quantityOf(CakeModel cake) {
    return _quantities[cake.id] ?? 1;
  }

  void increaseQuantity(CakeModel cake) {
    if (!contains(cake)) return;

    final currentQuantity = quantityOf(cake);

    _quantities[cake.id] = currentQuantity + 1;

    notifyListeners();
  }

  void decreaseQuantity(CakeModel cake) {
    if (!contains(cake)) return;

    final currentQuantity = quantityOf(cake);

    if (currentQuantity <= 1) {
      removeFromCart(cake);
      return;
    }

    _quantities[cake.id] = currentQuantity - 1;

    notifyListeners();
  }

  double get subtotal {
    double total = 0;

    for (final cake in _items) {
      total += cake.price * quantityOf(cake);
    }

    return total;
  }

  double get deliveryFee {
    if (_items.isEmpty) {
      return 0;
    }

    return 200;
  }

  double get total {
    return subtotal + deliveryFee;
  }
}
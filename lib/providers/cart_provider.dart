import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/cake_model.dart';
import '../models/brownie_model.dart';

class CartProvider extends ChangeNotifier {
  CartProvider() {
    _initializeCart();
  }

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  // ==========================================================
  // LOCAL CART DATA
  // ==========================================================

  final List<CakeModel> _items = [];
  final Map<String, int> _quantities = {};

  final List<BrownieModel> _brownieItems = [];
  final Map<int, int> _brownieQuantities = {};

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // ==========================================================
  // CURRENT USER
  // ==========================================================

  User? get _currentUser => _auth.currentUser;

  String? get _uid => _currentUser?.uid;

  // ==========================================================
  // FIRESTORE CART REFERENCE
  // ==========================================================

  CollectionReference<Map<String, dynamic>>? get _cartReference {
    final uid = _uid;

    if (uid == null) {
      return null;
    }

    return _firestore
        .collection('users')
        .doc(uid)
        .collection('cart');
  }

  // ==========================================================
  // CAKES
  // ==========================================================

  List<CakeModel> get items =>
      List.unmodifiable(_items);

  int get itemCount =>
      _items.length + _brownieItems.length;

  bool get isEmpty =>
      _items.isEmpty &&
      _brownieItems.isEmpty;

  bool contains(CakeModel cake) {
    return _items.any(
      (item) => item.id == cake.id,
    );
  }

  // ==========================================================
  // ADD CAKE
  // ==========================================================

  Future<void> addToCart(CakeModel cake) async {
    if (_uid == null) {
      return;
    }

    if (contains(cake)) {
      await increaseQuantity(cake);
      return;
    }

    _items.add(cake);
    _quantities[cake.id] = 1;

    notifyListeners();

    await _saveCakeToFirebase(
      cake,
      quantity: 1,
    );
  }

  // ==========================================================
  // REMOVE CAKE
  // ==========================================================

  Future<void> removeFromCart(CakeModel cake) async {
    _items.removeWhere(
      (item) => item.id == cake.id,
    );

    _quantities.remove(cake.id);

    notifyListeners();

    final cart = _cartReference;

    if (cart == null) {
      return;
    }

    await cart
        .doc('cake_${cake.id}')
        .delete();
  }

  // ==========================================================
  // CAKE QUANTITY
  // ==========================================================

  int quantityOf(CakeModel cake) {
    return _quantities[cake.id] ?? 1;
  }

  // ==========================================================
  // INCREASE CAKE QUANTITY
  // ==========================================================

  Future<void> increaseQuantity(
    CakeModel cake,
  ) async {
    if (!contains(cake)) {
      return;
    }

    final quantity = quantityOf(cake) + 1;

    _quantities[cake.id] = quantity;

    notifyListeners();

    await _updateCakeQuantity(
      cake,
      quantity,
    );
  }

  // ==========================================================
  // DECREASE CAKE QUANTITY
  // ==========================================================

  Future<void> decreaseQuantity(
    CakeModel cake,
  ) async {
    if (!contains(cake)) {
      return;
    }

    final quantity = quantityOf(cake);

    if (quantity <= 1) {
      await removeFromCart(cake);
      return;
    }

    final newQuantity = quantity - 1;

    _quantities[cake.id] = newQuantity;

    notifyListeners();

    await _updateCakeQuantity(
      cake,
      newQuantity,
    );
  }

  // ==========================================================
  // SAVE CAKE TO FIREBASE
  // ==========================================================

  Future<void> _saveCakeToFirebase(
    CakeModel cake, {
    required int quantity,
  }) async {
    final cart = _cartReference;

    if (cart == null) {
      return;
    }

    await cart
        .doc('cake_${cake.id}')
        .set({
      'type': 'cake',
      'productId': cake.id,
      'name': cake.name,
      'category': cake.category,
      'image': cake.image,
      'price': cake.price,
      'rating': cake.rating,
      'reviews': cake.reviews,
      'description': cake.description,
      'quantity': quantity,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ==========================================================
  // UPDATE CAKE QUANTITY
  // ==========================================================

  Future<void> _updateCakeQuantity(
    CakeModel cake,
    int quantity,
  ) async {
    final cart = _cartReference;

    if (cart == null) {
      return;
    }

    await cart
        .doc('cake_${cake.id}')
        .update({
      'quantity': quantity,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ==========================================================
  // BROWNIES
  // ==========================================================

  List<BrownieModel> get brownieItems =>
      List.unmodifiable(_brownieItems);

  bool containsBrownie(
    BrownieModel brownie,
  ) {
    return _brownieItems.any(
      (item) => item.id == brownie.id,
    );
  }

  // ==========================================================
  // ADD BROWNIE
  // ==========================================================

  Future<void> addBrownieToCart(
    BrownieModel brownie,
  ) async {
    if (_uid == null) {
      return;
    }

    if (containsBrownie(brownie)) {
      await increaseBrownieQuantity(brownie);
      return;
    }

    _brownieItems.add(brownie);
    _brownieQuantities[brownie.id] = 1;

    notifyListeners();

    await _saveBrownieToFirebase(
      brownie,
      quantity: 1,
    );
  }

  // ==========================================================
  // REMOVE BROWNIE
  // ==========================================================

  Future<void> removeBrownieFromCart(
    BrownieModel brownie,
  ) async {
    _brownieItems.removeWhere(
      (item) => item.id == brownie.id,
    );

    _brownieQuantities.remove(
      brownie.id,
    );

    notifyListeners();

    final cart = _cartReference;

    if (cart == null) {
      return;
    }

    await cart
        .doc('brownie_${brownie.id}')
        .delete();
  }

  // ==========================================================
  // BROWNIE QUANTITY
  // ==========================================================

  int brownieQuantityOf(
    BrownieModel brownie,
  ) {
    return _brownieQuantities[
            brownie.id] ??
        1;
  }

  // ==========================================================
  // INCREASE BROWNIE
  // ==========================================================

  Future<void> increaseBrownieQuantity(
    BrownieModel brownie,
  ) async {
    if (!containsBrownie(brownie)) {
      return;
    }

    final quantity =
        brownieQuantityOf(brownie) + 1;

    _brownieQuantities[brownie.id] =
        quantity;

    notifyListeners();

    await _updateBrownieQuantity(
      brownie,
      quantity,
    );
  }

  // ==========================================================
  // DECREASE BROWNIE
  // ==========================================================

  Future<void> decreaseBrownieQuantity(
    BrownieModel brownie,
  ) async {
    if (!containsBrownie(brownie)) {
      return;
    }

    final quantity =
        brownieQuantityOf(brownie);

    if (quantity <= 1) {
      await removeBrownieFromCart(
        brownie,
      );
      return;
    }

    final newQuantity = quantity - 1;

    _brownieQuantities[brownie.id] =
        newQuantity;

    notifyListeners();

    await _updateBrownieQuantity(
      brownie,
      newQuantity,
    );
  }

  // ==========================================================
  // SAVE BROWNIE TO FIREBASE
  // ==========================================================

  Future<void> _saveBrownieToFirebase(
    BrownieModel brownie, {
    required int quantity,
  }) async {
    final cart = _cartReference;

    if (cart == null) {
      return;
    }

    await cart
        .doc('brownie_${brownie.id}')
        .set({
      'type': 'brownie',
      'productId': brownie.id,
      'name': brownie.name,
      'category': brownie.category,
      'image': brownie.image,
      'price': brownie.price,
      'rating': brownie.rating,
      'description': brownie.description,
      'quantity': quantity,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ==========================================================
  // UPDATE BROWNIE QUANTITY
  // ==========================================================

  Future<void> _updateBrownieQuantity(
    BrownieModel brownie,
    int quantity,
  ) async {
    final cart = _cartReference;

    if (cart == null) {
      return;
    }

    await cart
        .doc('brownie_${brownie.id}')
        .update({
      'quantity': quantity,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ==========================================================
  // LOAD CART
  // ==========================================================

  Future<void> _initializeCart() async {
    final user = _currentUser;

    if (user == null) {
      return;
    }

    await loadCart();
  }

  Future<void> loadCart() async {
    final cart = _cartReference;

    if (cart == null) {
      return;
    }

    try {
      _isLoading = true;
      notifyListeners();

      final snapshot = await cart.get();

      _items.clear();
      _quantities.clear();

      _brownieItems.clear();
      _brownieQuantities.clear();

      for (final document in snapshot.docs) {
        final data = document.data();

        final type = data['type'];

        if (type == 'cake') {
          final cake = CakeModel(
            id: data['productId'] as String,
            name: data['name'] as String? ?? '',
            category:
                data['category'] as String? ?? '',
            image:
                data['image'] as String? ?? '',
            price: _toDouble(data['price']),
            rating: _toDouble(data['rating']),
            reviews:
                _toInt(data['reviews']),
            description:
                data['description'] as String? ?? '',
          );

          final quantity =
              _toInt(data['quantity']);

          _items.add(cake);
          _quantities[cake.id] =
              quantity < 1 ? 1 : quantity;
        }

        if (type == 'brownie') {
          final brownie = BrownieModel(
            id: _toInt(data['productId']),
            name: data['name'] as String? ?? '',
            description:
                data['description'] as String? ?? '',
            price: _toDouble(data['price']),
            image:
                data['image'] as String? ?? '',
            category:
                data['category'] as String? ?? '',
            rating:
                _toDouble(data['rating']),
          );

          final quantity =
              _toInt(data['quantity']);

          _brownieItems.add(brownie);
          _brownieQuantities[brownie.id] =
              quantity < 1 ? 1 : quantity;
        }
      }
    } catch (e) {
      debugPrint(
        'Cart loading error: $e',
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ==========================================================
  // AUTH USER CHANGED
  // ==========================================================

  Future<void> refreshForUser() async {
    _items.clear();
    _quantities.clear();

    _brownieItems.clear();
    _brownieQuantities.clear();

    notifyListeners();

    await loadCart();
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

  Future<void> clearCart() async {
    _items.clear();
    _quantities.clear();

    _brownieItems.clear();
    _brownieQuantities.clear();

    notifyListeners();

    final cart = _cartReference;

    if (cart == null) {
      return;
    }

    try {
      final snapshot = await cart.get();

      final batch = _firestore.batch();

      for (final document in snapshot.docs) {
        batch.delete(document.reference);
      }

      await batch.commit();
    } catch (e) {
      debugPrint(
        'Clear cart error: $e',
      );
    }
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

  // ==========================================================
  // HELPERS
  // ==========================================================

  double _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }

  int _toInt(dynamic value) {
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
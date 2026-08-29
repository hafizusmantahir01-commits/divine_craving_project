 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../providers/cart_provider.dart';
import '../home/home_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();

  String selectedPayment = 'Cash on Delivery';

  bool _isPlacingOrder = false;

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    cityController.dispose();
    super.dispose();
  }

  // =========================================================
  // GO TO HOME
  // =========================================================

  void _goToHome() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => HomeScreen(
          onNavigation: (index) {},
        ),
      ),
      (route) => false,
    );
  }

  // =========================================================
  // CURRENT LOCATION
  // =========================================================

  void _useCurrentLocation() {
    setState(() {
      addressController.text = 'Current location selected';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Location selected. You can edit the address below.',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // =========================================================
  // CREATE ORDER ITEMS
  // =========================================================

  List<Map<String, dynamic>> _createOrderItems(
    CartProvider cart,
  ) {
    final List<Map<String, dynamic>> orderItems = [];

    // =======================================================
    // CAKES
    // =======================================================

    for (final cake in cart.items) {
      final quantity = cart.quantityOf(cake);

      orderItems.add({
        'id': cake.id,
        'name': cake.name,
        'image': cake.image,
        'category': cake.category,
        'type': 'cake',
        'price': cake.price,
        'quantity': quantity,
        'totalPrice': cake.price * quantity,
      });
    }

    // =======================================================
    // BROWNIES
    // =======================================================

    for (final brownie in cart.brownieItems) {
      final quantity = cart.brownieQuantityOf(brownie);

      orderItems.add({
        'id': brownie.id.toString(),
        'name': brownie.name,
        'image': brownie.image,
        'category': brownie.category,
        'type': 'brownie',
        'price': brownie.price,
        'quantity': quantity,
        'totalPrice': brownie.price * quantity,
      });
    }

    return orderItems;
  }

  // =========================================================
  // PLACE ORDER
  // =========================================================

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final cart = context.read<CartProvider>();

    if (cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your cart is empty.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _isPlacingOrder = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;

      final orderItems = _createOrderItems(cart);

      final orderData = {
        'userId': user?.uid,
        'userEmail': user?.email,
        'customerName': nameController.text.trim(),
        'phone': phoneController.text.trim(),
        'address': addressController.text.trim(),
        'city': cityController.text.trim(),
        'paymentMethod': selectedPayment,
        'items': orderItems,
        'subtotal': cart.subtotal,
        'deliveryFee': cart.deliveryFee,
        'total': cart.total,
        'status': 'Pending',
        'createdAt': FieldValue.serverTimestamp(),
      };

      final orderReference = await FirebaseFirestore.instance
          .collection('orders')
          .add(orderData);

      // Clear cart after successful Firebase order
      cart.clearCart();

      if (!mounted) return;

      _showOrderSuccessDialog(
        orderId: orderReference.id,
      );
    } on FirebaseException catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.message ?? 'Failed to place order.',
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.redAccent,
        ),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Something went wrong: $error',
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isPlacingOrder = false;
        });
      }
    }
  }

  // =========================================================
  // ORDER SUCCESS DIALOG
  // =========================================================

  void _showOrderSuccessDialog({
    required String orderId,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final theme = Theme.of(dialogContext);

        return AlertDialog(
          backgroundColor: theme.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: Row(
            children: [
              const Icon(
                Icons.check_circle_rounded,
                color: Colors.green,
                size: 34,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Order Placed',
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            'Your order has been placed successfully.\n\n'
            'Order ID:\n$orderId\n\n'
            'We will contact you on your provided phone number for confirmation.',
            style: TextStyle(
              color: theme.textTheme.bodyMedium?.color,
              height: 1.5,
            ),
          ),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _goToHome();
              },
              child: const Text(
                'Done',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // =========================================================
  // INPUT FIELD
  // =========================================================

  Widget _inputField({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    final theme = Theme.of(context);

    final isDark =
        theme.brightness == Brightness.dark;

    final accentColor =
        isDark
            ? const Color(0xFFFFBFA3)
            : AppColors.brown;

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 16,
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: TextStyle(
          color: theme.colorScheme.onSurface,
        ),
        validator: (value) {
          if (value == null ||
              value.trim().isEmpty) {
            return '$label is required';
          }

          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(
            icon,
            color: accentColor,
          ),
          filled: true,
          fillColor:
              isDark
                  ? const Color(0xFF261D19)
                  : Colors.grey.shade50,
          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(14),
          ),
          enabledBorder:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(14),
            borderSide: BorderSide(
              color:
                  isDark
                      ? Colors.white10
                      : Colors.black12,
            ),
          ),
          focusedBorder:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(14),
            borderSide: BorderSide(
              color: accentColor,
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isDark =
        theme.brightness == Brightness.dark;

    final cart =
        context.watch<CartProvider>();

    return PopScope(
      canPop: !_isPlacingOrder,
      child: Scaffold(
        backgroundColor:
            theme.scaffoldBackgroundColor,

        appBar: AppBar(
          title: const Text(
            'Checkout',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        body: LayoutBuilder(
          builder: (
            context,
            constraints,
          ) {
            final isDesktop =
                constraints.maxWidth >= 850;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal:
                    isDesktop ? 50 : 18,
                vertical: 20,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints:
                      const BoxConstraints(
                    maxWidth: 1100,
                  ),
                  child: Form(
                    key: _formKey,
                    child: isDesktop
                        ? Row(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 6,
                                child:
                                    _customerDetails(
                                  isDark,
                                ),
                              ),
                              const SizedBox(
                                width: 25,
                              ),
                              SizedBox(
                                width: 350,
                                child:
                                    _orderSummary(
                                  cart,
                                  isDark,
                                ),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              _customerDetails(
                                isDark,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              _orderSummary(
                                cart,
                                isDark,
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // =========================================================
  // CUSTOMER DETAILS
  // =========================================================

  Widget _customerDetails(
    bool isDark,
  ) {
    final theme = Theme.of(context);

    final accentColor =
        isDark
            ? const Color(0xFFFFBFA3)
            : AppColors.brown;

    return Container(
      padding:
          const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color:
            isDark
                ? const Color(0xFF1E1613)
                : Colors.white,
        borderRadius:
            BorderRadius.circular(22),
        border: Border.all(
          color:
              isDark
                  ? Colors.white10
                  : AppColors.peach,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            'Delivery Details',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color:
                  theme.colorScheme.onSurface,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            'Enter your information for cake delivery.',
            style: TextStyle(
              color: theme
                  .textTheme
                  .bodyMedium
                  ?.color
                  ?.withOpacity(0.6),
            ),
          ),

          const SizedBox(height: 22),

          _inputField(
            label: 'Full Name',
            hint: 'Enter your full name',
            icon: Icons.person_outline,
            controller: nameController,
          ),

          _inputField(
            label: 'Phone Number',
            hint: '03XX XXXXXXX',
            icon: Icons.phone_outlined,
            controller: phoneController,
            keyboardType:
                TextInputType.phone,
          ),

          Row(
            children: [
              Expanded(
                child: Text(
                  'Delivery Location',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                        FontWeight.bold,
                    color: theme
                        .colorScheme
                        .onSurface,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed:
                    _useCurrentLocation,
                icon: Icon(
                  Icons.my_location,
                  size: 18,
                  color: accentColor,
                ),
                label: Text(
                  'Use Current Location',
                  style: TextStyle(
                    color: accentColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          _inputField(
            label: 'Address',
            hint:
                'House no, street, area, landmark',
            icon:
                Icons.location_on_outlined,
            controller:
                addressController,
            maxLines: 3,
          ),

          _inputField(
            label: 'City',
            hint: 'Enter your city',
            icon:
                Icons.location_city_outlined,
            controller: cityController,
          ),

          const SizedBox(height: 5),

          Text(
            'Payment Method',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color:
                  theme.colorScheme.onSurface,
            ),
          ),

          const SizedBox(height: 10),

          Container(
            decoration: BoxDecoration(
              color:
                  isDark
                      ? const Color(
                          0xFF261D19,
                        )
                      : Colors.grey.shade50,
              borderRadius:
                  BorderRadius.circular(14),
              border: Border.all(
                color:
                    isDark
                        ? Colors.white10
                        : Colors.black12,
              ),
            ),
            child:
                RadioListTile<String>(
              value:
                  'Cash on Delivery',
              groupValue:
                  selectedPayment,
              activeColor:
                  accentColor,
              title: Text(
                'Cash on Delivery',
                style: TextStyle(
                  color: theme
                      .colorScheme
                      .onSurface,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),
              secondary: Icon(
                Icons.payments_outlined,
                color: accentColor,
              ),
              onChanged: (value) {
                if (value == null) {
                  return;
                }

                setState(() {
                  selectedPayment =
                      value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // ORDER SUMMARY
  // =========================================================

  Widget _orderSummary(
    CartProvider cart,
    bool isDark,
  ) {
    final theme = Theme.of(context);

    final accentColor =
        isDark
            ? const Color(0xFFFFBFA3)
            : AppColors.brown;

    return Container(
      padding:
          const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color:
            isDark
                ? const Color(0xFF261D19)
                : const Color(0xFFFFFBF7),
        borderRadius:
            BorderRadius.circular(22),
        border: Border.all(
          color:
              isDark
                  ? Colors.white10
                  : AppColors.peach,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color:
                  theme.colorScheme.onSurface,
            ),
          ),

          const SizedBox(height: 18),

          _summaryRow(
            'Items',
            '${cart.totalItemCount}',
          ),

          const SizedBox(height: 12),

          _summaryRow(
            'Subtotal',
            'Rs ${cart.subtotal.toInt()}',
          ),

          const SizedBox(height: 12),

          _summaryRow(
            'Delivery Fee',
            'Rs ${cart.deliveryFee.toInt()}',
          ),

          Padding(
            padding:
                const EdgeInsets.symmetric(
              vertical: 15,
            ),
            child: Divider(
              color:
                  isDark
                      ? Colors.white12
                      : Colors.black12,
            ),
          ),

          _summaryRow(
            'Total',
            'Rs ${cart.total.toInt()}',
            bold: true,
            accentColor:
                accentColor,
          ),

          const SizedBox(height: 22),

          SizedBox(
            width: double.infinity,
            height: 54,
            child:
                FilledButton.icon(
              onPressed:
                  _isPlacingOrder
                      ? null
                      : _placeOrder,
              icon:
                  _isPlacingOrder
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                            color:
                                Colors.white,
                          ),
                        )
                      : const Icon(
                          Icons
                              .check_circle_outline,
                        ),
              label: Text(
                _isPlacingOrder
                    ? 'Placing Order...'
                    : 'Place Order',
                style: const TextStyle(
                  fontWeight:
                      FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // SUMMARY ROW
  // =========================================================

  Widget _summaryRow(
    String title,
    String value, {
    bool bold = false,
    Color? accentColor,
  }) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize:
                  bold ? 16 : 14,
              fontWeight:
                  bold
                      ? FontWeight.bold
                      : null,
              color:
                  theme.colorScheme.onSurface,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize:
                bold ? 19 : 14,
            fontWeight:
                FontWeight.bold,
            color:
                bold
                    ? (accentColor ??
                        theme
                            .colorScheme
                            .onSurface)
                    : theme
                        .colorScheme
                        .onSurface,
          ),
        ),
      ],
    );
  }
}
 

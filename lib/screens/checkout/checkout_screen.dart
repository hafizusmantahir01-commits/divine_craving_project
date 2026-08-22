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
          onNavigation: (index) {
            // Home screen ki navigation yahan handle hogi.
            // Checkout se directly Home par aane ke case mein
            // default Home tab hi open rahega.
          },
        ),
      ),
      (route) => false,
    );
  }

  // =========================================================
  // GET CURRENT LOCATION
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
  // PLACE ORDER
  // =========================================================

  void _placeOrder() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final cart = context.read<CartProvider>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final theme = Theme.of(dialogContext);
        final isDark = theme.brightness == Brightness.dark;

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
                size: 32,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Order Placed',
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            'Your order of Rs ${cart.total.toInt()} has been placed successfully.\n\n'
            'We will contact you on your provided phone number for confirmation.',
            style: TextStyle(
              color: theme.textTheme.bodyMedium?.color,
              height: 1.5,
            ),
          ),
          actions: [
            FilledButton(
              onPressed: () {
                // Dialog close
                Navigator.of(dialogContext).pop();

                // Checkout close karke Home par
                _goToHome();
              },
              child: const Text(
                'Done',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
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
    final isDark = theme.brightness == Brightness.dark;

    final Color accentColor =
        isDark ? const Color(0xFFFFBFA3) : AppColors.brown;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: TextStyle(
          color: theme.colorScheme.onSurface,
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return '$label is required';
          }

          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: TextStyle(
            color: isDark ? Colors.white70 : Colors.black54,
          ),
          hintStyle: TextStyle(
            color: isDark ? Colors.white38 : Colors.black38,
          ),
          prefixIcon: Icon(
            icon,
            color: accentColor,
          ),
          filled: true,
          fillColor: isDark ? const Color(0xFF261D19) : Colors.grey.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: isDark ? Colors.white10 : Colors.black12,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: accentColor,
              width: 1.5,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Colors.redAccent,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Colors.redAccent,
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
    final isDark = theme.brightness == Brightness.dark;

    final cart = context.watch<CartProvider>();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }

        _goToHome();
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,

        // ===================================================
        // APP BAR
        // ===================================================

        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: _goToHome,
            tooltip: 'Back to Home',
            icon: const Icon(
              Icons.arrow_back_rounded,
            ),
          ),
          title: const Text(
            'Checkout',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // ===================================================
        // BODY
        // ===================================================

        body: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 850;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 50 : 18,
                vertical: 20,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 1100,
                  ),
                  child: Form(
                    key: _formKey,
                    child: isDesktop
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 6,
                                child: _customerDetails(
                                  isDark,
                                ),
                              ),
                              const SizedBox(width: 25),
                              SizedBox(
                                width: 350,
                                child: _orderSummary(
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
                              const SizedBox(height: 20),
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

  Widget _customerDetails(bool isDark) {
    final theme = Theme.of(context);

    final Color accentColor =
        isDark ? const Color(0xFFFFBFA3) : AppColors.brown;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1613) : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? Colors.white10 : AppColors.peach,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =================================================
          // TITLE
          // =================================================

          Text(
            'Delivery Details',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            'Enter your information for cake delivery.',
            style: TextStyle(
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
            ),
          ),

          const SizedBox(height: 22),

          // =================================================
          // NAME
          // =================================================

          _inputField(
            label: 'Full Name',
            hint: 'Enter your full name',
            icon: Icons.person_outline,
            controller: nameController,
          ),

          // =================================================
          // PHONE
          // =================================================

          _inputField(
            label: 'Phone Number',
            hint: '03XX XXXXXXX',
            icon: Icons.phone_outlined,
            controller: phoneController,
            keyboardType: TextInputType.phone,
          ),

          // =================================================
          // LOCATION TITLE
          // =================================================

          Row(
            children: [
              Expanded(
                child: Text(
                  'Delivery Location',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: _useCurrentLocation,
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

          // =================================================
          // ADDRESS
          // =================================================

          _inputField(
            label: 'Address',
            hint: 'House no, street, area, landmark',
            icon: Icons.location_on_outlined,
            controller: addressController,
            maxLines: 3,
          ),

          // =================================================
          // CITY
          // =================================================

          _inputField(
            label: 'City',
            hint: 'Enter your city',
            icon: Icons.location_city_outlined,
            controller: cityController,
          ),

          const SizedBox(height: 5),

          // =================================================
          // PAYMENT
          // =================================================

          Text(
            'Payment Method',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),

          const SizedBox(height: 10),

          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF261D19) : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark ? Colors.white10 : Colors.black12,
              ),
            ),
            child: RadioListTile<String>(
              value: 'Cash on Delivery',
              groupValue: selectedPayment,
              activeColor: accentColor,
              title: Text(
                'Cash on Delivery',
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              secondary: Icon(
                Icons.payments_outlined,
                color: accentColor,
              ),
              onChanged: (value) {
                if (value == null) return;

                setState(() {
                  selectedPayment = value;
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

    final Color accentColor =
        isDark ? const Color(0xFFFFBFA3) : AppColors.brown;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF261D19) : const Color(0xFFFFFBF7),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? Colors.white10 : AppColors.peach,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),

          const SizedBox(height: 18),

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
            padding: const EdgeInsets.symmetric(
              vertical: 15,
            ),
            child: Divider(
              color: isDark ? Colors.white12 : Colors.black12,
            ),
          ),

          _summaryRow(
            'Total',
            'Rs ${cart.total.toInt()}',
            bold: true,
            accentColor: accentColor,
          ),

          const SizedBox(height: 22),

          // =================================================
          // PLACE ORDER
          // =================================================

          SizedBox(
            width: double.infinity,
            height: 54,
            child: FilledButton.icon(
              onPressed: _placeOrder,
              icon: const Icon(
                Icons.check_circle_outline,
              ),
              label: const Text(
                'Place Order',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
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
              fontSize: bold ? 16 : 14,
              fontWeight: bold ? FontWeight.bold : null,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: bold ? 19 : 14,
            fontWeight: FontWeight.bold,
            color: bold
                ? (accentColor ?? theme.colorScheme.onSurface)
                : theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}

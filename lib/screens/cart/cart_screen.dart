import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../models/cake_model.dart';
import '../../providers/cart_provider.dart';
import '../checkout/checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        if (cart.items.isEmpty) {
          return const _EmptyCart();
        }

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            title: const Text(
              'My Cart',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth >= 900) {
                return _DesktopCart(cart: cart);
              }

              return _MobileCart(cart: cart);
            },
          ),
        );
      },
    );
  }
}

// ============================================================
// MOBILE CART
// ============================================================

class _MobileCart extends StatelessWidget {
  final CartProvider cart;

  const _MobileCart({
    required this.cart,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 30),
        children: [
          _CartHeader(itemCount: cart.itemCount),

          const SizedBox(height: 20),

          ...cart.items.map(
            (cake) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _CartItem(
                cake: cake,
                cart: cart,
              ),
            ),
          ),

          const SizedBox(height: 8),

          _OrderSummary(cart: cart),

          const SizedBox(height: 16),

          _CheckoutButtons(cart: cart),
        ],
      ),
    );
  }
}

// ============================================================
// DESKTOP CART
// ============================================================

class _DesktopCart extends StatelessWidget {
  final CartProvider cart;

  const _DesktopCart({
    required this.cart,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 1250,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            28,
            24,
            28,
            35,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _CartHeader(
                      itemCount: cart.itemCount,
                    ),

                    const SizedBox(height: 20),

                    ...cart.items.map(
                      (cake) => Padding(
                        padding: const EdgeInsets.only(
                          bottom: 15,
                        ),
                        child: _CartItem(
                          cake: cake,
                          cart: cart,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 28),

              SizedBox(
                width: 370,
                child: Column(
                  children: [
                    _OrderSummary(cart: cart),

                    const SizedBox(height: 16),

                    _CheckoutButtons(cart: cart),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// CART HEADER
// ============================================================

class _CartHeader extends StatelessWidget {
  final int itemCount;

  const _CartHeader({
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primaryText = theme.colorScheme.onSurface;

    final secondaryText =
        theme.textTheme.bodyMedium?.color ??
        (isDark ? Colors.white70 : Colors.black54);

    final accentColor = isDark
        ? const Color(0xFFFFBFA3)
        : AppColors.brown;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Cart',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: primaryText,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                'Your delicious picks are waiting for you.',
                style: TextStyle(
                  fontSize: 13,
                  color: secondaryText.withOpacity(0.70),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 10),

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 13,
            vertical: 9,
          ),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.peach.withOpacity(0.15)
                : AppColors.peach.withOpacity(0.25),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: isDark
                  ? const Color(0xFFFFBFA3).withOpacity(0.55)
                  : AppColors.peach.withOpacity(0.65),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.shopping_bag_outlined,
                size: 17,
                color: accentColor,
              ),

              const SizedBox(width: 7),

              Text(
                '$itemCount ${itemCount == 1 ? 'Item' : 'Items'}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: accentColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ============================================================
// CART ITEM
// ============================================================

// ============================================================
// CART ITEM
// ============================================================

class _CartItem extends StatelessWidget {
  final CakeModel cake;
  final CartProvider cart;

  const _CartItem({
    required this.cake,
    required this.cart,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primaryText = isDark ? Colors.white : theme.colorScheme.onSurface;
    
    // Better contrast for secondary text in dark mode
    final secondaryText = isDark ? Colors.white70 : Colors.black54;

    final accentColor = isDark
        ? const Color(0xFFFFBFA3)
        : AppColors.brown;

    final quantity = cart.quantityOf(cake);
    final itemTotal = cake.price * quantity;

    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF241B18)
            : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.12)
              : AppColors.peach.withOpacity(0.35),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              isDark ? 0.25 : 0.055,
            ),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CakeImage(
            imageUrl: cake.image,
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        cake.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.25,
                          fontWeight: FontWeight.w900,
                          color: primaryText,
                        ),
                      ),
                    ),

                    IconButton(
                      onPressed: () {
                        cart.removeFromCart(cake);
                      },
                      tooltip: 'Remove from cart',
                      icon: Icon(
                        Icons.delete_outline_rounded,
                        color: isDark
                            ? Colors.white60
                            : Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                Row(
                  children: [
                    Icon(
                      Icons.local_fire_department_outlined,
                      size: 14,
                      color: accentColor,
                    ),

                    const SizedBox(width: 4),

                    Text(
                      'Freshly baked',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: accentColor.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Text(
                      'Price',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: secondaryText,
                      ),
                    ),

                    const SizedBox(width: 6),

                    Text(
                      'Rs ${cake.price.toInt()}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: accentColor,
                      ),
                    ),

                    const Spacer(),

                    Text(
                      'Rs ${itemTotal.toInt()}',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        color: primaryText,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Text(
                      'Quantity',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: secondaryText,
                      ),
                    ),

                    const SizedBox(width: 10),

                    _QuantityControl(
                      quantity: quantity,
                      onDecrease: () {
                        cart.decreaseQuantity(cake);
                      },
                      onIncrease: () {
                        cart.increaseQuantity(cake);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// CAKE IMAGE
// ============================================================

class _CakeImage extends StatelessWidget {
  final String imageUrl;

  const _CakeImage({
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: 105,
      height: 118,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,

          loadingBuilder: (
            context,
            child,
            progress,
          ) {
            if (progress == null) {
              return child;
            }

            return Container(
              color: isDark
                  ? const Color(0xFF332520)
                  : AppColors.cream,
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: isDark
                      ? const Color(0xFFFFBFA3)
                      : AppColors.brown,
                ),
              ),
            );
          },

          errorBuilder: (
            context,
            error,
            stackTrace,
          ) {
            return Container(
              color: isDark
                  ? const Color(0xFF332520)
                  : AppColors.cream,
              child: Icon(
                Icons.cake_outlined,
                color: isDark
                    ? const Color(0xFFFFBFA3)
                    : AppColors.brown,
                size: 40,
              ),
            );
          },
        ),
      ),
    );
  }
}

// ============================================================
// QUANTITY CONTROL
// ============================================================

class _QuantityControl extends StatelessWidget {
  final int quantity;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  const _QuantityControl({
    required this.quantity,
    required this.onDecrease,
    required this.onIncrease,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final accentColor = isDark
        ? const Color(0xFFFFBFA3)
        : AppColors.brown;

    return Container(
      height: 40,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.06)
            : AppColors.peach.withOpacity(0.20),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.10)
              : AppColors.peach.withOpacity(0.60),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _QuantityButton(
            icon: Icons.remove_rounded,
            onTap: onDecrease,
          ),

          SizedBox(
            width: 34,
            child: Center(
              child: Text(
                '$quantity',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
          ),

          _QuantityButton(
            icon: Icons.add_rounded,
            onTap: onIncrease,
          ),
        ],
      ),
    );
  }
}

// ============================================================
// QUANTITY BUTTON
// ============================================================

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QuantityButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final buttonColor = isDark
        ? const Color(0xFF5A4033)
        : AppColors.peach.withOpacity(0.65);

    final iconColor = isDark
        ? const Color(0xFFFFD5C2)
        : AppColors.brown;

    return Material(
      color: buttonColor,
      borderRadius: BorderRadius.circular(9),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9),
        child: SizedBox(
          width: 31,
          height: 31,
          child: Icon(
            icon,
            size: 16,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}

// ============================================================
// ORDER SUMMARY
// ============================================================

class _OrderSummary extends StatelessWidget {
  final CartProvider cart;

  const _OrderSummary({
    required this.cart,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final accentColor = isDark
        ? const Color(0xFFFFBFA3)
        : AppColors.brown;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF241B18)
            : const Color(0xFFFFFCF9),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.08)
              : AppColors.peach.withOpacity(0.55),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: theme.colorScheme.onSurface,
            ),
          ),

          const SizedBox(height: 24),

          _SummaryRow(
            title: 'Subtotal',
            value: 'Rs ${cart.subtotal.toInt()}',
          ),

          const SizedBox(height: 14),

          _SummaryRow(
            title: 'Delivery Fee',
            value: 'Rs ${cart.deliveryFee.toInt()}',
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 18,
            ),
            child: Divider(
              color: isDark
                  ? Colors.white.withOpacity(0.10)
                  : Colors.black.withOpacity(0.07),
            ),
          ),

          _SummaryRow(
            title: 'Total',
            value: 'Rs ${cart.total.toInt()}',
            bold: true,
            accentColor: accentColor,
          ),
        ],
      ),
    );
  }
}

// ============================================================
// SUMMARY ROW
// ============================================================

class _SummaryRow extends StatelessWidget {
  final String title;
  final String value;
  final bool bold;
  final Color? accentColor;

  const _SummaryRow({
    required this.title,
    required this.value,
    this.bold = false,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final textColor =
        theme.colorScheme.onSurface;

    final secondaryColor =
        theme.textTheme.bodyMedium?.color ??
        (theme.brightness == Brightness.dark
            ? Colors.white70
            : Colors.black54);

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: bold ? 16 : 14,
              fontWeight: bold
                  ? FontWeight.w800
                  : FontWeight.w500,
              color: bold
                  ? textColor
                  : secondaryColor.withOpacity(0.75),
            ),
          ),
        ),

        Text(
          value,
          style: TextStyle(
            fontSize: bold ? 20 : 14,
            fontWeight: bold
                ? FontWeight.w900
                : FontWeight.w700,
            color: bold
                ? (accentColor ?? textColor)
                : textColor,
          ),
        ),
      ],
    );
  }
}

// ============================================================
// CHECKOUT BUTTONS
// ============================================================

class _CheckoutButtons extends StatelessWidget {
  final CartProvider cart;

  const _CheckoutButtons({
    required this.cart,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final accentColor = isDark
        ? const Color(0xFFFFBFA3)
        : AppColors.brown;

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 55,
          child: FilledButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CheckoutScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.arrow_forward_rounded,
            ),
            label: const Text(
              'Proceed to Checkout',
              style: TextStyle(
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),

        const SizedBox(height: 11),

        SizedBox(
          width: double.infinity,
          height: 51,
          child: OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'WhatsApp ordering will be available here.',
                  ),
                ),
              );
            },
            icon: Icon(
              Icons.chat_bubble_outline_rounded,
              color: accentColor,
            ),
            label: Text(
              'Order via WhatsApp',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: accentColor,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: accentColor,
              side: BorderSide(
                color: accentColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// EMPTY CART
// ============================================================

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final accentColor = isDark
        ? const Color(0xFFFFBFA3)
        : AppColors.brown;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        title: const Text(
          'My Cart',
          style: TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 155,
                height: 155,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.peach.withOpacity(0.10)
                      : AppColors.peach.withOpacity(0.22),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFFFFBFA3)
                            .withOpacity(0.45)
                        : AppColors.peach.withOpacity(0.55),
                  ),
                ),
                child: Icon(
                  Icons.shopping_bag_outlined,
                  size: 62,
                  color: accentColor,
                ),
              ),

              const SizedBox(height: 28),

              Text(
                'Your cart is empty',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                  color: theme.colorScheme.onSurface,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                'Discover our delicious cakes and add your favorites to the cart.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.55,
                  color: theme.textTheme.bodyMedium?.color
                      ?.withOpacity(0.70),
                ),
              ),

              const SizedBox(height: 28),

              FilledButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.cake_outlined,
                ),
                label: const Text(
                  'Explore Cakes',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
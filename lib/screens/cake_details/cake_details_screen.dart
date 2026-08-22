import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/app_colors.dart';
import '../../models/cake_model.dart';
import '../../providers/cart_provider.dart';
import '../cart/cart_screen.dart';

class CakeDetailsScreen extends StatefulWidget {
  final CakeModel cake;

  const CakeDetailsScreen({super.key, required this.cake});

  @override
  State<CakeDetailsScreen> createState() => _CakeDetailsScreenState();
}

class _CakeDetailsScreenState extends State<CakeDetailsScreen> {
  int selectedSize = 2;
  String selectedFlavor = 'Chocolate';

  // ======================================================
  // WHATSAPP
  // ======================================================

  Future<void> openWhatsApp() async {
    const phone = '923001234567';

    final message = Uri.encodeComponent(
      'Assalam o Alaikum!\n\n'
      'I want to order:\n'
      '${widget.cake.name}\n'
      'Size: $selectedSize Pound\n'
      'Flavor: $selectedFlavor\n'
      'Price: Rs ${widget.cake.price.toInt()}',
    );

    final url = Uri.parse('https://wa.me/$phone?text=$message');

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('WhatsApp could not be opened')),
      );
    }
  }

  // ======================================================
  // BUILD
  // ======================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primaryColor = theme.colorScheme.primary;

    final textColor =
        theme.textTheme.bodyLarge?.color ??
        (isDark ? Colors.white : AppColors.brown);

    final secondaryTextColor =
        theme.textTheme.bodyMedium?.color?.withOpacity(0.65) ??
        (isDark ? Colors.white70 : AppColors.grey);

    final backgroundColor = theme.scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: backgroundColor,

      // ==================================================
      // BODY
      // ==================================================
      body: CustomScrollView(
        slivers: [
          // ==================================================
          // CAKE IMAGE / APP BAR
          // ==================================================
          SliverAppBar(
            expandedHeight: 360,
            pinned: true,

            backgroundColor: backgroundColor,

            foregroundColor: isDark ? Colors.white : AppColors.brown,

            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Cake Image
                  Image.network(
                    widget.cake.image,
                    fit: BoxFit.cover,

                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }

                      return Center(
                        child: CircularProgressIndicator(color: primaryColor),
                      );
                    },

                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: isDark
                            ? const Color(0xFF261D19)
                            : AppColors.cream,
                        child: Icon(
                          Icons.cake_outlined,
                          size: 80,
                          color: primaryColor,
                        ),
                      );
                    },
                  ),

                  // Dark Mode Image Overlay
                  if (isDark) Container(color: Colors.black.withOpacity(0.38)),
                ],
              ),
            ),

            // ==================================================
            // TOP ACTIONS
            // ==================================================
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.favorite_border),
              ),

              IconButton(
                onPressed: openWhatsApp,
                icon: const Icon(Icons.chat_outlined),
              ),
            ],
          ),

          // ==================================================
          // CONTENT
          // ==================================================
          SliverPadding(
            padding: const EdgeInsets.all(20),

            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  // ==================================================
                  // NAME + PRICE
                  // ==================================================
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.cake.name,
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Text(
                        'Rs ${widget.cake.price.toInt()}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // ==================================================
                  // RATING
                  // ==================================================
                  Row(
                    children: [
                      const Icon(Icons.star, color: AppColors.gold, size: 21),

                      const SizedBox(width: 5),

                      Text(
                        '${widget.cake.rating}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),

                      const SizedBox(width: 5),

                      Text(
                        '(${widget.cake.reviews} reviews)',
                        style: TextStyle(color: secondaryTextColor),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ==================================================
                  // DESCRIPTION
                  // ==================================================
                  Text(
                    widget.cake.description,
                    style: TextStyle(height: 1.6, color: secondaryTextColor),
                  ),

                  const SizedBox(height: 25),

                  // ==================================================
                  // SIZE
                  // ==================================================
                  Text(
                    'Select Size',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    children: [1, 2, 3].map((size) {
                      final isSelected = selectedSize == size;

                      return ChoiceChip(
                        label: Text('$size Pound'),

                        selected: isSelected,

                        selectedColor: primaryColor,

                        backgroundColor: isDark
                            ? const Color(0xFF30241F)
                            : Colors.white,

                        side: BorderSide(
                          color: isSelected
                              ? primaryColor
                              : (isDark ? Colors.white24 : AppColors.peach),
                        ),

                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : textColor,
                          fontWeight: FontWeight.w500,
                        ),

                        onSelected: (_) {
                          setState(() {
                            selectedSize = size;
                          });
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 25),

                  // ==================================================
                  // FLAVOR
                  // ==================================================
                  Text(
                    'Flavor',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ['Chocolate', 'Vanilla', 'Mocha', 'Red Velvet']
                        .map((flavor) {
                          final isSelected = selectedFlavor == flavor;

                          return ChoiceChip(
                            label: Text(flavor),

                            selected: isSelected,

                            selectedColor: primaryColor,

                            backgroundColor: isDark
                                ? const Color(0xFF30241F)
                                : Colors.white,

                            side: BorderSide(
                              color: isSelected
                                  ? primaryColor
                                  : (isDark ? Colors.white24 : AppColors.peach),
                            ),

                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : textColor,
                              fontWeight: FontWeight.w500,
                            ),

                            onSelected: (_) {
                              setState(() {
                                selectedFlavor = flavor;
                              });
                            },
                          );
                        })
                        .toList(),
                  ),

                  const SizedBox(height: 25),

                  // ==================================================
                  // SPECIAL MESSAGE
                  // ==================================================
                  Text(
                    'Special Message',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    maxLines: 3,

                    style: TextStyle(color: textColor),

                    decoration: InputDecoration(
                      hintText: 'e.g. Happy Birthday Ahmed ❤️',

                      hintStyle: TextStyle(color: secondaryTextColor),

                      filled: true,

                      fillColor: isDark
                          ? const Color(0xFF261D19)
                          : Colors.white,

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // ==================================================
                  // COMMENTS
                  // ==================================================
                  Text(
                    'Comments',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),

                  const SizedBox(height: 15),

                  CommentItem(
                    name: 'Ayesha',
                    text: 'Amazing cake! Taste was really good ❤️',
                  ),

                  CommentItem(
                    name: 'Ali',
                    text: 'Beautiful design and fresh cake.',
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),

      // ==================================================
      // BOTTOM FOOTER
      // ==================================================
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),

        decoration: BoxDecoration(
          color: backgroundColor,

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.35 : 0.08),
              blurRadius: 15,
              offset: const Offset(0, -3),
            ),
          ],
        ),

        child: Row(
          children: [
            // ==================================================
            // WHATSAPP BUTTON
            // ==================================================
            Expanded(
              child: OutlinedButton.icon(
                onPressed: openWhatsApp,

                icon: const Icon(Icons.chat),

                label: const Text('WhatsApp'),

                style: OutlinedButton.styleFrom(
                  foregroundColor: primaryColor,

                  side: BorderSide(color: primaryColor),

                  minimumSize: const Size.fromHeight(52),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 10),

            // ==================================================
            // ADD TO CART
            // ==================================================
            Expanded(
              child: FilledButton(
                onPressed: () {
  final cart = context.read<CartProvider>();

  if (cart.contains(widget.cake)) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('This cake is already in your cart.'),
      ),
    );

    return;
  }

  cart.addToCart(widget.cake);

  ScaffoldMessenger.of(context).hideCurrentSnackBar();

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Cake added to cart successfully'),
    ),
  );

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const CartScreen(),
    ),
  );
},
                style: FilledButton.styleFrom(
                  backgroundColor: primaryColor,

                  foregroundColor: Colors.white,

                  minimumSize: const Size.fromHeight(52),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),

                child: const Text(
                  'Add to Cart',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ======================================================
// COMMENT ITEM
// ======================================================

class CommentItem extends StatelessWidget {
  final String name;
  final String text;

  const CommentItem({super.key, required this.name, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isDark = theme.brightness == Brightness.dark;

    final textColor =
        theme.textTheme.bodyLarge?.color ??
        (isDark ? Colors.white : AppColors.brown);

    final secondaryColor =
        theme.textTheme.bodyMedium?.color ??
        (isDark ? Colors.white70 : AppColors.grey);

    return ListTile(
      contentPadding: EdgeInsets.zero,

      leading: CircleAvatar(
        backgroundColor: isDark ? const Color(0xFF49352B) : AppColors.peach,

        child: Text(
          name[0],

          style: TextStyle(
            color: isDark ? Colors.white : AppColors.brown,

            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      title: Text(
        name,

        style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
      ),

      subtitle: Text(text, style: TextStyle(color: secondaryColor)),
    );
  }
}

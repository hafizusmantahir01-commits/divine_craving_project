import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_colors.dart';
import '../providers/admin_theme_provider.dart';

class AddCakeScreen extends StatefulWidget {
  const AddCakeScreen({super.key});

  @override
  State<AddCakeScreen> createState() => _AddCakeScreenState();
}

class _AddCakeScreenState extends State<AddCakeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();

  final TextEditingController priceController = TextEditingController();

  final TextEditingController ratingController = TextEditingController();

  final TextEditingController descriptionController = TextEditingController();

  final ImagePicker imagePicker = ImagePicker();

  File? selectedImage;

  String selectedCategory = 'Birthday';

  final List<String> categories = [
    'Birthday',
    'Wedding',
    'Chocolate',
    'Red Velvet',
    'Custom',
  ];

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    ratingController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  // ============================================================
  // COLORS
  // ============================================================

  Color backgroundColor(bool isDark) {
    return isDark ? const Color(0xFF101010) : const Color(0xFFF8F4EF);
  }

  Color cardColor(bool isDark) {
    return isDark ? const Color(0xFF1C1C1C) : Colors.white;
  }

  Color fieldColor(bool isDark) {
    return isDark ? const Color(0xFF242424) : Colors.white;
  }

  Color primaryTextColor(bool isDark) {
    return isDark ? Colors.white : AppColors.brown;
  }

  Color secondaryTextColor(bool isDark) {
    return isDark ? Colors.white70 : AppColors.grey;
  }

  Color accentColor(bool isDark) {
    return isDark ? AppColors.gold : AppColors.brown;
  }

  Color borderColor(bool isDark) {
    return isDark ? Colors.white12 : Colors.black12;
  }

  // ============================================================
  // PICK IMAGE
  // ============================================================

  Future<void> pickImage() async {
    try {
      final XFile? image = await imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1200,
        maxHeight: 1200,
      );

      if (image == null) {
        return;
      }

      if (!mounted) return;

      setState(() {
        selectedImage = File(image.path);
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Unable to select image')));
    }
  }

  // ============================================================
  // SAVE CAKE
  // ============================================================

  void saveCake() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a cake image')),
      );

      return;
    }

    final Map<String, String> newCake = {
      'name': nameController.text.trim(),
      'category': selectedCategory,
      'price': 'Rs ${priceController.text.trim()}',
      'rating': ratingController.text.trim(),
      'description': descriptionController.text.trim(),
      'image': selectedImage!.path,
    };

    Navigator.of(context).pop(newCake);
  }

  // ============================================================
  // BACK
  // ============================================================

  void goBack() {
    Navigator.of(context).pop();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminThemeProvider>(
      builder: (context, themeProvider, child) {
        final bool isDark = themeProvider.isDark;

        return Scaffold(
          backgroundColor: backgroundColor(isDark),

          // ======================================================
          // APP BAR
          // ======================================================
          appBar: AppBar(
            automaticallyImplyLeading: false,

            backgroundColor: cardColor(isDark),

            foregroundColor: primaryTextColor(isDark),

            elevation: 0,

            surfaceTintColor: Colors.transparent,

            leading: IconButton(
              onPressed: goBack,

              icon: Icon(
                Icons.arrow_back_rounded,
                color: primaryTextColor(isDark),
              ),
            ),

            title: Text(
              'Add Cake',
              style: TextStyle(
                color: primaryTextColor(isDark),
                fontWeight: FontWeight.bold,
              ),
            ),

            actions: [
              // Dark / Light Mode Button
              IconButton(
                tooltip: isDark ? 'Light Mode' : 'Dark Mode',

                onPressed: () {
                  themeProvider.toggleTheme();
                },

                icon: Icon(
                  isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,

                  color: accentColor(isDark),
                ),
              ),

              const SizedBox(width: 8),
            ],
          ),

          // ======================================================
          // BODY
          // ======================================================
          body: SafeArea(
            child: Form(
              key: _formKey,

              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    // ==================================================
                    // IMAGE
                    // ==================================================
                    Center(
                      child: GestureDetector(
                        onTap: pickImage,

                        child: Container(
                          width: 160,
                          height: 160,

                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF332A22)
                                : AppColors.peach,

                            borderRadius: BorderRadius.circular(20),

                            border: Border.all(color: borderColor(isDark)),

                            image: selectedImage != null
                                ? DecorationImage(
                                    image: FileImage(selectedImage!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),

                          child: selectedImage == null
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_a_photo_outlined,
                                      size: 45,
                                      color: accentColor(isDark),
                                    ),

                                    const SizedBox(height: 10),

                                    Text(
                                      'Add Photo',
                                      style: TextStyle(
                                        color: accentColor(isDark),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                )
                              : Stack(
                                  children: [
                                    Positioned(
                                      top: 8,
                                      right: 8,

                                      child: Container(
                                        width: 35,
                                        height: 35,

                                        decoration: BoxDecoration(
                                          color: cardColor(isDark),
                                          shape: BoxShape.circle,
                                        ),

                                        child: Icon(
                                          Icons.edit,
                                          size: 18,
                                          color: accentColor(isDark),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Center(
                      child: Text(
                        'Tap to select cake image',

                        style: TextStyle(
                          color: secondaryTextColor(isDark),
                          fontSize: 12,
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ==================================================
                    // CAKE NAME
                    // ==================================================
                    _buildLabel('Cake Name', isDark),

                    TextFormField(
                      controller: nameController,

                      textCapitalization: TextCapitalization.words,

                      style: TextStyle(color: primaryTextColor(isDark)),

                      decoration: _inputDecoration(
                        'Enter cake name',
                        Icons.cake_outlined,
                        isDark,
                      ),

                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter cake name';
                        }

                        if (value.trim().length < 3) {
                          return 'Cake name must be at least 3 characters';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // ==================================================
                    // CATEGORY
                    // ==================================================
                    _buildLabel('Category', isDark),

                    DropdownButtonFormField<String>(
                      initialValue: selectedCategory,

                      dropdownColor: fieldColor(isDark),

                      style: TextStyle(color: primaryTextColor(isDark)),

                      decoration: _inputDecoration(
                        'Select category',
                        Icons.category_outlined,
                        isDark,
                      ),

                      items: categories.map((category) {
                        return DropdownMenuItem<String>(
                          value: category,

                          child: Text(
                            category,
                            style: TextStyle(color: primaryTextColor(isDark)),
                          ),
                        );
                      }).toList(),

                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }

                        setState(() {
                          selectedCategory = value;
                        });
                      },
                    ),

                    const SizedBox(height: 20),

                    // ==================================================
                    // PRICE
                    // ==================================================
                    _buildLabel('Price', isDark),

                    TextFormField(
                      controller: priceController,

                      keyboardType: TextInputType.number,

                      style: TextStyle(color: primaryTextColor(isDark)),

                      decoration: _inputDecoration(
                        'Enter price',
                        Icons.payments_outlined,
                        isDark,
                      ),

                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter price';
                        }

                        final price = double.tryParse(value.trim());

                        if (price == null || price <= 0) {
                          return 'Please enter a valid price';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // ==================================================
                    // RATING
                    // ==================================================
                    _buildLabel('Rating', isDark),

                    TextFormField(
                      controller: ratingController,

                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),

                      style: TextStyle(color: primaryTextColor(isDark)),

                      decoration: _inputDecoration(
                        'Example: 4.8',
                        Icons.star_outline,
                        isDark,
                      ),

                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter rating';
                        }

                        final rating = double.tryParse(value.trim());

                        if (rating == null || rating < 0 || rating > 5) {
                          return 'Rating must be between 0 and 5';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // ==================================================
                    // DESCRIPTION
                    // ==================================================
                    _buildLabel('Description', isDark),

                    TextFormField(
                      controller: descriptionController,

                      maxLines: 5,

                      textCapitalization: TextCapitalization.sentences,

                      style: TextStyle(color: primaryTextColor(isDark)),

                      decoration: _inputDecoration(
                        'Enter cake description',
                        Icons.description_outlined,
                        isDark,
                      ),

                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter description';
                        }

                        if (value.trim().length < 10) {
                          return 'Description must be at least 10 characters';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 30),

                    // ==================================================
                    // ADD CAKE
                    // ==================================================
                    SizedBox(
                      width: double.infinity,
                      height: 55,

                      child: ElevatedButton.icon(
                        onPressed: saveCake,

                        icon: const Icon(Icons.add),

                        label: const Text(
                          'Add Cake',

                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.brown,

                          foregroundColor: Colors.white,

                          elevation: 0,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // LABEL
  // ============================================================

  Widget _buildLabel(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),

      child: Text(
        text,

        style: TextStyle(
          color: accentColor(isDark),

          fontWeight: FontWeight.bold,

          fontSize: 14,
        ),
      ),
    );
  }

  // ============================================================
  // INPUT DECORATION
  // ============================================================

  InputDecoration _inputDecoration(String hint, IconData icon, bool isDark) {
    return InputDecoration(
      hintText: hint,

      hintStyle: TextStyle(color: secondaryTextColor(isDark)),

      prefixIcon: Icon(icon, color: accentColor(isDark)),

      filled: true,

      fillColor: fieldColor(isDark),

      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),

        borderSide: BorderSide(color: borderColor(isDark)),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),

        borderSide: BorderSide(color: borderColor(isDark)),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),

        borderSide: BorderSide(color: AppColors.gold, width: 2),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),

        borderSide: const BorderSide(color: Colors.red),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),

        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
    );
  }
}

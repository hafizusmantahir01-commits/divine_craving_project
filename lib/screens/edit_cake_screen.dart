import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_colors.dart';
import '../providers/admin_theme_provider.dart';

class EditCakeScreen extends StatefulWidget {
  final Map<String, String> cake;

  const EditCakeScreen({
    super.key,
    required this.cake,
  });

  @override
  State<EditCakeScreen> createState() => _EditCakeScreenState();
}

class _EditCakeScreenState extends State<EditCakeScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController ratingController;
  late TextEditingController descriptionController;

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

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(
      text: widget.cake['name'] ?? '',
    );

    priceController = TextEditingController(
      text: _removeRs(widget.cake['price'] ?? ''),
    );

    ratingController = TextEditingController(
      text: widget.cake['rating'] ?? '',
    );

    descriptionController = TextEditingController(
      text: widget.cake['description'] ?? '',
    );

    final category = widget.cake['category'];

    if (category != null && categories.contains(category)) {
      selectedCategory = category;
    }

    final imagePath = widget.cake['image'];

    if (imagePath != null && imagePath.isNotEmpty) {
      final file = File(imagePath);

      if (file.existsSync()) {
        selectedImage = file;
      }
    }
  }

  String _removeRs(String price) {
    return price
        .replaceFirst('Rs ', '')
        .replaceFirst('Rs', '')
        .replaceAll(',', '')
        .trim();
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    ratingController.dispose();
    descriptionController.dispose();

    super.dispose();
  }

  // ============================================================
  // PICK IMAGE
  // ============================================================

  Future<void> pickImage() async {
    try {
      final XFile? image = await imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          selectedImage = File(image.path);
        });
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to select image'),
        ),
      );
    }
  }

  // ============================================================
  // UPDATE CAKE
  // ============================================================

  void updateCake() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final updatedCake = <String, String>{
      'name': nameController.text.trim(),
      'category': selectedCategory,
      'price': 'Rs ${priceController.text.trim()}',
      'rating': ratingController.text.trim(),
      'description': descriptionController.text.trim(),
      'image': selectedImage?.path ?? widget.cake['image'] ?? '',
    };

    Navigator.pop(context, updatedCake);
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminThemeProvider>(
      builder: (context, themeProvider, child) {
        final bool isDark =
            themeProvider.themeMode == ThemeMode.dark;

        final Color backgroundColor = isDark
            ? const Color(0xFF121212)
            : const Color(0xFFF8F4EF);

        final Color cardColor = isDark
            ? const Color(0xFF242424)
            : Colors.white;

        final Color primaryText = isDark
            ? Colors.white
            : AppColors.brown;

        final Color secondaryText = isDark
            ? Colors.white60
            : AppColors.grey;

        return Scaffold(
          backgroundColor: backgroundColor,

          // ======================================================
          // APP BAR
          // ======================================================

          appBar: AppBar(
            backgroundColor: cardColor,
            elevation: 0,

            iconTheme: IconThemeData(
              color: primaryText,
            ),

            title: Text(
              'Edit Cake',
              style: TextStyle(
                color: primaryText,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // ======================================================
          // BODY
          // ======================================================

          body: Form(
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
                        width: 170,
                        height: 170,

                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF2D2D2D)
                              : AppColors.peach,

                          borderRadius:
                              BorderRadius.circular(22),

                          image: selectedImage != null
                              ? DecorationImage(
                                  image: FileImage(
                                    selectedImage!,
                                  ),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),

                        child: selectedImage == null
                            ? Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons
                                        .add_a_photo_outlined,
                                    size: 45,
                                    color: isDark
                                        ? AppColors.gold
                                        : AppColors.brown,
                                  ),

                                  const SizedBox(height: 8),

                                  Text(
                                    'Change Photo',
                                    style: TextStyle(
                                      color: isDark
                                          ? Colors.white
                                          : AppColors.brown,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
                            : Container(
                                alignment:
                                    Alignment.bottomCenter,

                                padding:
                                    const EdgeInsets.only(
                                  bottom: 10,
                                ),

                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),

                                  decoration:
                                      BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius:
                                        BorderRadius.circular(
                                      20,
                                    ),
                                  ),

                                  child: const Text(
                                    'Change Photo',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Center(
                    child: Text(
                      'Tap image to change cake photo',
                      style: TextStyle(
                        color: secondaryText,
                        fontSize: 12,
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ==================================================
                  // CAKE NAME
                  // ==================================================

                  _buildLabel(
                    'Cake Name',
                    primaryText,
                  ),

                  TextFormField(
                    controller: nameController,

                    style: TextStyle(
                      color: primaryText,
                    ),

                    decoration: _inputDecoration(
                      'Enter cake name',
                      Icons.cake_outlined,
                      isDark,
                    ),

                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'Please enter cake name';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // ==================================================
                  // CATEGORY
                  // ==================================================

                  _buildLabel(
                    'Category',
                    primaryText,
                  ),

                  DropdownButtonFormField<String>(
                    initialValue: selectedCategory,

                    dropdownColor: cardColor,

                    style: TextStyle(
                      color: primaryText,
                    ),

                    decoration: _inputDecoration(
                      'Select category',
                      Icons.category_outlined,
                      isDark,
                    ),

                    items: categories.map((category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),

                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedCategory = value;
                        });
                      }
                    },
                  ),

                  const SizedBox(height: 20),

                  // ==================================================
                  // PRICE
                  // ==================================================

                  _buildLabel(
                    'Price',
                    primaryText,
                  ),

                  TextFormField(
                    controller: priceController,

                    keyboardType:
                        TextInputType.number,

                    style: TextStyle(
                      color: primaryText,
                    ),

                    decoration: _inputDecoration(
                      'Enter price',
                      Icons.payments_outlined,
                      isDark,
                    ),

                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'Please enter price';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // ==================================================
                  // RATING
                  // ==================================================

                  _buildLabel(
                    'Rating',
                    primaryText,
                  ),

                  TextFormField(
                    controller: ratingController,

                    keyboardType:
                        const TextInputType.numberWithOptions(
                      decimal: true,
                    ),

                    style: TextStyle(
                      color: primaryText,
                    ),

                    decoration: _inputDecoration(
                      'Example: 4.8',
                      Icons.star_outline,
                      isDark,
                    ),

                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'Please enter rating';
                      }

                      final rating =
                          double.tryParse(value);

                      if (rating == null) {
                        return 'Enter a valid rating';
                      }

                      if (rating < 0 || rating > 5) {
                        return 'Rating must be between 0 and 5';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // ==================================================
                  // DESCRIPTION
                  // ==================================================

                  _buildLabel(
                    'Description',
                    primaryText,
                  ),

                  TextFormField(
                    controller: descriptionController,

                    maxLines: 5,

                    style: TextStyle(
                      color: primaryText,
                    ),

                    decoration: _inputDecoration(
                      'Enter cake description',
                      Icons.description_outlined,
                      isDark,
                    ),

                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'Please enter description';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 30),

                  // ==================================================
                  // UPDATE BUTTON
                  // ==================================================

                  SizedBox(
                    width: double.infinity,
                    height: 55,

                    child: ElevatedButton.icon(
                      onPressed: updateCake,

                      icon: const Icon(
                        Icons.save_outlined,
                      ),

                      label: const Text(
                        'Update Cake',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            isDark
                                ? AppColors.gold
                                : AppColors.brown,

                        foregroundColor:
                            isDark
                                ? AppColors.brown
                                : Colors.white,

                        elevation: 0,

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
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

  Widget _buildLabel(
    String text,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),

      child: Text(
        text,

        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // ============================================================
  // INPUT DECORATION
  // ============================================================

  InputDecoration _inputDecoration(
    String hint,
    IconData icon,
    bool isDark,
  ) {
    return InputDecoration(
      hintText: hint,

      hintStyle: TextStyle(
        color: isDark
            ? Colors.white38
            : Colors.grey,
      ),

      prefixIcon: Icon(
        icon,
        color: isDark
            ? AppColors.gold
            : AppColors.brown,
      ),

      filled: true,

      fillColor: isDark
          ? const Color(0xFF242424)
          : Colors.white,

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(
          color: isDark
              ? AppColors.gold
              : AppColors.gold,
          width: 2,
        ),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: Colors.red,
        ),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 2,
        ),
      ),
    );
  }
}
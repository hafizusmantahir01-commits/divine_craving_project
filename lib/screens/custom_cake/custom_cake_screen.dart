import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/constants/app_colors.dart';

class CustomCakeScreen extends StatefulWidget {
  const CustomCakeScreen({super.key});

  @override
  State<CustomCakeScreen> createState() => _CustomCakeScreenState();
}

class _CustomCakeScreenState extends State<CustomCakeScreen> {
  // ============================================================
  // FIREBASE
  // ============================================================

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final FirebaseStorage _storage =
      FirebaseStorage.instance;

  final ImagePicker _imagePicker =
      ImagePicker();

  // ============================================================
  // CONTROLLERS
  // ============================================================

  final TextEditingController flavorController =
      TextEditingController();

  final TextEditingController sizeController =
      TextEditingController();

  final TextEditingController themeController =
      TextEditingController();

  final TextEditingController instructionsController =
      TextEditingController();

  // ============================================================
  // VARIABLES
  // ============================================================

  File? selectedImage;

  bool isLoading = false;

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    flavorController.dispose();
    sizeController.dispose();
    themeController.dispose();
    instructionsController.dispose();

    super.dispose();
  }

  // ============================================================
  // SHOW MESSAGE
  // ============================================================

  void _showMessage(
    String message, {
    bool isError = true,
  }) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: isError
              ? Colors.red.shade700
              : Colors.green.shade700,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 3),
        ),
      );
  }

  // ============================================================
  // PICK IMAGE
  // ============================================================

  Future<void> _pickImage() async {
    if (isLoading) return;

    try {
      final XFile? image =
          await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image == null) {
        return;
      }

      setState(() {
        selectedImage = File(image.path);
      });
    } catch (e) {
      _showMessage(
        'Unable to select image. Please try again.',
      );
    }
  }

  // ============================================================
  // REMOVE IMAGE
  // ============================================================

  void _removeImage() {
    setState(() {
      selectedImage = null;
    });
  }

  // ============================================================
  // UPLOAD IMAGE TO FIREBASE STORAGE
  // ============================================================

  Future<String?> _uploadImage(
    String requestId,
  ) async {
    if (selectedImage == null) {
      return null;
    }

    try {
      final String fileName =
          'custom_cake_${DateTime.now().millisecondsSinceEpoch}.jpg';

      final Reference reference = _storage
          .ref()
          .child(
            'custom_cake_requests/$requestId/$fileName',
          );

      final UploadTask uploadTask =
          reference.putFile(selectedImage!);

      final TaskSnapshot snapshot =
          await uploadTask;

      final String downloadUrl =
          await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      debugPrint(
        'IMAGE UPLOAD ERROR: $e',
      );

      throw Exception(
        'Unable to upload reference image.',
      );
    }
  }

  // ============================================================
  // SEND CUSTOM REQUEST
  // ============================================================

  Future<void> _sendCustomRequest() async {
    if (isLoading) return;

    FocusScope.of(context).unfocus();

    final String flavor =
        flavorController.text.trim();

    final String cakeSize =
        sizeController.text.trim();

    final String theme =
        themeController.text.trim();

    final String instructions =
        instructionsController.text.trim();

    // ==========================================================
    // VALIDATION
    // ==========================================================

    if (flavor.isEmpty) {
      _showMessage(
        'Please enter the cake flavor.',
      );
      return;
    }

    if (cakeSize.isEmpty) {
      _showMessage(
        'Please enter the cake size.',
      );
      return;
    }

    if (theme.isEmpty) {
      _showMessage(
        'Please enter the theme or occasion.',
      );
      return;
    }

    // ==========================================================
    // CHECK USER
    // ==========================================================

    final User? user =
        _auth.currentUser;

    if (user == null) {
      _showMessage(
        'Please login before sending a custom cake request.',
      );
      return;
    }

    // ==========================================================
    // LOADING
    // ==========================================================

    setState(() {
      isLoading = true;
    });

    try {
      // ========================================================
      // CREATE FIRESTORE DOCUMENT ID
      // ========================================================

      final DocumentReference requestReference =
          _firestore
              .collection('custom_cake_requests')
              .doc();

      final String requestId =
          requestReference.id;

      debugPrint(
        'CUSTOM CAKE REQUEST ID: $requestId',
      );

      // ========================================================
      // UPLOAD IMAGE
      // ========================================================

      String? imageUrl;

      if (selectedImage != null) {
        debugPrint(
          'Uploading custom cake image...',
        );

        imageUrl =
            await _uploadImage(
          requestId,
        );

        debugPrint(
          'Image uploaded successfully.',
        );
      }

      // ========================================================
      // SAVE REQUEST TO FIRESTORE
      // ========================================================

      await requestReference.set({
        'requestId': requestId,
        'userId': user.uid,
        'userEmail': user.email ?? '',
        'userName':
            user.displayName ?? '',

        'flavor': flavor,
        'size': cakeSize,
        'theme': theme,
        'specialInstructions':
            instructions,

        'referenceImage':
            imageUrl ?? '',

        'status': 'Pending',

        'createdAt':
            FieldValue.serverTimestamp(),

        'updatedAt':
            FieldValue.serverTimestamp(),
      });

      debugPrint(
        'Custom cake request saved successfully.',
      );

      if (!mounted) return;

      _showMessage(
        'Custom cake request sent successfully!',
        isError: false,
      );

      // ========================================================
      // CLEAR FORM
      // ========================================================

      flavorController.clear();
      sizeController.clear();
      themeController.clear();
      instructionsController.clear();

      setState(() {
        selectedImage = null;
      });

      await Future.delayed(
        const Duration(milliseconds: 700),
      );

      if (!mounted) return;

      Navigator.pop(context);
    }

    // ==========================================================
    // FIREBASE ERROR
    // ==========================================================

    on FirebaseException catch (e) {
      debugPrint(
        'FIREBASE ERROR: ${e.code}',
      );

      debugPrint(
        'MESSAGE: ${e.message}',
      );

      String message;

      switch (e.code) {
        case 'permission-denied':
          message =
              'Permission denied. Please check Firebase security rules.';
          break;

        case 'unauthenticated':
          message =
              'Please login before sending a request.';
          break;

        case 'unavailable':
          message =
              'Firebase is temporarily unavailable. Please try again.';
          break;

        default:
          message =
              e.message ??
                  'Unable to send custom cake request.';
      }

      _showMessage(message);
    }

    // ==========================================================
    // OTHER ERROR
    // ==========================================================

    catch (e) {
      debugPrint(
        'CUSTOM CAKE ERROR: $e',
      );

      _showMessage(
        'Something went wrong. Please try again.',
      );
    }

    // ==========================================================
    // STOP LOADING
    // ==========================================================

    finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final ThemeData theme =
        Theme.of(context);

    final bool isDark =
        theme.brightness == Brightness.dark;

    final Color primaryColor =
        theme.colorScheme.primary;

    final Color backgroundColor =
        isDark
            ? const Color(0xFF1B1411)
            : const Color(0xFFFFFAF6);

    final Color cardColor =
        isDark
            ? const Color(0xFF261D19)
            : Colors.white;

    final Color textColor =
        isDark
            ? Colors.white
            : AppColors.brown;

    final Color secondaryText =
        isDark
            ? Colors.white70
            : AppColors.grey;

    return Scaffold(
      backgroundColor: backgroundColor,

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        elevation: 0,
        backgroundColor:
            backgroundColor,

        foregroundColor:
            primaryColor,

        title: const Text(
          'Custom Cake',
          style: TextStyle(
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: SafeArea(
        child: ListView(
          padding:
              const EdgeInsets.all(20),

          children: [
            // ==================================================
            // HEADER
            // ==================================================

            Text(
              'Create Your Dream Cake 🎂',
              style: TextStyle(
                fontSize: 24,
                fontWeight:
                    FontWeight.bold,
                color: textColor,
              ),
            ),

            const SizedBox(height: 7),

            Text(
              'Tell us how you want your cake and we will prepare a special custom design for you.',
              style: TextStyle(
                color: secondaryText,
                fontSize: 13,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 25),

            // ==================================================
            // IMAGE UPLOAD
            // ==================================================

            GestureDetector(
              onTap:
                  isLoading
                      ? null
                      : _pickImage,

              child: Container(
                height: 200,

                decoration:
                    BoxDecoration(
                  color: cardColor,

                  borderRadius:
                      BorderRadius.circular(
                    20,
                  ),

                  border: Border.all(
                    color:
                        isDark
                            ? Colors.white10
                            : AppColors.peach,
                  ),
                ),

                child:
                    selectedImage != null
                        ? Stack(
                            children: [
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(
                                  20,
                                ),

                                child:
                                    SizedBox(
                                  width:
                                      double.infinity,

                                  height:
                                      double.infinity,

                                  child:
                                      Image.file(
                                    selectedImage!,
                                    fit:
                                        BoxFit.cover,
                                  ),
                                ),
                              ),

                              Positioned(
                                top: 10,
                                right: 10,

                                child:
                                    Material(
                                  color:
                                      Colors.black
                                          .withOpacity(
                                    0.55,
                                  ),

                                  shape:
                                      const CircleBorder(),

                                  child:
                                      InkWell(
                                    customBorder:
                                        const CircleBorder(),

                                    onTap:
                                        isLoading
                                            ? null
                                            : _removeImage,

                                    child:
                                        const Padding(
                                      padding:
                                          EdgeInsets.all(
                                        8,
                                      ),

                                      child:
                                          Icon(
                                        Icons.close,
                                        color:
                                            Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )

                        : Column(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .center,

                            children: [
                              Icon(
                                Icons
                                    .add_photo_alternate_outlined,

                                size: 55,

                                color:
                                    primaryColor,
                              ),

                              const SizedBox(
                                height: 12,
                              ),

                              Text(
                                'Upload Cake Reference',

                                style:
                                    TextStyle(
                                  fontWeight:
                                      FontWeight.bold,

                                  color:
                                      textColor,
                                ),
                              ),

                              const SizedBox(
                                height: 5,
                              ),

                              Text(
                                'Tap to upload an image',

                                style:
                                    TextStyle(
                                  color:
                                      secondaryText,
                                ),
                              ),
                            ],
                          ),
              ),
            ),

            const SizedBox(height: 25),

            // ==================================================
            // CAKE FLAVOR
            // ==================================================

            TextField(
              controller:
                  flavorController,

              textInputAction:
                  TextInputAction.next,

              decoration:
                  const InputDecoration(
                labelText:
                    'Cake Flavor',

                hintText:
                    'Chocolate, Vanilla, Red Velvet...',
              ),
            ),

            const SizedBox(height: 15),

            // ==================================================
            // CAKE SIZE
            // ==================================================

            TextField(
              controller:
                  sizeController,

              textInputAction:
                  TextInputAction.next,

              decoration:
                  const InputDecoration(
                labelText:
                    'Cake Size',

                hintText:
                    '1 Pound, 2 Pound, 3 Pound...',
              ),
            ),

            const SizedBox(height: 15),

            // ==================================================
            // THEME
            // ==================================================

            TextField(
              controller:
                  themeController,

              textInputAction:
                  TextInputAction.next,

              decoration:
                  const InputDecoration(
                labelText:
                    'Theme / Occasion',

                hintText:
                    'Birthday, Wedding, Anniversary...',
              ),
            ),

            const SizedBox(height: 15),

            // ==================================================
            // SPECIAL INSTRUCTIONS
            // ==================================================

            TextField(
              controller:
                  instructionsController,

              maxLines: 5,

              textInputAction:
                  TextInputAction.done,

              decoration:
                  const InputDecoration(
                labelText:
                    'Special Instructions',

                hintText:
                    'Write any special instructions for your cake...',
                alignLabelWithHint:
                    true,
              ),
            ),

            const SizedBox(height: 28),

            // ==================================================
            // SEND BUTTON
            // ==================================================

            SizedBox(
              height: 55,

              child:
                  FilledButton(
                onPressed:
                    isLoading
                        ? null
                        : _sendCustomRequest,

                child:
                    isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,

                            child:
                                CircularProgressIndicator(
                              strokeWidth:
                                  2.5,

                              color:
                                  Colors.white,
                            ),
                          )

                        : const Text(
                            'SEND CUSTOM REQUEST',

                            style:
                                TextStyle(
                              fontWeight:
                                  FontWeight.bold,

                              letterSpacing:
                                  0.8,
                            ),
                          ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
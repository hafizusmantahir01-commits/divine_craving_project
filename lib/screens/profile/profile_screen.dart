import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/constants/app_colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
  // USER
  // ============================================================

  User? get currentUser =>
      _auth.currentUser;

  // ============================================================
  // LOADING STATES
  // ============================================================

  bool isUploadingImage = false;

  bool isLoggingOut = false;

  // ============================================================
  // SHOW MESSAGE
  // ============================================================

  void _showMessage(
    String message, {
    bool isError = false,
  }) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),

          behavior:
              SnackBarBehavior.floating,

          margin:
              const EdgeInsets.all(16),

          backgroundColor: isError
              ? Colors.red.shade700
              : Colors.green.shade700,
        ),
      );
  }

  // ============================================================
  // IMAGE SOURCE SHEET
  // ============================================================

  Future<void> _showImagePickerOptions() async {
    if (currentUser == null) {
      _showMessage(
        'Please login first.',
        isError: true,
      );

      return;
    }

    showModalBottomSheet(
      context: context,

      shape:
          const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),

      builder: (context) {
        return SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(
              vertical: 20,
            ),

            child: Column(
              mainAxisSize:
                  MainAxisSize.min,

              children: [
                const Text(
                  'Change Profile Photo',

                  style: TextStyle(
                    fontSize: 20,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 15,
                ),

                ListTile(
                  leading:
                      const CircleAvatar(
                    child: Icon(
                      Icons.photo_library_outlined,
                    ),
                  ),

                  title:
                      const Text(
                    'Choose from Gallery',
                  ),

                  onTap: () {
                    Navigator.pop(
                      context,
                    );

                    _pickAndUploadImage(
                      ImageSource.gallery,
                    );
                  },
                ),

                ListTile(
                  leading:
                      const CircleAvatar(
                    child: Icon(
                      Icons.camera_alt_outlined,
                    ),
                  ),

                  title:
                      const Text(
                    'Take a Photo',
                  ),

                  onTap: () {
                    Navigator.pop(
                      context,
                    );

                    _pickAndUploadImage(
                      ImageSource.camera,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // PICK AND UPLOAD IMAGE
  // ============================================================

  Future<void> _pickAndUploadImage(
    ImageSource source,
  ) async {
    if (isUploadingImage) {
      return;
    }

    try {
      final XFile? pickedFile =
          await _imagePicker.pickImage(
        source: source,

        imageQuality: 80,

        maxWidth: 1200,

        maxHeight: 1200,
      );

      if (pickedFile == null) {
        return;
      }

      await _uploadProfileImage(
        File(
          pickedFile.path,
        ),
      );
    } catch (e) {
      _showMessage(
        'Unable to select image.',
        isError: true,
      );
    }
  }

  // ============================================================
  // UPLOAD PROFILE IMAGE
  // ============================================================

  Future<void> _uploadProfileImage(
    File imageFile,
  ) async {
    final User? user =
        currentUser;

    if (user == null) {
      _showMessage(
        'Please login again.',
        isError: true,
      );

      return;
    }

    setState(() {
      isUploadingImage = true;
    });

    try {
      final String filePath =
          'profile_images/${user.uid}/profile.jpg';

      final Reference storageReference =
          _storage.ref().child(
                filePath,
              );

      await storageReference.putFile(
        imageFile,
      );

      final String imageUrl =
          await storageReference
              .getDownloadURL();

      // ========================================================
      // SAVE IMAGE IN FIRESTORE
      // ========================================================

      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(
        {
          'profileImage': imageUrl,

          'updatedAt':
              FieldValue.serverTimestamp(),
        },

        SetOptions(
          merge: true,
        ),
      );

      // ========================================================
      // UPDATE FIREBASE AUTH
      // ========================================================

      await user.updatePhotoURL(
        imageUrl,
      );

      await user.reload();

      _showMessage(
        'Profile photo updated successfully.',
      );
    } on FirebaseException catch (e) {
      _showMessage(
        e.message ??
            'Unable to upload profile photo.',

        isError: true,
      );
    } catch (e) {
      _showMessage(
        'Something went wrong while uploading the image.',

        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() {
          isUploadingImage = false;
        });
      }
    }
  }

  // ============================================================
  // EDIT PROFILE
  // ============================================================

  Future<void> _showEditProfileDialog(
    Map<String, dynamic> userData,
  ) async {
    final TextEditingController nameController =
        TextEditingController(
      text:
          userData['name'] ??
              currentUser?.displayName ??
              '',
    );

    final TextEditingController phoneController =
        TextEditingController(
      text:
          userData['phone'] ??
              '',
    );

    bool isSaving = false;

    await showDialog(
      context: context,

      barrierDismissible: false,

      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (
            context,
            setDialogState,
          ) {
            return AlertDialog(
              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(22),
              ),

              title:
                  const Text(
                'Edit Profile',
              ),

              content:
                  SingleChildScrollView(
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min,

                  children: [
                    TextField(
                      controller:
                          nameController,

                      textCapitalization:
                          TextCapitalization.words,

                      decoration:
                          const InputDecoration(
                        labelText:
                            'Full Name',

                        prefixIcon:
                            Icon(
                          Icons.person_outline,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 18,
                    ),

                    TextField(
                      controller:
                          phoneController,

                      keyboardType:
                          TextInputType.phone,

                      decoration:
                          const InputDecoration(
                        labelText:
                            'Phone Number',

                        prefixIcon:
                            Icon(
                          Icons.phone_outlined,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              actions: [
                TextButton(
                  onPressed:
                      isSaving
                          ? null
                          : () {
                              Navigator.pop(
                                dialogContext,
                              );
                            },

                  child:
                      const Text(
                    'Cancel',
                  ),
                ),

                FilledButton(
                  onPressed:
                      isSaving
                          ? null
                          : () async {
                              final String name =
                                  nameController
                                      .text
                                      .trim();

                              final String phone =
                                  phoneController
                                      .text
                                      .trim();

                              if (name.isEmpty) {
                                _showMessage(
                                  'Please enter your name.',
                                  isError: true,
                                );

                                return;
                              }

                              setDialogState(() {
                                isSaving = true;
                              });

                              try {
                                await _updateProfile(
                                  name: name,
                                  phone: phone,
                                );

                                if (
                                    dialogContext
                                        .mounted) {
                                  Navigator.pop(
                                    dialogContext,
                                  );
                                }
                              } finally {
                                if (
                                    dialogContext
                                        .mounted) {
                                  setDialogState(() {
                                    isSaving = false;
                                  });
                                }
                              }
                            },

                  child:
                      isSaving
                          ? const SizedBox(
                              width: 20,
                              height: 20,

                              child:
                                  CircularProgressIndicator(
                                strokeWidth:
                                    2,

                                color:
                                    Colors.white,
                              ),
                            )
                          : const Text(
                              'Save',
                            ),
                ),
              ],
            );
          },
        );
      },
    );

    nameController.dispose();
    phoneController.dispose();
  }

  // ============================================================
  // UPDATE PROFILE
  // ============================================================

  Future<void> _updateProfile({
    required String name,
    required String phone,
  }) async {
    final User? user =
        currentUser;

    if (user == null) {
      _showMessage(
        'User not found. Please login again.',
        isError: true,
      );

      return;
    }

    try {
      // ========================================================
      // FIRESTORE UPDATE
      // ========================================================

      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(
        {
          'uid': user.uid,

          'name': name,

          'phone': phone,

          'email': user.email,

          'updatedAt':
              FieldValue.serverTimestamp(),
        },

        SetOptions(
          merge: true,
        ),
      );

      // ========================================================
      // FIREBASE AUTH DISPLAY NAME
      // ========================================================

      await user.updateDisplayName(
        name,
      );

      await user.reload();

      _showMessage(
        'Profile updated successfully.',
      );
    } on FirebaseException catch (e) {
      _showMessage(
        e.message ??
            'Unable to update profile.',

        isError: true,
      );
    } catch (e) {
      _showMessage(
        'Something went wrong while updating your profile.',

        isError: true,
      );
    }
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  Future<void> _logout() async {
    if (isLoggingOut) {
      return;
    }

    final bool? shouldLogout =
        await showDialog<bool>(
      context: context,

      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(22),
          ),

          title:
              const Text(
            'Logout',
          ),

          content:
              const Text(
            'Are you sure you want to logout?',
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  false,
                );
              },

              child:
                  const Text(
                'Cancel',
              ),
            ),

            FilledButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  true,
                );
              },

              child:
                  const Text(
                'Logout',
              ),
            ),
          ],
        );
      },
    );

    if (shouldLogout != true) {
      return;
    }

    setState(() {
      isLoggingOut = true;
    });

    try {
      await _auth.signOut();

      if (!mounted) {
        return;
      }

      Navigator.of(context)
          .pushNamedAndRemoveUntil(
        '/login',
        (route) => false,
      );
    } catch (e) {
      _showMessage(
        'Unable to logout. Please try again.',
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoggingOut = false;
        });
      }
    }
  }

  // ============================================================
  // BUILD PROFILE IMAGE
  // ============================================================

  Widget _buildProfileImage(
    String? imageUrl,
    String name,
  ) {
    final String firstLetter =
        name.isNotEmpty
            ? name[0].toUpperCase()
            : 'U';

    return Stack(
      children: [
        Container(
          width: 120,
          height: 120,

          decoration:
              BoxDecoration(
            shape: BoxShape.circle,

            border: Border.all(
              color:
                  AppColors.gold,
              width: 4,
            ),
          ),

          child:
              ClipOval(
            child:
                imageUrl != null &&
                        imageUrl
                            .isNotEmpty
                    ? Image.network(
                        imageUrl,

                        fit:
                            BoxFit.cover,

                        errorBuilder: (
                          context,
                          error,
                          stackTrace,
                        ) {
                          return _buildInitialAvatar(
                            firstLetter,
                          );
                        },
                      )
                    : _buildInitialAvatar(
                        firstLetter,
                      ),
          ),
        ),

        if (isUploadingImage)
          Positioned.fill(
            child:
                Container(
              decoration:
                  BoxDecoration(
                shape:
                    BoxShape.circle,

                color:
                    Colors.black
                        .withOpacity(
                  0.55,
                ),
              ),

              child:
                  const Center(
                child:
                    CircularProgressIndicator(
                  color:
                      Colors.white,
                ),
              ),
            ),
          ),

        Positioned(
          right: 0,
          bottom: 0,

          child:
              GestureDetector(
            onTap:
                isUploadingImage
                    ? null
                    : _showImagePickerOptions,

            child:
                Container(
              width: 42,
              height: 42,

              decoration:
                  BoxDecoration(
                color:
                    AppColors.brown,

                shape:
                    BoxShape.circle,

                border:
                    Border.all(
                  color:
                      Colors.white,
                  width:
                      3,
                ),
              ),

              child:
                  const Icon(
                Icons.camera_alt,
                color:
                    Colors.white,
                size:
                    20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // INITIAL AVATAR
  // ============================================================

  Widget _buildInitialAvatar(
    String letter,
  ) {
    return Container(
      color:
          AppColors.brown,

      alignment:
          Alignment.center,

      child:
          Text(
        letter,

        style:
            const TextStyle(
          color:
              Colors.white,

          fontSize:
              48,

          fontWeight:
              FontWeight.bold,
        ),
      ),
    );
  }

  // ============================================================
  // PROFILE INFORMATION TILE
  // ============================================================

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    final bool isDark =
        Theme.of(context)
                .brightness ==
            Brightness.dark;

    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 12,
      ),

      padding:
          const EdgeInsets.all(16),

      decoration:
          BoxDecoration(
        color:
            isDark
                ? const Color(
                    0xFF2A211E,
                  )
                : Colors.white,

        borderRadius:
            BorderRadius.circular(
          16,
        ),

        border:
            Border.all(
          color:
              isDark
                  ? Colors.white10
                  : const Color(
                      0xFFF0E2D6,
                    ),
        ),
      ),

      child:
          Row(
        children: [
          Container(
            width: 45,
            height: 45,

            decoration:
                BoxDecoration(
              color:
                  AppColors.gold
                      .withOpacity(
                0.15,
              ),

              borderRadius:
                  BorderRadius.circular(
                12,
              ),
            ),

            child:
                Icon(
              icon,

              color:
                  AppColors.brown,
            ),
          ),

          const SizedBox(
            width: 15,
          ),

          Expanded(
            child:
                Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  style:
                      TextStyle(
                    color:
                        isDark
                            ? Colors.white60
                            : Colors.grey,

                    fontSize:
                        12,
                  ),
                ),

                const SizedBox(
                  height: 4,
                ),

                Text(
                  value,

                  maxLines:
                      1,

                  overflow:
                      TextOverflow.ellipsis,

                  style:
                      TextStyle(
                    color:
                        isDark
                            ? Colors.white
                            : AppColors.brown,

                    fontWeight:
                        FontWeight.w600,

                    fontSize:
                        16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final User? user =
        currentUser;

    if (user == null) {
      return Scaffold(
        body:
            Center(
          child:
              Column(
            mainAxisSize:
                MainAxisSize.min,

            children: [
              const Icon(
                Icons.person_off_outlined,
                size:
                    70,
              ),

              const SizedBox(
                height:
                    16,
              ),

              const Text(
                'You are not logged in.',
              ),

              const SizedBox(
                height:
                    16,
              ),

              FilledButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(
                    '/login',
                    (route) => false,
                  );
                },

                child:
                    const Text(
                  'Login',
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body:
          SafeArea(
        child:
            StreamBuilder<
                DocumentSnapshot<
                    Map<String, dynamic>>>(
          stream:
              _firestore
                  .collection('users')
                  .doc(user.uid)
                  .snapshots(),

          builder: (
            context,
            snapshot,
          ) {
            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child:
                    CircularProgressIndicator(),
              );
            }

            Map<String, dynamic>
                userData = {};

            if (snapshot.hasData &&
                snapshot.data != null &&
                snapshot.data!.exists) {
              userData =
                  snapshot.data!.data() ??
                      {};
            }

            final String name =
                userData['name'] ??
                    user.displayName ??
                    'Divine Craving User';

            final String email =
                userData['email'] ??
                    user.email ??
                    '';

            final String phone =
                userData['phone'] ??
                    'Not added';

            final String? imageUrl =
                userData['profileImage'] ??
                    user.photoURL;

            final bool isDark =
                Theme.of(context)
                        .brightness ==
                    Brightness.dark;

            return RefreshIndicator(
              onRefresh: () async {
                await user.reload();

                await _firestore
                    .collection('users')
                    .doc(user.uid)
                    .get();
              },

              child:
                  SingleChildScrollView(
                physics:
                    const AlwaysScrollableScrollPhysics(),

                padding:
                    const EdgeInsets.fromLTRB(
                  20,
                  25,
                  20,
                  30,
                ),

                child:
                    Column(
                  children: [
                    // ==================================================
                    // TITLE
                    // ==================================================

                    Row(
                      children: [
                        Expanded(
                          child:
                              Text(
                            'My Profile',

                            style:
                                TextStyle(
                              color:
                                  isDark
                                      ? Colors.white
                                      : AppColors
                                          .brown,

                              fontSize:
                                  28,

                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),
                          ),
                        ),

                        IconButton(
                          tooltip:
                              'Refresh',

                          onPressed: () {
                            setState(() {});
                          },

                          icon:
                              const Icon(
                            Icons.refresh,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 30,
                    ),

                    // ==================================================
                    // PROFILE IMAGE
                    // ==================================================

                    _buildProfileImage(
                      imageUrl,
                      name,
                    ),

                    const SizedBox(
                      height: 18,
                    ),

                    // ==================================================
                    // NAME
                    // ==================================================

                    Text(
                      name,

                      textAlign:
                          TextAlign.center,

                      style:
                          TextStyle(
                        color:
                            isDark
                                ? Colors.white
                                : AppColors.brown,

                        fontSize:
                            24,

                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      height: 5,
                    ),

                    Text(
                      email,

                      textAlign:
                          TextAlign.center,

                      style:
                          TextStyle(
                        color:
                            isDark
                                ? Colors.white60
                                : Colors.grey,
                      ),
                    ),

                    const SizedBox(
                      height: 25,
                    ),

                    // ==================================================
                    // EDIT PROFILE BUTTON
                    // ==================================================

                    SizedBox(
                      width:
                          double.infinity,

                      height:
                          52,

                      child:
                          OutlinedButton.icon(
                        onPressed: () {
                          _showEditProfileDialog(
                            userData,
                          );
                        },

                        icon:
                            const Icon(
                          Icons.edit_outlined,
                        ),

                        label:
                            const Text(
                          'Edit Profile',
                        ),
                      ),
                    ),

                    const SizedBox(
                      height:
                          30,
                    ),

                    // ==================================================
                    // PERSONAL INFORMATION
                    // ==================================================

                    Align(
                      alignment:
                          Alignment.centerLeft,

                      child:
                          Text(
                        'Personal Information',

                        style:
                            TextStyle(
                          color:
                              isDark
                                  ? Colors.white
                                  : AppColors
                                      .brown,

                          fontSize:
                              18,

                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height:
                          15,
                    ),

                    _buildInfoTile(
                      icon:
                          Icons.person_outline,

                      title:
                          'Full Name',

                      value:
                          name,
                    ),

                    _buildInfoTile(
                      icon:
                          Icons.email_outlined,

                      title:
                          'Email Address',

                      value:
                          email,
                    ),

                    _buildInfoTile(
                      icon:
                          Icons.phone_outlined,

                      title:
                          'Phone Number',

                      value:
                          phone,
                    ),

                    const SizedBox(
                      height:
                          30,
                    ),

                    // ==================================================
                    // LOGOUT
                    // ==================================================

                    SizedBox(
                      width:
                          double.infinity,

                      height:
                          55,

                      child:
                          OutlinedButton.icon(
                        onPressed:
                            isLoggingOut
                                ? null
                                : _logout,

                        icon:
                            isLoggingOut
                                ? const SizedBox(
                                    width:
                                        20,

                                    height:
                                        20,

                                    child:
                                        CircularProgressIndicator(
                                      strokeWidth:
                                          2,
                                    ),
                                  )
                                : const Icon(
                                    Icons.logout,
                                  ),

                        label:
                            Text(
                          isLoggingOut
                              ? 'Logging out...'
                              : 'Logout',
                        ),

                        style:
                            OutlinedButton.styleFrom(
                          foregroundColor:
                              Colors.red,

                          side:
                              const BorderSide(
                            color:
                                Colors.red,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height:
                          20,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
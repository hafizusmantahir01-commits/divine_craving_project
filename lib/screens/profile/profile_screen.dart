import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../providers/user_theme_provider.dart';

import '../auth/role_selection_screen.dart';
import '../orders/orders_screen.dart';
import '../custom_cake/custom_cake_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Uint8List? _profileImageBytes;

  String _userName = 'Sarah Khan';
  String _userEmail = 'sarah@example.com';

  final ImagePicker _picker = ImagePicker();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final List<AddressModel> _addresses = [
    AddressModel(
      id: '1',
      title: 'Home',
      address: 'House 123, Street 5, Sahiwal, Punjab, Pakistan',
      phone: '+92 300 1234567',
      isDefault: true,
    ),
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  bool get _isDark {
    return context.read<UserThemeProvider>().themeMode == ThemeMode.dark;
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }

  // ============================================================
  // PROFILE IMAGE
  // ============================================================

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1000,
        maxHeight: 1000,
      );

      if (image == null) return;

      final Uint8List bytes = await image.readAsBytes();

      if (!mounted) return;

      setState(() {
        _profileImageBytes = bytes;
      });

      _showMessage('Profile picture updated successfully');
    } catch (e) {
      if (!mounted) return;
      _showMessage('Picture select nahi ho saki');
    }
  }

  void _removeProfilePicture() {
    if (_profileImageBytes == null) {
      _showMessage('No profile picture to remove');
      return;
    }

    setState(() {
      _profileImageBytes = null;
    });

    _showMessage('Profile picture removed successfully');
  }

  void _openImageOptions() {
    final bool isDark = _isDark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF261D19) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const _SheetHandle(),
                const SizedBox(height: 18),
                Text(
                  'Profile Picture',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.brown,
                  ),
                ),
                const SizedBox(height: 15),
                _OptionTile(
                  icon: Icons.photo_library_outlined,
                  title: 'Choose from Gallery',
                  subtitle: 'Select a photo from your device',
                  isDark: isDark,
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                const SizedBox(height: 8),
                _OptionTile(
                  icon: Icons.camera_alt_outlined,
                  title: 'Take a Photo',
                  subtitle: 'Use your device camera',
                  isDark: isDark,
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _pickImage(ImageSource.camera);
                  },
                ),
                const SizedBox(height: 8),
                _OptionTile(
                  icon: Icons.delete_outline,
                  title: 'Remove Picture',
                  subtitle: 'Remove your current profile picture',
                  isDark: isDark,
                  isDanger: true,
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _removeProfilePicture();
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
  // EDIT PROFILE
  // ============================================================

 void _openEditProfileMenu() {
  final bool isDark = _isDark;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: isDark ? const Color(0xFF261D19) : Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(24),
      ),
    ),
    builder: (sheetContext) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const _SheetHandle(),

                const SizedBox(height: 18),

                Text(
                  'Edit Profile',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.brown,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  'Choose what you want to change',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white60 : AppColors.grey,
                  ),
                ),

                const SizedBox(height: 16),

                _OptionTile(
                  icon: Icons.person_outline,
                  title: 'Change Name',
                  subtitle: 'Update your profile name',
                  isDark: isDark,
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _showChangeNameDialog();
                  },
                ),

                const SizedBox(height: 8),

                _OptionTile(
                  icon: Icons.email_outlined,
                  title: 'Change Email',
                  subtitle: 'Update your email address',
                  isDark: isDark,
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _showChangeEmailDialog();
                  },
                ),

                const SizedBox(height: 8),

                _OptionTile(
                  icon: Icons.photo_camera_outlined,
                  title: 'Change Profile Picture',
                  subtitle: 'Choose a new profile picture',
                  isDark: isDark,
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _openImageOptions();
                  },
                ),

                const SizedBox(height: 8),

                _OptionTile(
                  icon: Icons.delete_outline,
                  title: 'Remove Profile Picture',
                  subtitle: 'Remove your current picture',
                  isDark: isDark,
                  isDanger: true,
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _removeProfilePicture();
                  },
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

  // ============================================================
  // CHANGE NAME
  // ============================================================

  void _showChangeNameDialog() {
    final bool isDark = _isDark;

    _nameController.text = _userName;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF261D19) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: Text(
            'Change Name',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.brown,
            ),
          ),
          content: TextField(
            controller: _nameController,
            autofocus: true,
            maxLength: 50,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
            ),
            decoration: InputDecoration(
              labelText: 'Name',
              hintText: 'Enter your name',
              prefixIcon: Icon(
                Icons.person_outline,
                color: isDark ? AppColors.gold : AppColors.brown,
              ),
              filled: true,
              fillColor:
                  isDark ? const Color(0xFF33231D) : const Color(0xFFF9F3ED),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: isDark ? AppColors.gold : AppColors.brown,
                foregroundColor: isDark ? AppColors.brown : Colors.white,
              ),
              onPressed: () {
                final String name = _nameController.text.trim();

                if (name.isEmpty) {
                  _showMessage('Name required hai');
                  return;
                }

                if (name.length < 2) {
                  _showMessage(
                    'Name kam az kam 2 characters ka hona chahiye',
                  );
                  return;
                }

                setState(() {
                  _userName = name;
                });

                Navigator.pop(dialogContext);
                _showMessage('Name updated successfully');
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // CHANGE EMAIL
  // ============================================================

  void _showChangeEmailDialog() {
    final bool isDark = _isDark;

    _emailController.text = _userEmail;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF261D19) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: Text(
            'Change Email',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.brown,
            ),
          ),
          content: TextField(
            controller: _emailController,
            autofocus: true,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
            ),
            decoration: InputDecoration(
              labelText: 'Email',
              hintText: 'Enter your email',
              prefixIcon: Icon(
                Icons.email_outlined,
                color: isDark ? AppColors.gold : AppColors.brown,
              ),
              filled: true,
              fillColor:
                  isDark ? const Color(0xFF33231D) : const Color(0xFFF9F3ED),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: isDark ? AppColors.gold : AppColors.brown,
                foregroundColor: isDark ? AppColors.brown : Colors.white,
              ),
              onPressed: () {
                final String email = _emailController.text.trim();

                final RegExp emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

                if (!emailRegex.hasMatch(email)) {
                  _showMessage('Please valid email enter karein');
                  return;
                }

                setState(() {
                  _userEmail = email;
                });

                Navigator.pop(dialogContext);
                _showMessage('Email updated successfully');
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // OPEN ADDRESSES
  // ============================================================

  void _openAddresses() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddressesScreen(
          addresses: _addresses,
          onAddressesChanged: (updatedAddresses) {
            if (!mounted) return;

            setState(() {
              _addresses
                ..clear()
                ..addAll(updatedAddresses);
            });
          },
        ),
      ),
    );
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  void _showLogoutDialog() {
    final bool isDark = _isDark;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF261D19) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: Row(
            children: [
              const Icon(
                Icons.logout,
                color: Colors.red,
              ),
              const SizedBox(width: 10),
              Text(
                'Logout',
                style: TextStyle(
                  color: isDark ? Colors.white : AppColors.brown,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.pop(dialogContext);

                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (_) => const RoleSelectionScreen(),
                  ),
                  (route) => false,
                );
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // BUILD PROFILE
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final UserThemeProvider themeProvider = context.watch<UserThemeProvider>();

    final bool isDark = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF1B1411) : const Color(0xFFFFFAF6),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // ==================================================
            // PROFILE HEADER
            // ==================================================

            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                top: 28,
                bottom: 32,
                left: 20,
                right: 20,
              ),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF3A251C) : AppColors.brown,
              ),
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark
                              ? const Color(0xFF33231D)
                              : AppColors.peach,
                          border: Border.all(
                            color: isDark ? AppColors.gold : Colors.white,
                            width: 3,
                          ),
                        ),
                        child: ClipOval(
                          child: _profileImageBytes != null
                              ? Image.memory(
                                  _profileImageBytes!,
                                  fit: BoxFit.cover,
                                )
                              : Icon(
                                  Icons.person,
                                  color:
                                      isDark ? AppColors.gold : AppColors.brown,
                                  size: 62,
                                ),
                        ),
                      ),
                      Positioned(
                        right: -3,
                        bottom: -3,
                        child: GestureDetector(
                          onTap: _openEditProfileMenu,
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AppColors.gold,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isDark
                                    ? const Color(0xFF3A251C)
                                    : Colors.white,
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.edit_outlined,
                              size: 17,
                              color: AppColors.brown,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _userName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _userEmail,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ==================================================
            // PROFILE OPTIONS
            // ==================================================

            ProfileItem(
              icon: Icons.shopping_bag_outlined,
              title: 'My Orders',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const OrdersScreen(),
                  ),
                );
              },
            ),

            ProfileItem(
              icon: Icons.cake_outlined,
              title: 'Custom Cake Requests',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CustomCakeScreen(),
                  ),
                );
              },
            ),

            ProfileItem(
              icon: Icons.location_on_outlined,
              title: 'My Address',
              onTap: _openAddresses,
            ),

            const SizedBox(height: 8),

            // ==================================================
            // SETTINGS
            // ==================================================

            ProfileItem(
              icon: Icons.settings_outlined,
              title: 'Settings',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SettingsScreen(),
                  ),
                );
              },
            ),

            // ==================================================
            // HELP & SUPPORT
            // ==================================================

            ProfileItem(
              icon: Icons.help_outline,
              title: 'Help & Support',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HelpSupportScreen(),
                  ),
                );
              },
            ),

            // ==================================================
            // LOGOUT
            // ==================================================

            ProfileItem(
              icon: Icons.logout,
              title: 'Logout',
              isDanger: true,
              onTap: _showLogoutDialog,
            ),

            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// ADDRESS MODEL
// ============================================================

class AddressModel {
  final String id;
  final String title;
  final String address;
  final String phone;
  bool isDefault;

  AddressModel({
    required this.id,
    required this.title,
    required this.address,
    required this.phone,
    this.isDefault = false,
  });
}

// ============================================================
// ADDRESSES SCREEN
// ============================================================

class AddressesScreen extends StatefulWidget {
  final List<AddressModel> addresses;
  final ValueChanged<List<AddressModel>> onAddressesChanged;

  const AddressesScreen({
    super.key,
    required this.addresses,
    required this.onAddressesChanged,
  });

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  late List<AddressModel> _addresses;

  @override
  void initState() {
    super.initState();
    _addresses = List<AddressModel>.from(widget.addresses);
  }

  bool get _isDark {
    return context.read<UserThemeProvider>().themeMode == ThemeMode.dark;
  }

  void _notifyParent() {
    widget.onAddressesChanged(
      List<AddressModel>.from(_addresses),
    );
  }

  // ============================================================
  // SET DEFAULT
  // ============================================================

  void _setDefault(int index) {
    setState(() {
      for (int i = 0; i < _addresses.length; i++) {
        _addresses[i].isDefault = i == index;
      }
    });

    _notifyParent();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Default address updated'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ============================================================
  // DELETE
  // ============================================================

  void _deleteAddress(int index) {
    final bool wasDefault = _addresses[index].isDefault;

    setState(() {
      _addresses.removeAt(index);

      if (wasDefault && _addresses.isNotEmpty) {
        _addresses.first.isDefault = true;
      }
    });

    _notifyParent();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Address deleted successfully'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ============================================================
  // ADD / EDIT ADDRESS
  // ============================================================

  void _showAddressForm({
    AddressModel? existing,
    int? index,
  }) {
    final bool isDark = _isDark;

    final TextEditingController titleController = TextEditingController(
      text: existing?.title ?? '',
    );

    final TextEditingController addressController = TextEditingController(
      text: existing?.address ?? '',
    );

    final TextEditingController phoneController = TextEditingController(
      text: existing?.phone ?? '',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF211714) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 12,
              bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 20,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: _SheetHandle(),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.brown : AppColors.peach,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(
                          Icons.location_on_outlined,
                          color: isDark ? AppColors.gold : AppColors.brown,
                        ),
                      ),
                      const SizedBox(width: 13),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              existing == null
                                  ? 'Add New Address'
                                  : 'Edit Address',
                              style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : AppColors.brown,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'Enter your delivery details',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? Colors.white60 : AppColors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  _AddressTextField(
                    controller: titleController,
                    label: 'Address Title',
                    hint: 'Home, Office, etc.',
                    icon: Icons.bookmark_border,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 14),
                  _AddressTextField(
                    controller: addressController,
                    label: 'Complete Address',
                    hint: 'House, Street, Area, City',
                    icon: Icons.location_on_outlined,
                    isDark: isDark,
                    maxLines: 4,
                  ),
                  const SizedBox(height: 14),
                  _AddressTextField(
                    controller: phoneController,
                    label: 'Phone Number',
                    hint: '+92 300 1234567',
                    icon: Icons.phone_outlined,
                    isDark: isDark,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 22),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF33231D)
                          : const Color(0xFFFFF5EC),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: isDark ? Colors.white10 : AppColors.peach,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 19,
                          color: isDark ? AppColors.gold : AppColors.brown,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Please provide an accurate address so your cake can be delivered without delay.',
                            style: TextStyle(
                              fontSize: 12,
                              height: 1.4,
                              color: isDark ? Colors.white70 : Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor:
                            isDark ? AppColors.gold : AppColors.brown,
                        foregroundColor:
                            isDark ? AppColors.brown : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      icon: Icon(
                        existing == null
                            ? Icons.add_location_alt_outlined
                            : Icons.save_outlined,
                      ),
                      label: Text(
                        existing == null ? 'Save Address' : 'Save Changes',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      onPressed: () {
                        final String title = titleController.text.trim();
                        final String address = addressController.text.trim();
                        final String phone = phoneController.text.trim();

                        if (title.isEmpty || address.isEmpty || phone.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please complete all fields'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          return;
                        }

                        setState(() {
                          if (existing == null) {
                            final bool firstAddress = _addresses.isEmpty;

                            _addresses.add(
                              AddressModel(
                                id: DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString(),
                                title: title,
                                address: address,
                                phone: phone,
                                isDefault: firstAddress,
                              ),
                            );
                          } else {
                            _addresses[index!] = AddressModel(
                              id: existing.id,
                              title: title,
                              address: address,
                              phone: phone,
                              isDefault: existing.isDefault,
                            );
                          }
                        });

                        _notifyParent();

                        Navigator.pop(sheetContext);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              existing == null
                                  ? 'Address added successfully'
                                  : 'Address updated successfully',
                            ),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );

                        titleController.dispose();
                        addressController.dispose();
                        phoneController.dispose();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // DELETE DIALOG
  // ============================================================

  void _showDeleteAddressDialog(int index) {
    final bool isDark = _isDark;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF261D19) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.10),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Delete Address',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.brown,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to delete this address?',
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.pop(dialogContext);
                _deleteAddress(index);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final bool isDark = _isDark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF1B1411) : const Color(0xFFFFFAF6),
      appBar: AppBar(
        elevation: 0,
        backgroundColor:
            isDark ? const Color(0xFF3A251C) : const Color(0xFFFFFAF6),
        foregroundColor: isDark ? Colors.white : AppColors.brown,
        centerTitle: false,
        titleSpacing: 0,
        title: const Text(
          'Delivery Address',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 19,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: isDark ? AppColors.gold : AppColors.brown,
        foregroundColor: isDark ? AppColors.brown : Colors.white,
        elevation: 4,
        onPressed: _showAddressForm,
        icon: const Icon(
          Icons.add_location_alt_outlined,
        ),
        label: const Text(
          'Add Address',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _addresses.isEmpty
          ? _EmptyAddresses(
              isDark: isDark,
              onAdd: _showAddressForm,
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(
                16,
                18,
                16,
                110,
              ),
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDark
                          ? const [
                              Color(0xFF3A251C),
                              Color(0xFF261D19),
                            ]
                          : const [
                              Color(0xFFFFF2E7),
                              Color(0xFFFFFAF6),
                            ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark ? Colors.white10 : AppColors.peach,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.brown : AppColors.peach,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.local_shipping_outlined,
                          size: 27,
                          color: isDark ? AppColors.gold : AppColors.brown,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Where should we deliver?',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : AppColors.brown,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Save your delivery addresses for a faster checkout.',
                              style: TextStyle(
                                fontSize: 12,
                                height: 1.4,
                                color: isDark ? Colors.white70 : AppColors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Text(
                      'Saved Addresses',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.brown,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${_addresses.length} saved',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? Colors.white54 : AppColors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...List.generate(
                  _addresses.length,
                  (index) {
                    final AddressModel address = _addresses[index];

                    return _AddressCard(
                      address: address,
                      isDark: isDark,
                      onDefault: () => _setDefault(index),
                      onEdit: () {
                        _showAddressForm(
                          existing: address,
                          index: index,
                        );
                      },
                      onDelete: () {
                        _showDeleteAddressDialog(index);
                      },
                    );
                  },
                ),
              ],
            ),
    );
  }
}

// ============================================================
// ADDRESS CARD
// ============================================================

class _AddressCard extends StatelessWidget {
  final AddressModel address;
  final bool isDark;
  final VoidCallback onDefault;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _AddressCard({
    required this.address,
    required this.isDark,
    required this.onDefault,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF261D19) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: address.isDefault
              ? AppColors.gold
              : isDark
                  ? Colors.white10
                  : Colors.black12,
          width: address.isDefault ? 1.5 : 1,
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(17),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.brown : AppColors.peach,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    address.title.toLowerCase() == 'office'
                        ? Icons.business_outlined
                        : Icons.home_outlined,
                    color: isDark ? AppColors.gold : AppColors.brown,
                    size: 23,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              address.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : AppColors.brown,
                              ),
                            ),
                          ),
                          if (address.isDefault) ...[
                            const SizedBox(width: 7),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.gold.withOpacity(0.18),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'DEFAULT',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isDark ? AppColors.gold : AppColors.brown,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Delivery address',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? Colors.white54 : AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    color: isDark ? Colors.white60 : AppColors.grey,
                  ),
                  onSelected: (value) {
                    if (value == 'edit') {
                      onEdit();
                    } else if (value == 'delete') {
                      onDelete();
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined),
                          SizedBox(width: 10),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                          SizedBox(width: 10),
                          Text('Delete'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 17),
            Divider(
              height: 1,
              color: isDark ? Colors.white10 : Colors.black12,
            ),
            const SizedBox(height: 15),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 20,
                  color: isDark ? AppColors.gold : AppColors.brown,
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    address.address,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.45,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  Icons.phone_outlined,
                  size: 19,
                  color: isDark ? AppColors.gold : AppColors.brown,
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    address.phone,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (!address.isDefault)
              SizedBox(
                width: double.infinity,
                height: 42,
                child: OutlinedButton.icon(
                  onPressed: onDefault,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: isDark ? AppColors.gold : AppColors.brown,
                    side: BorderSide(
                      color: isDark ? AppColors.gold : AppColors.brown,
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(
                    Icons.check_circle_outline,
                    size: 18,
                  ),
                  label: const Text(
                    'Set as Default Address',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
            else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 11,
                ),
                decoration: BoxDecoration(
                  color: AppColors.gold.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: AppColors.gold,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Default Address',
                      style: TextStyle(
                        color: isDark ? AppColors.gold : AppColors.brown,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// EMPTY ADDRESSES
// ============================================================

class _EmptyAddresses extends StatelessWidget {
  final bool isDark;
  final VoidCallback onAdd;

  const _EmptyAddresses({
    required this.isDark,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: isDark ? AppColors.brown : AppColors.peach,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.location_on_outlined,
                size: 48,
                color: isDark ? AppColors.gold : AppColors.brown,
              ),
            ),
            const SizedBox(height: 22),
            Text(
              'No Address Saved',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.brown,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add your delivery address to make your cake orders faster and easier.',
              textAlign: TextAlign.center,
              style: TextStyle(
                height: 1.5,
                fontSize: 13,
                color: isDark ? Colors.white60 : AppColors.grey,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onAdd,
              style: FilledButton.styleFrom(
                backgroundColor: isDark ? AppColors.gold : AppColors.brown,
                foregroundColor: isDark ? AppColors.brown : Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 13,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(
                Icons.add_location_alt_outlined,
              ),
              label: const Text(
                'Add New Address',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// ADDRESS TEXT FIELD
// ============================================================

class _AddressTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final bool isDark;
  final int maxLines;
  final TextInputType? keyboardType;

  const _AddressTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    required this.isDark,
    this.maxLines = 1,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: TextStyle(
        color: isDark ? Colors.white : Colors.black87,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Padding(
          padding: const EdgeInsets.only(
            left: 4,
            right: 4,
          ),
          child: Icon(
            icon,
            color: isDark ? AppColors.gold : AppColors.brown,
          ),
        ),
        filled: true,
        fillColor: isDark ? const Color(0xFF33231D) : const Color(0xFFF9F3ED),
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
          borderSide: const BorderSide(
            color: AppColors.gold,
            width: 2,
          ),
        ),
      ),
    );
  }
}

// ============================================================
// PROFILE ITEM
// ============================================================

class ProfileItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDanger;

  const ProfileItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark =
        context.watch<UserThemeProvider>().themeMode == ThemeMode.dark;

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 22,
        vertical: 1,
      ),
      minLeadingWidth: 28,
      leading: Icon(
        icon,
        size: 21,
        color: isDanger
            ? Colors.red
            : isDark
                ? AppColors.gold
                : AppColors.brown,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          color: isDanger
              ? Colors.red
              : isDark
                  ? Colors.white
                  : AppColors.brown,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        size: 19,
        color: isDark ? Colors.white54 : AppColors.grey,
      ),
    );
  }
}

// ============================================================
// OPTION TILE
// ============================================================

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isDark;
  final bool isDanger;
  final VoidCallback onTap;

  const _OptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isDark,
    required this.onTap,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color iconColor = isDanger
        ? Colors.red
        : isDark
            ? AppColors.gold
            : AppColors.brown;

    return Material(
      color: isDark ? const Color(0xFF33231D) : const Color(0xFFF9F3ED),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 9,
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: isDanger
                      ? Colors.red.withOpacity(0.10)
                      : isDark
                          ? AppColors.brown
                          : AppColors.peach.withOpacity(0.55),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: iconColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDanger
                            ? Colors.red
                            : isDark
                                ? Colors.white
                                : AppColors.brown,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? Colors.white60 : AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 5),
              Icon(
                Icons.chevron_right,
                size: 19,
                color: isDark ? Colors.white54 : AppColors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// SETTINGS SCREEN
// ============================================================

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool orderNotifications = true;
  bool promotionalNotifications = false;
  bool locationServices = true;

  bool get isDark =>
      context.watch<UserThemeProvider>().themeMode == ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor =
        isDark ? const Color(0xFF1B1411) : const Color(0xFFFFFAF6);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor:
            isDark ? const Color(0xFF3A251C) : const Color(0xFFFFFAF6),
        foregroundColor: isDark ? Colors.white : AppColors.brown,
        title: const Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 19,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          16,
          18,
          16,
          30,
        ),
        children: [
          _SettingsSectionTitle(
            title: 'Appearance',
            isDark: isDark,
          ),
          const SizedBox(height: 10),
          _SettingsCard(
            isDark: isDark,
            child: _SettingsTile(
              icon: Icons.palette_outlined,
              title: 'Dark Mode',
              subtitle: isDark
                  ? 'Dark mode is currently active'
                  : 'Light mode is currently active',
              isDark: isDark,
              trailing: Switch(
                value: isDark,
                activeColor: AppColors.gold,
                onChanged: (value) {
                  context.read<UserThemeProvider>().setTheme(
                        value ? ThemeMode.dark : ThemeMode.light,
                      );
                },
              ),
            ),
          ),
          const SizedBox(height: 22),
          _SettingsSectionTitle(
            title: 'Notifications',
            isDark: isDark,
          ),
          const SizedBox(height: 10),
          _SettingsCard(
            isDark: isDark,
            child: Column(
              children: [
                _SettingsTile(
                  icon: Icons.shopping_bag_outlined,
                  title: 'Order Updates',
                  subtitle: 'Receive updates about your cake orders',
                  isDark: isDark,
                  trailing: Switch(
                    value: orderNotifications,
                    activeColor: AppColors.gold,
                    onChanged: (value) {
                      setState(() {
                        orderNotifications = value;
                      });
                    },
                  ),
                ),
                Divider(
                  height: 1,
                  color: isDark ? Colors.white10 : Colors.black12,
                ),
                _SettingsTile(
                  icon: Icons.campaign_outlined,
                  title: 'Promotional Notifications',
                  subtitle: 'Get updates about offers and new cakes',
                  isDark: isDark,
                  trailing: Switch(
                    value: promotionalNotifications,
                    activeColor: AppColors.gold,
                    onChanged: (value) {
                      setState(() {
                        promotionalNotifications = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          _SettingsSectionTitle(
            title: 'Privacy & Location',
            isDark: isDark,
          ),
          const SizedBox(height: 10),
          _SettingsCard(
            isDark: isDark,
            child: Column(
              children: [
                _SettingsTile(
                  icon: Icons.location_on_outlined,
                  title: 'Location Services',
                  subtitle: 'Allow location for delivery assistance',
                  isDark: isDark,
                  trailing: Switch(
                    value: locationServices,
                    activeColor: AppColors.gold,
                    onChanged: (value) {
                      setState(() {
                        locationServices = value;
                      });
                    },
                  ),
                ),
                Divider(
                  height: 1,
                  color: isDark ? Colors.white10 : Colors.black12,
                ),
                _SettingsTile(
                  icon: Icons.lock_outline,
                  title: 'Privacy',
                  subtitle: 'Manage your privacy preferences',
                  isDark: isDark,
                  trailing: Icon(
                    Icons.chevron_right,
                    color: isDark ? Colors.white54 : AppColors.grey,
                  ),
                  onTap: () {
                    _showInfoDialog(
                      'Privacy',
                      'Your personal information is used only to provide and improve your Divine Craving experience.',
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          _SettingsSectionTitle(
            title: 'App Information',
            isDark: isDark,
          ),
          const SizedBox(height: 10),
          _SettingsCard(
            isDark: isDark,
            child: Column(
              children: [
                _SettingsTile(
                  icon: Icons.info_outline,
                  title: 'About Divine Craving',
                  subtitle: 'Learn more about the app',
                  isDark: isDark,
                  trailing: Icon(
                    Icons.chevron_right,
                    color: isDark ? Colors.white54 : AppColors.grey,
                  ),
                  onTap: () {
                    _showInfoDialog(
                      'About Divine Craving',
                      'Divine Craving is your online cake ordering app. Discover delicious cakes, customize your cake and manage your orders easily.',
                    );
                  },
                ),
                Divider(
                  height: 1,
                  color: isDark ? Colors.white10 : Colors.black12,
                ),
                _SettingsTile(
                  icon: Icons.verified_outlined,
                  title: 'App Version',
                  subtitle: 'Version 1.0.0',
                  isDark: isDark,
                  trailing: const SizedBox.shrink(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          Center(
            child: Text(
              'Divine Craving',
              style: TextStyle(
                color: isDark ? Colors.white38 : AppColors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog(
    String title,
    String message,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF261D19) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: Text(
            title,
            style: TextStyle(
              color: isDark ? Colors.white : AppColors.brown,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            message,
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.black87,
              height: 1.5,
            ),
          ),
          actions: [
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: isDark ? AppColors.gold : AppColors.brown,
                foregroundColor: isDark ? AppColors.brown : Colors.white,
              ),
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

// ============================================================
// HELP & SUPPORT SCREEN
// ============================================================

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark =
        context.watch<UserThemeProvider>().themeMode == ThemeMode.dark;

    final Color backgroundColor =
        isDark ? const Color(0xFF1B1411) : const Color(0xFFFFFAF6);

    final Color primaryColor = isDark ? AppColors.gold : AppColors.brown;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor:
            isDark ? const Color(0xFF3A251C) : const Color(0xFFFFFAF6),
        foregroundColor: isDark ? Colors.white : AppColors.brown,
        title: const Text(
          'Help & Support',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 19,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          16,
          18,
          16,
          30,
        ),
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? const [
                        Color(0xFF3A251C),
                        Color(0xFF261D19),
                      ]
                    : const [
                        Color(0xFFFFF2E7),
                        Color(0xFFFFFAF6),
                      ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? Colors.white10 : AppColors.peach,
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.brown : AppColors.peach,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.support_agent_outlined,
                    size: 34,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'How can we help?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.brown,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Find answers to common questions or contact our support team.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.5,
                    color: isDark ? Colors.white70 : AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _SettingsSectionTitle(
            title: 'Quick Help',
            isDark: isDark,
          ),
          const SizedBox(height: 10),
          _SettingsCard(
            isDark: isDark,
            child: Column(
              children: [
                _HelpTile(
                  icon: Icons.shopping_bag_outlined,
                  title: 'How to Order?',
                  subtitle: 'Learn how to order your favorite cake',
                  isDark: isDark,
                  onTap: () {
                    _showHelpDialog(
                      context,
                      isDark,
                      'How to Order?',
                      'Choose a cake from the app, open its details, select your preferred size and flavor, then place your order.',
                    );
                  },
                ),
                Divider(
                  height: 1,
                  color: isDark ? Colors.white10 : Colors.black12,
                ),
                _HelpTile(
                  icon: Icons.local_shipping_outlined,
                  title: 'Delivery Information',
                  subtitle: 'Learn about cake delivery',
                  isDark: isDark,
                  onTap: () {
                    _showHelpDialog(
                      context,
                      isDark,
                      'Delivery Information',
                      'Make sure your delivery address and phone number are correct. You can save multiple addresses from My Address.',
                    );
                  },
                ),
                Divider(
                  height: 1,
                  color: isDark ? Colors.white10 : Colors.black12,
                ),
                _HelpTile(
                  icon: Icons.cake_outlined,
                  title: 'Custom Cake',
                  subtitle: 'Need a special cake?',
                  isDark: isDark,
                  onTap: () {
                    _showHelpDialog(
                      context,
                      isDark,
                      'Custom Cake',
                      'Use the Custom Cake Requests section to submit your requirements for a personalized cake.',
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          _SettingsSectionTitle(
            title: 'Frequently Asked Questions',
            isDark: isDark,
          ),
          const SizedBox(height: 10),
          _SettingsCard(
            isDark: isDark,
            child: Column(
              children: [
                _FaqTile(
                  question: 'Can I save multiple addresses?',
                  answer:
                      'Yes. You can save multiple delivery addresses and select one as your default address.',
                  isDark: isDark,
                ),
                _FaqTile(
                  question: 'Can I request a custom cake?',
                  answer:
                      'Yes. Open Custom Cake Requests from your profile and provide your cake requirements.',
                  isDark: isDark,
                ),
                _FaqTile(
                  question: 'How can I change my profile?',
                  answer:
                      'Open your Profile page and use the edit option to change your name, email or profile picture.',
                  isDark: isDark,
                ),
                _FaqTile(
                  question: 'How can I change the theme?',
                  answer:
                      'Open Settings and use the Dark Mode switch to change the app theme.',
                  isDark: isDark,
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          _SettingsSectionTitle(
            title: 'Contact Support',
            isDark: isDark,
          ),
          const SizedBox(height: 10),
          _SettingsCard(
            isDark: isDark,
            child: Column(
              children: [
                _HelpTile(
                  icon: Icons.email_outlined,
                  title: 'Email Support',
                  subtitle: 'Get help from our support team',
                  isDark: isDark,
                  onTap: () {
                    _showHelpDialog(
                      context,
                      isDark,
                      'Email Support',
                      'Please contact Divine Craving support through the official support email provided by the app.',
                    );
                  },
                ),
                Divider(
                  height: 1,
                  color: isDark ? Colors.white10 : Colors.black12,
                ),
                _HelpTile(
                  icon: Icons.feedback_outlined,
                  title: 'Send Feedback',
                  subtitle: 'Tell us how we can improve the app',
                  isDark: isDark,
                  onTap: () {
                    _showHelpDialog(
                      context,
                      isDark,
                      'Send Feedback',
                      'Thank you for helping us improve Divine Craving. Your feedback is valuable to us.',
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(
    BuildContext context,
    bool isDark,
    String title,
    String message,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF261D19) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: Text(
            title,
            style: TextStyle(
              color: isDark ? Colors.white : AppColors.brown,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            message,
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.black87,
              height: 1.5,
            ),
          ),
          actions: [
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: isDark ? AppColors.gold : AppColors.brown,
                foregroundColor: isDark ? AppColors.brown : Colors.white,
              ),
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

// ============================================================
// SETTINGS SECTION TITLE
// ============================================================

class _SettingsSectionTitle extends StatelessWidget {
  final String title;
  final bool isDark;

  const _SettingsSectionTitle({
    required this.title,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: isDark ? Colors.white70 : AppColors.grey,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

// ============================================================
// SETTINGS CARD
// ============================================================

class _SettingsCard extends StatelessWidget {
  final bool isDark;
  final Widget child;

  const _SettingsCard({
    required this.isDark,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF261D19) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.black12,
        ),
      ),
      child: child,
    );
  }
}

// ============================================================
// SETTINGS TILE
// ============================================================

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isDark;
  final Widget trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isDark,
    required this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 5,
      ),
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: isDark ? AppColors.brown : AppColors.peach.withOpacity(0.55),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: isDark ? AppColors.gold : AppColors.brown,
          size: 21,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : AppColors.brown,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 11,
          color: isDark ? Colors.white60 : AppColors.grey,
        ),
      ),
      trailing: trailing,
    );
  }
}

// ============================================================
// HELP TILE
// ============================================================

class _HelpTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isDark;
  final VoidCallback onTap;

  const _HelpTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 5,
      ),
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: isDark ? AppColors.brown : AppColors.peach.withOpacity(0.55),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: isDark ? AppColors.gold : AppColors.brown,
          size: 21,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : AppColors.brown,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 11,
          color: isDark ? Colors.white60 : AppColors.grey,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: isDark ? Colors.white54 : AppColors.grey,
      ),
    );
  }
}

// ============================================================
// FAQ TILE
// ============================================================

class _FaqTile extends StatelessWidget {
  final String question;
  final String answer;
  final bool isDark;

  const _FaqTile({
    required this.question,
    required this.answer,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(
        horizontal: 15,
      ),
      iconColor: isDark ? AppColors.gold : AppColors.brown,
      collapsedIconColor: isDark ? Colors.white54 : AppColors.grey,
      title: Text(
        question,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : AppColors.brown,
        ),
      ),
      childrenPadding: const EdgeInsets.fromLTRB(
        15,
        0,
        15,
        15,
      ),
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            answer,
            style: TextStyle(
              fontSize: 12,
              height: 1.5,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// SHEET HANDLE
// ============================================================

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.4),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

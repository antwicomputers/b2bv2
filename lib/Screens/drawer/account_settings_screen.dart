import 'dart:typed_data';
import 'package:b2bmobile/providers/user_provider.dart';
import 'package:b2bmobile/resources/storage_methods.dart';
import 'package:b2bmobile/utils/colors.dart';
import 'package:b2bmobile/utils/utils.dart';
import 'package:b2bmobile/utils/categories.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import '../authenticate/login_screen.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _updateProfilePic() async {
    Uint8List? image = await pickImage(ImageSource.gallery);
    if (image != null) {
      setState(() => _isLoading = true);
      try {
        String photoUrl = await StorageMethods().uploadImageToStorage('profilePics', image, false);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({'photoUrl': photoUrl});
        
        if (mounted) {
          showSnackBar("Profile picture updated!", context);
        }
      } catch (e) {
        if (mounted) showSnackBar(e.toString(), context);
      }
      setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleInterest(String category, bool currentStatus) async {
    setState(() => _isLoading = true);
    try {
      if (currentStatus) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          'interests': FieldValue.arrayRemove([category])
        });
      } else {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          'interests': FieldValue.arrayUnion([category])
        });
      }
    } catch (e) {
      if (mounted) showSnackBar(e.toString(), context);
    }
    setState(() => _isLoading = false);
  }

  Future<void> _updateField(String field, String value) async {
    if (value.trim().isEmpty) return;
    setState(() => _isLoading = true);
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({field: value});
      if (mounted) showSnackBar("$field updated!", context);
    } catch (e) {
      if (mounted) showSnackBar(e.toString(), context);
    }
    setState(() => _isLoading = false);
  }

  Future<void> _sendPasswordReset() async {
    final email = FirebaseAuth.instance.currentUser?.email;
    if (email == null) return;
    
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: mobileBackgroundColor,
            title: const Text("Reset Link Sent"),
            content: Text("A password reset link has been sent to $email. Please check your inbox."),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) showSnackBar(e.toString(), context);
    }
  }

  Future<void> _deleteAccount() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).delete();
      await user.delete();
      Get.offAll(() => const LoginScreen());
      Get.snackbar("Account Deleted", "Your data has been removed.", backgroundColor: Colors.red, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", "Please logout and login again before deleting for security.", backgroundColor: Colors.amber);
    }
  }

  void _showEditDialog(String title, String field, String initialValue) {
    final controller = TextEditingController(text: initialValue);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: mobileBackgroundColor,
        title: Text("Edit $title"),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: "Enter new $title"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              _updateField(field, controller.text);
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.userModel;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile & Account'),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: Colors.blueAccent))
        : user == null 
          ? const Center(child: Text("No User Found"))
          : ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [
                const SizedBox(height: 30),
                // Profile Pic Section
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 64,
                        backgroundImage: NetworkImage(user.photoUrl),
                        backgroundColor: Colors.grey.shade900,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          radius: 20,
                          child: IconButton(
                            icon: const Icon(Icons.add_a_photo, size: 18, color: Colors.white),
                            onPressed: _updateProfilePic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    user.tier,
                    style: const TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Personal Info Section
                _buildSectionTitle("Personal Information"),
                _buildSettingTile(
                  icon: Icons.person_outline,
                  title: "Full Name",
                  subtitle: user.fullname,
                  onTap: () => _showEditDialog("Full Name", "fullname", user.fullname),
                ),
                _buildSettingTile(
                  icon: Icons.alternate_email,
                  title: "Username",
                  subtitle: "@${user.username}",
                  onTap: () => _showEditDialog("Username", "username", user.username),
                ),
                const SizedBox(height: 32),

                // AI Matchmaking Interests
                _buildSectionTitle("Discovery Interests", color: Colors.blueAccent),
                const Text(
                  "Select categories to personalize your marketplace experience.",
                  style: TextStyle(color: Colors.white38, fontSize: 11),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 44,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: appCategories.length,
                    itemBuilder: (context, index) {
                      final category = appCategories[index];
                      final isSelected = user.interests.contains(category);
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          selectedColor: Colors.blueAccent.withValues(alpha: 0.2),
                          checkmarkColor: Colors.blueAccent,
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (val) => _toggleInterest(category, isSelected),
                          backgroundColor: Colors.grey.shade900,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.blueAccent : Colors.white70,
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: isSelected ? Colors.blueAccent : Colors.white10),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 32),

                // Security Section
                _buildSectionTitle("Security"),
                _buildSettingTile(
                  icon: Icons.lock_outline_rounded,
                  title: "Change Password",
                  subtitle: "Send reset link to your email",
                  onTap: _sendPasswordReset,
                ),

                const SizedBox(height: 32),

                // Danger Zone
                _buildSectionTitle("Danger Zone", color: Colors.redAccent),
                _buildSettingTile(
                  icon: Icons.delete_forever_outlined,
                  title: "Delete Account",
                  subtitle: "Permanently remove your data",
                  color: Colors.redAccent,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: mobileBackgroundColor,
                        title: const Text("Final Warning"),
                        content: const Text("This will permanently delete your community profile and all activity. This cannot be reversed."),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                            onPressed: _deleteAccount,
                            child: const Text("Delete Everything"),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 60),
              ],
            ),
    );
  }

  Widget _buildSectionTitle(String title, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: color ?? Colors.grey.shade600,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    Color? color,
    Widget? trailing,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade900.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: color ?? Colors.white70),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: TextStyle(color: (color ?? Colors.white).withValues(alpha: 0.5))),
        trailing: trailing ?? Icon(Icons.chevron_right, color: Colors.grey.shade700),
      ),
    );
  }
}

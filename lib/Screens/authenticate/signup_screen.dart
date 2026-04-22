// import 'dart:typed_data'; // unnecessary import provided by services.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import 'package:b2bmobile/Screens/authenticate/login_screen.dart';
import 'package:b2bmobile/providers/user_provider.dart';
import 'package:b2bmobile/utils/colors.dart';
import 'package:b2bmobile/utils/utils.dart';
import 'package:b2bmobile/widgets/text_field_input.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:b2bmobile/widgets/verification_puzzle.dart';
import 'package:get/get.dart';

import '../../responsive/mobile_screen_layout.dart';
import '../../responsive/responsive_layout_screen.dart';
import '../../responsive/web_screen_layout.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<SignupScreen> {
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _verifyEmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _verifyPasswordController =
      TextEditingController();
  final TextEditingController _userName = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;
  bool _isVerified = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _verifyEmailController.dispose();
    _passwordController.dispose();
    _verifyPasswordController.dispose();
    _userName.dispose();
    _fullName.dispose();
  }

  Future<void> selectImage() async {
    Uint8List? im = await pickImage(ImageSource.gallery);
    if (im != null) {
      // set state because we need to display the image we selected on the circle avatar
      setState(() {
        _image = im;
      });
    }
  }

  void navigateToLogin() {
    Get.off(() => const LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Obsidian background
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 24), // Push down from the very top
              // Full-Width Banner Header
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.25,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/b2b_app_icon_normalized.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Padded Screen Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'JOIN THE NETWORK',
                    style: GoogleFonts.bebasNeue(
                      fontSize: 32,
                      letterSpacing: 2.5,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Premium B2B Community',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: const Color(0xFFC0C0C0),
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Avatar
                  Stack(
                    children: [
                      _image != null
                          ? CircleAvatar(
                              radius: 54,
                              backgroundImage: MemoryImage(_image!),
                              backgroundColor: const Color(0xFF141414),
                            )
                          : const CircleAvatar(
                              radius: 54,
                              backgroundColor: Color(0xFF141414),
                              child: Icon(Icons.person, size: 54, color: Colors.white24),
                            ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: selectImage,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFC0C0C0),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black, width: 2),
                            ),
                            child: const Icon(Icons.camera_alt, color: Colors.black, size: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Inputs
                  _buildModernInput(hintText: 'Enter your Full Name', controller: _fullName, type: TextInputType.name, icon: Icons.badge_outlined),
                  const SizedBox(height: 20),
                  _buildModernInput(hintText: 'Enter Username', controller: _userName, type: TextInputType.text, icon: Icons.alternate_email),
                  const SizedBox(height: 20),
                  _buildModernInput(hintText: 'Enter Your Email Address', controller: _emailController, type: TextInputType.emailAddress, icon: Icons.email_outlined),
                  const SizedBox(height: 20),
                  _buildModernInput(hintText: 'Verify Your Email Address', controller: _verifyEmailController, type: TextInputType.emailAddress, icon: Icons.mark_email_read_outlined),
                  const SizedBox(height: 20),
                  _buildModernInput(hintText: 'Enter Your Password', controller: _passwordController, type: TextInputType.text, icon: Icons.lock_outline, isPass: true),
                  const SizedBox(height: 20),
                  _buildModernInput(hintText: 'Verify Your Password', controller: _verifyPasswordController, type: TextInputType.text, icon: Icons.lock_reset_outlined, isPass: true),
                  
                  const SizedBox(height: 32),
                  
                  // Verification Puzzle
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF141414),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF2A2A2A)),
                    ),
                    child: VerificationPuzzle(onVerified: (val) => setState(() => _isVerified = val)),
                  ),
                  
                  const SizedBox(height: 32),

                  // Submit Button
                  Consumer<UserProvider>(
                    builder: (context, value, child) => InkWell(
                      onTap: () async {
                        if (!_isVerified) {
                          showSnackBar("Please slide to verify you are human.", context);
                          return;
                        }
                        setState(() {
                          _isLoading = true;
                        });
                        try {
                          Uint8List fileData = _image ??
                              (await rootBundle.load('assets/default_profile.png'))
                                  .buffer
                                  .asUint8List();

                          String res = await value.signUpUser(
                            email: _emailController.text,
                            password: _passwordController.text,
                            fullname: _fullName.text,
                            username: _userName.text,
                            file: fileData,
                          );

                          if (res != 'success') {
                            if (!context.mounted) return;
                            showSnackBar(res, context);
                          } else {
                            if (!context.mounted) return;
                            Get.offAll(() => const ResponsiveLayout(
                              mobileScreenLayout: MobileScreenLayout(),
                              webScreenLayout: WebScreenLayout(),
                            ));
                          }
                        } on FirebaseAuthException catch (e) {
                          if (!context.mounted) return;
                          showSnackBar("Auth Error: ${e.code} - ${e.message}", context);
                        } catch (e) {
                          if (!context.mounted) return;
                          showSnackBar("Error: ${e.toString()}", context);
                        } finally {
                          if (mounted) {
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        }
                      },
                      child: _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFFC0C0C0),
                              ),
                            )
                          : Container(
                              width: double.infinity,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: ShapeDecoration(
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                                color: _isVerified ? const Color(0xFFC0C0C0) : const Color(0xFF141414),
                              ),
                              child: Text(
                                  'Sign Up to the Network',
                                  style: TextStyle(
                                    color: _isVerified ? Colors.black : Colors.white24,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  )
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 40),
                  // Transition to sign in
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account? ", style: TextStyle(color: Colors.white54)),
                      GestureDetector(
                        onTap: navigateToLogin,
                        child: const Text(
                          "Sign In",
                          style: TextStyle(color: Color(0xFFC0C0C0), fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildModernInput({required String hintText, required TextEditingController controller, required TextInputType type, required IconData icon, bool isPass = false}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPass,
        keyboardType: type,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.white38),
          prefixIcon: Icon(icon, color: Colors.white54, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}

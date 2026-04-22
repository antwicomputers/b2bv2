import 'package:b2bmobile/Screens/authenticate/signup_screen.dart';
import 'package:b2bmobile/providers/user_provider.dart';
import 'package:b2bmobile/utils/colors.dart';
import 'package:b2bmobile/utils/utils.dart';
import 'package:b2bmobile/widgets/text_field_input.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

import '../../responsive/mobile_screen_layout.dart';
import '../../responsive/responsive_layout_screen.dart';
import '../../responsive/web_screen_layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void navigateToSignUp() {
    Get.off(() => const SignupScreen());
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
                    'BACK 2 BLACK',
                    style: GoogleFonts.bebasNeue(
                      fontSize: 32,
                      letterSpacing: 2.5,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Premium Business Network',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: const Color(0xFFC0C0C0), // Silver Theme
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Email Input
                  _buildModernInput(hintText: 'Enter Your Email', controller: _emailController, type: TextInputType.emailAddress, icon: Icons.email_outlined),
                  const SizedBox(height: 20),
                  
                  // Password Input
                  _buildModernInput(hintText: 'Enter Your Password', controller: _passwordController, type: TextInputType.text, icon: Icons.lock_outline, isPass: true),
                  const SizedBox(height: 24),

                  // Login Button
                  Consumer<UserProvider>(
                    builder: (context, value, child) => InkWell(
                      onTap: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        String res = await value.loginUser(
                            email: _emailController.text,
                            password: _passwordController.text);

                        if (res == 'success') {
                          // ignore: use_build_context_synchronously
                          Get.offAll(() => const ResponsiveLayout(
                            mobileScreenLayout: MobileScreenLayout(),
                            webScreenLayout: WebScreenLayout(),
                          ));
                        } else {
                          if (!context.mounted) return;
                          showSnackBar(res, context);
                        }
                        setState(() {
                          _isLoading = false;
                        });
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
                              decoration: const ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                                color: Color(0xFFC0C0C0),
                              ),
                              child: const Text('Sign In', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Guest Button
                  Consumer<UserProvider>(
                    builder: (context, value, child) => InkWell(
                      onTap: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        String res = await value.signInAsGuest();
                        if (res == 'success') {
                          Get.offAll(() => const ResponsiveLayout(
                            mobileScreenLayout: MobileScreenLayout(),
                            webScreenLayout: WebScreenLayout(),
                          ));
                        } else {
                          if (!context.mounted) return;
                          showSnackBar(res, context);
                        }
                        setState(() {
                          _isLoading = false;
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: const Color(0xFF141414),
                          border: Border.all(color: const Color(0xFF2A2A2A)),
                        ),
                        child: const Text('Continue as Guest', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Transition to sign up
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? ", style: TextStyle(color: Colors.white54)),
                      GestureDetector(
                        onTap: navigateToSignUp,
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(color: Color(0xFFC0C0C0), fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
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

  Widget _buildSocialIcon(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Icon(icon, color: color, size: 28),
    );
  }
}

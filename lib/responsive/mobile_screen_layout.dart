import 'package:b2bmobile/Screens/admin_panel/admin.dart';
import 'package:b2bmobile/Screens/drawer/alerts.dart';
import 'package:b2bmobile/Screens/drawer/loyalty_card.dart';
import 'package:b2bmobile/Screens/drawer/help_us.dart';
import 'package:b2bmobile/Screens/pages/favorites.dart';
import 'package:b2bmobile/Screens/pages/home.dart';
import 'package:b2bmobile/Screens/pages/maps.dart';
import 'package:b2bmobile/Screens/pages/categories.dart';
import 'package:b2bmobile/Screens/pages/pulse_feed.dart';
import 'package:b2bmobile/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:b2bmobile/Screens/authenticate/login_screen.dart';
import 'package:b2bmobile/Screens/drawer/legal_screen.dart';
import 'package:b2bmobile/Screens/drawer/account_settings_screen.dart';
import 'package:b2bmobile/Screens/pages/ai_concierge_screen.dart';
import 'package:b2bmobile/services/ai_service.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _selectedIndex = 0;

  void navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    const HomePage(),
    const Maps(),
    const PulseFeed(),
    const Favorites(),
    const Categories(),
  ];
  // late model.User user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Consumer<UserProvider>(
          builder: (context, value, child) {
            final user = value.userModel;
            return GestureDetector(
              onLongPress: () {
                if (user != null && user.email == 'info@antwicomputers.com') {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AdminPanel(),
                    ),
                  );
                } else {
                  debugPrint("Admin access check: User is ${user?.email}");
                }
              },
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: const Text('Back2Black Mobile'),
              ),
            );
          },
        ),
        centerTitle: true,
        actions: [
          Consumer<UserProvider>(
            builder: (context, value, child) {
              final user = value.userModel;
              if (user != null && user.isBlack) {
                return IconButton(
                  icon: const Icon(Icons.rocket_launch, color: Colors.blueAccent),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const AIConciergeScreen()),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.black,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  const SizedBox(height: 10),
                  Consumer<UserProvider>(
                    builder: (context, value, child) {
                      final user = value.userModel;
                      if (user != null && user.isBlack) {
                        return _buildItem(
                          icon: Icons.chat_bubble_outline_rounded,
                          title: 'AI Concierge',
                          onTap: () {
                            Get.back();
                            Get.to(() => const AIConciergeScreen());
                          },
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  _buildItem(
                    icon: Icons.credit_card_rounded,
                    title: 'B2B Black Card',
                    onTap: () {
                      Get.back();
                      Get.to(() => const DigitalBlackCardScreen());
                    },
                  ),
                  _buildItem(
                    icon: Icons.notifications_none_rounded,
                    title: 'Alerts',
                    onTap: () {
                      Get.back();
                      Get.to(() => const Alerts());
                    },
                  ),
                  const Divider(color: Colors.white10, height: 32),
                  _buildItem(
                    icon: Icons.info_outline_rounded,
                    title: 'Feedback',
                    onTap: () {
                      Get.back();
                      Get.to(() => const SupportUs());
                    },
                  ),
                  _buildItem(
                    icon: Icons.security_rounded,
                    title: 'Legal & Privacy',
                    onTap: () {
                      Get.back();
                      Get.to(() => const LegalScreen());
                    },
                  ),
                  _buildItem(
                    icon: Icons.manage_accounts_outlined,
                    title: 'Account Settings',
                    onTap: () {
                      Get.back();
                      Get.to(() => const AccountSettingsScreen());
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Consumer<UserProvider>(
                builder: (context, value, child) => _buildItem(
                  icon: Icons.logout_rounded,
                  title: 'Logout',
                  color: Colors.redAccent,
                  onTap: () async {
                    await value.signOut();
                    if (!context.mounted) return;
                    Get.offAll(() => const LoginScreen());
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GNav(
          tabBackgroundColor: Colors.grey.shade900,
          activeColor: Colors.blueAccent,
          gap: 8,
          onTabChange: navigateBottomBar,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          tabs: const [
            GButton(
              icon: Icons.home_rounded,
              text: 'Home',
            ),
            GButton(
              icon: Icons.map_rounded,
              text: 'Map',
            ),
            GButton(
              icon: Icons.play_circle_outline_rounded,
              text: 'Pulse',
            ),
            GButton(
              icon: Icons.favorite_border_rounded,
              text: 'Favs',
            ),
            GButton(
              icon: Icons.more_horiz_rounded,
              text: 'More',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Consumer<UserProvider>(
      builder: (context, value, child) {
        final user = value.userModel;
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.only(top: 60, bottom: 24, left: 24, right: 24),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black, Colors.black], // Can add subtle color if needed
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 35,
                backgroundImage: user != null ? NetworkImage(user.photoUrl) : null,
                backgroundColor: Colors.grey.shade900,
                child: user == null
                    ? const CircularProgressIndicator(color: Colors.blueAccent)
                    : null,
              ),
              const SizedBox(height: 16),
              if (user != null) ...[
                Row(
                  children: [
                    Text(
                      user.fullname,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    if (user.points >= 500) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: (user.points >= 5000 ? Colors.amber : (user.points >= 1500 ? const Color(0xFFD4AF37) : const Color(0xFFC0C0C0))).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: (user.points >= 5000 ? Colors.amber : (user.points >= 1500 ? const Color(0xFFD4AF37) : const Color(0xFFC0C0C0))).withValues(alpha: 0.4)),
                        ),
                        child: Text(
                          user.tier,
                          style: TextStyle(
                            color: user.points >= 5000 ? Colors.amber : (user.points >= 1500 ? const Color(0xFFD4AF37) : const Color(0xFFC0C0C0)),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  user.email,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildItem({
    required IconData icon,
    required String title,
    required GestureTapCallback onTap,
    Color? color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: color?.withValues(alpha: 0.05) ?? Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: onTap,
        dense: true,
        leading: Icon(icon, color: color ?? Colors.blueAccent, size: 22),
        title: Text(
          title,
          style: TextStyle(
            color: color ?? Colors.white.withValues(alpha: 0.9),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

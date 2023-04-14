import 'package:b2bmobile/Screens/admin_panel/admin.dart';
import 'package:b2bmobile/Screens/business/register_business.dart';
import 'package:b2bmobile/Screens/drawer/about_us.dart';
import 'package:b2bmobile/Screens/drawer/alerts.dart';
import 'package:b2bmobile/Screens/drawer/black_kick_start.dart';
import 'package:b2bmobile/Screens/drawer/help_us.dart';
import 'package:b2bmobile/Screens/drawer/mental_health.dart';
import 'package:b2bmobile/Screens/drawer/women.dart';
import 'package:b2bmobile/Screens/pages/favorites.dart';
import 'package:b2bmobile/Screens/pages/home.dart';
import 'package:b2bmobile/Screens/pages/maps.dart';
import 'package:b2bmobile/Screens/pages/categories.dart';
import 'package:b2bmobile/Screens/vew%20all%20events/view_all_events_screen.dart';
import 'package:b2bmobile/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import '../Screens/authenticate/login_screen.dart';
import 'package:b2bmobile/Screens/drawer/register_event.dart';

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
          builder: (context, value, child) => InkWell(
            child: const Text('Back2Black Mobile'),
            onLongPress: () {
              if (value.userModel!.email == 'admin@b2bmobile.com') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AdminPanel(),
                  ),
                );
              }
            },
          ),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _buildHeader(),
            _buildItem(
              icon: Icons.woman_rounded,
              title: 'B2B Women Empowerment',
              onTap: () {
                Get.back();
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const WomenBusiness()),
                );
              },
            ),
            _buildItem(
              icon: Icons.emergency,
              title: 'B2B Essential Services',
              onTap: () {
                Get.back();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const MentalHealth()),
                );
              },
            ),
            _buildItem(
              icon: Icons.start,
              title: 'B2B The Black KickStart',
              onTap: () {
                Get.back();
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const BlackKickStart()),
                );
              },
            ),
            _buildItem(
              icon: Icons.loyalty,
              title: 'B2B Loyalty Card',
              onTap: () {
                Get.back();
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const WomenBusiness()),
                );
              },
            ),
            _buildItem(
              icon: Icons.monetization_on_rounded,
              title: 'Register Business',
              onTap: () {
                Get.back();
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const RegisterBusiness()),
                );
              },
            ),
            _buildItem(
              icon: Icons.calendar_month,
              title: 'Register An Event',
              onTap: () {
                Get.back();
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const RegisterEvent()),
                );
              },
            ),
            _buildItem(
              icon: Icons.calendar_today,
              title: 'View All Events',
              onTap: () {
                Get.back();
                Get.to(() => const ViewAllEventsScreen());
              },
            ),
            _buildItem(
              icon: Icons.notifications,
              title: 'Alerts',
              onTap: () {
                Get.back();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Alerts()),
                );
              },
            ),
            _buildItem(
              icon: Icons.info_rounded,
              title: 'About',
              onTap: () {
                Get.back();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const AboutUs()),
                );
              },
            ),
            _buildItem(
              icon: Icons.info_rounded,
              title: 'Feedback & Suggestions',
              onTap: () {
                Get.back();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SupportUs()),
                );
              },
            ),
            Consumer<UserProvider>(
              builder: (context, value, child) => _buildItem(
                icon: Icons.logout,
                title: 'Logout',
                onTap: () async {
                  await value.signOut();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GNav(
          tabBackgroundColor: Colors.grey.shade800,
          gap: 8,
          onTabChange: navigateBottomBar,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          tabs: const [
            GButton(
              icon: Icons.home,
              text: 'Home',
            ),
            GButton(
              icon: Icons.map,
              text: 'MAP',
            ),
            GButton(
              icon: Icons.favorite,
              text: 'FAVS',
            ),
            GButton(
              icon: Icons.more_horiz_outlined,
              text: 'More',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return DrawerHeader(
      decoration: const BoxDecoration(
        color: Colors.black,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          CircleAvatar(
            backgroundImage: NetworkImage(
                'https://images.unsplash.com/photo-1512094476718-4d8f19366c62?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTB8fGJsYWNrJTIwd29tZW4lMjBpbiUyMGJ1c2luZXNzfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=900&q=60'),
            radius: 40,
          ),
          SizedBox(
            height: 20,
          ),
          Text('Black Queen'),
          Text('black.queens@godsplan.com'),
        ],
      ),
    );
  }

  Widget _buildItem(
      {required IconData icon,
      required String title,
      required GestureTapCallback onTap}) {
    return ListTile(
      leading: Icon(icon),
      minLeadingWidth: 5,
      title: Text(title),
      onTap: onTap,
    );
  }
}

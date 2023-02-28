import 'dart:ffi';

import 'package:b2bmobile/Screens/business/register_business.dart';
import 'package:b2bmobile/Screens/drawer/alerts.dart';
import 'package:b2bmobile/Screens/drawer/essential.dart';
import 'package:b2bmobile/Screens/drawer/events.dart';
import 'package:b2bmobile/Screens/drawer/register_event.dart';
import 'package:b2bmobile/Screens/drawer/women.dart';
import 'package:b2bmobile/Screens/pages/favorites.dart';
import 'package:b2bmobile/Screens/pages/home.dart';
import 'package:b2bmobile/Screens/pages/maps.dart';
import 'package:b2bmobile/Screens/pages/settings.dart';
import 'package:b2bmobile/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:b2bmobile/models/users.dart' as model;

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
    const Home(),
    const Maps(),
    const Favorites(),
    const MoreOptions(),
  ];

  @override
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Back2Black Mobile'),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _buildHeader(),
            _buildItem(
              icon: Icons.woman_rounded,
              title: 'Women Empowerment',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const Women()),
              ),
            ),
            _buildItem(
              icon: Icons.emergency,
              title: 'Essential Services',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const Essential()),
              ),
            ),
            _buildItem(
              icon: Icons.loyalty,
              title: 'B2B Loyalty Card',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const Women()),
              ),
            ),
            _buildItem(
              icon: Icons.monetization_on_rounded,
              title: 'Register Business',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => const RegisterBusiness()),
              ),
            ),
            _buildItem(
              icon: Icons.calendar_month,
              title: 'Register An Event',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const RegisterEvent()),
              ),
            ),
            _buildItem(
              icon: Icons.calendar_today,
              title: 'View All Events',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const Events()),
              ),
            ),
            _buildItem(
              icon: Icons.notifications,
              title: 'Alerts',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const Alerts()),
              ),
            ),
            _buildItem(
              icon: Icons.logout,
              title: 'Logout',
              onTap: () {},
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
              icon: Icons.search,
              text: 'Search',
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

import 'package:b2bmobile/Screens/pages/favorites.dart';
import 'package:b2bmobile/Screens/pages/home.dart';
import 'package:b2bmobile/Screens/pages/maps.dart';
import 'package:b2bmobile/Screens/pages/settings.dart';
import 'package:b2bmobile/providers/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
        title: InkWell(
          child: Text('B2BMobile: Black Excellence'),
          onLongPress: () {},
        ),
        leading: InkWell(
          onTap: () {},
          child: Icon(Icons.menu),
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
              icon: Icons.category_sharp,
              text: 'Categories',
            ),
          ],
        ),
      ),
    );
  }
}

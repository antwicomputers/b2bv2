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
  @override
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade800,
        title: Text('Back2Black Mobile'),
        leading: InkWell(
          onLongPress: () {},
          child: Icon(Icons.menu),
        ),
      ),
      body: Center(
        child: Text(user.username),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GNav(
          tabBackgroundColor: Colors.grey.shade800,
          gap: 8,
          onTabChange: (index) {
            print(index);
          },
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
              icon: Icons.more_horiz_rounded,
              text: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}

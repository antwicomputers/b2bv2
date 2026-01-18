import 'package:b2bmobile/Screens/black_kick_start/support_business.dart';
import 'package:b2bmobile/Screens/pages/support_resources.dart';
import 'package:flutter/material.dart';

class KickStartLanding extends StatefulWidget {
  const KickStartLanding({super.key});

  @override
  State<KickStartLanding> createState() => _SettingsState();
}

class _SettingsState extends State<KickStartLanding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('The BlackKickStart'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const SupportBusiness()),
            );
          },
          child: ListView(
            children: [
              ListTile(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    color: Colors.white,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                leading: const Icon(
                  Icons.add_moderator,
                  size: 30,
                  color: Colors.white,
                ),
                title: const Row(
                  children: [
                    Text('Support Black Owned Businesses'),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const SupportResources()),
                  );
                },
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      color: Colors.white,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  leading: const Icon(
                    Icons.youtube_searched_for,
                    size: 30,
                    color: Colors.white,
                  ),
                  title: const Row(
                    children: [
                      Text('Browse Support Resources'),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 20,
              ),
              ListTile(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    color: Colors.white,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                title: const Text(
                    '\nNetworking can help Black businesses and individuals to access career opportunities, funding for their businesses, and other resources that can help them to achieve their goals. It can also help to break down the isolation and marginalization that many Black people experience, providing them with a sense of belonging and connection.\n'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

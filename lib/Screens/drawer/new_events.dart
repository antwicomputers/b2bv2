import 'package:b2bmobile/Screens/business/register_business.dart';
import 'package:b2bmobile/Screens/drawer/register_event.dart';
import 'package:b2bmobile/Screens/vew%20all%20events/all_events.dart';
import 'package:b2bmobile/Screens/vew%20all%20events/my_events.dart';
import 'package:b2bmobile/Screens/vew%20all%20events/past_events.dart';
import 'package:b2bmobile/Screens/vew%20all%20events/sponsored_events.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainEvents extends StatefulWidget {
  const MainEvents({super.key});

  @override
  State<MainEvents> createState() => _SettingsState();
}

class _SettingsState extends State<MainEvents> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Back2Black Mobile Networking'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const RegisterEvent()),
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
                  Icons.event,
                  size: 30,
                  color: Colors.white,
                ),
                title: Row(
                  children: [
                    Text('Register Event'),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const MyEvents()),
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
                    Icons.event_seat_rounded,
                    size: 30,
                    color: Colors.white,
                  ),
                  title: Row(
                    children: const [
                      Text('My Events'),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const AllEvents()),
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
                    Icons.calendar_month,
                    size: 30,
                    color: Colors.white,
                  ),
                  title: Row(
                    children: [
                      Text('All Event'),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const SponsoredEvents()),
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
                    Icons.emoji_events_outlined,
                    size: 30,
                    color: Colors.white,
                  ),
                  title: Row(
                    children: [
                      Text('Sponsored Event'),
                    ],
                  ),
                ),
              ),
              SizedBox(
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
                leading: const Icon(
                  Icons.event_available_sharp,
                  size: 30,
                  color: Colors.white,
                ),
                title: Row(
                  children: [
                    Text('Attending'),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const PastEvents()),
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
                    Icons.event_repeat,
                    size: 30,
                    color: Colors.white,
                  ),
                  title: Row(
                    children: const [
                      Text('Past Event'),
                    ],
                  ),
                ),
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
                    '\nNetworking is vital in the black community for sharing resources and opportunities, building professional relationships, and overcoming systemic barriers to success.\n'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

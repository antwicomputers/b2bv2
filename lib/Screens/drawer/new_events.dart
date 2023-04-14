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
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: GridView(
            children: [
              InkWell(
                onTap: () {
                  Get.back();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const RegisterEvent()),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Icon(
                          Icons.event,
                          size: 113,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Register Event')
                      ],
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Get.back();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const MyEvents()),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Icon(
                          Icons.event,
                          size: 113,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text('My Events')
                      ],
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Get.back();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const AllEvents()),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Icon(
                          Icons.event,
                          size: 113,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text('All Events')
                      ],
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Get.back();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const SponsoredEvents()),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Icon(
                          Icons.event,
                          size: 113,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Sponsored Events')
                      ],
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Get.back();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const RegisterEvent()),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Icon(
                          Icons.event,
                          size: 113,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Attending')
                      ],
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Get.back();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const PastEvents()),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Icon(
                          Icons.event,
                          size: 113,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Past Event')
                      ],
                    ),
                  ),
                ),
              ),
            ],
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 30,
              crossAxisSpacing: 30,
            ),
          ),
        ),
      ),
    );
  }
}

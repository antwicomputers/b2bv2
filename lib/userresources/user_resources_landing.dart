import 'package:b2bmobile/Screens/black_kick_start/support_business.dart';
import 'package:b2bmobile/Screens/drawer/register_event.dart';
import 'package:b2bmobile/Screens/pages/support_resources.dart';
import 'package:b2bmobile/Screens/user_resource.dart';
import 'package:b2bmobile/Screens/vew%20all%20events/my_events.dart';
import 'package:flutter/material.dart';

class ResourceLanding extends StatefulWidget {
  const ResourceLanding({super.key});

  @override
  State<ResourceLanding> createState() => _ResourceLandingState();
}

class _ResourceLandingState extends State<ResourceLanding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Resources'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AddResource()),
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
                title: Row(
                  children: [
                    Text('Share a Resource'),
                  ],
                ),
              ),
              SizedBox(
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
                  title: Row(
                    children: const [
                      Text('Browse Resources'),
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
                    '\nAccess to resources such as education, healthcare, and job opportunities can help break down systemic barriers that have historically prevented Black people from achieving economic and social mobility. With access to resources, Black individuals can gain the skills, knowledge, and experience necessary to succeed in various fields and industries.\n'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

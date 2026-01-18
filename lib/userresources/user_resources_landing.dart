import 'package:b2bmobile/Screens/user_resource.dart';
import 'package:b2bmobile/userresources/user_resources.dart';
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
                title: const Row(
                  children: [
                    Text('Share a Resource'),
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
                        builder: (context) => const UserResources()),
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

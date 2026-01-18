import 'package:b2bmobile/Screens/pages/youth_resource.dart';
import 'package:flutter/material.dart';
import '../Screens/admin_panel/youth_requests/all_youth_support.dart';

class YouthResourceLanding extends StatefulWidget {
  const YouthResourceLanding({super.key});

  @override
  State<YouthResourceLanding> createState() => _YouthResourceLandingState();
}

class _YouthResourceLandingState extends State<YouthResourceLanding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Youth Empowerment'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const YouthResource()),
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
                    MaterialPageRoute(builder: (context) => const AllYouth()),
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
                    '\nEmpowering black youth is crucial for achieving equality, breaking generational cycles, fostering diversity, promoting leadership, driving economic empowerment, and nurturing social cohesion. By providing resources, opportunities, and support, we can create a more equitable and inclusive future where black youth can thrive and contribute to society\'s growth and well-being.\n'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

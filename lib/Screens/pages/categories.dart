import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:b2bmobile/Screens/business/register_business.dart';
import 'package:b2bmobile/Screens/drawer/about_us.dart';
import 'package:b2bmobile/Screens/drawer/black_kick_start.dart';
import 'package:b2bmobile/Screens/drawer/help_us.dart';
import 'package:b2bmobile/Screens/drawer/mental_health.dart';
import 'package:b2bmobile/Screens/drawer/new_events.dart';
import 'package:b2bmobile/Screens/drawer/women.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _SettingsState();
}

class _SettingsState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 10,
          childAspectRatio: .7,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        children: [
          InkWell(
            onTap: () {
              Get.back();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const RegisterBusiness()),
              );
            },
            child: const CategoryWIdget(
              image: 'assets/register.jpg',
              title: 'Register Business',
            ),
          ),
          InkWell(
            onTap: () {
              Get.back();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const WomenBusiness()),
              );
            },
            child: const CategoryWIdget(
              image: 'assets/womentile.jpeg',
              title: 'Women Empowerment',
            ),
          ),
          InkWell(
            onTap: () {
              Get.back();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const MentalHealth()),
              );
            },
            child: const CategoryWIdget(
              image: 'assets/health.jpeg',
              title: 'Essential Services',
            ),
          ),
          InkWell(
            onTap: () {
              Get.back();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const BlackKickStart()),
              );
            },
            child: const CategoryWIdget(
              image: 'assets/bks.jpeg',
              title: 'The Black Kick Start',
            ),
          ),
          InkWell(
            onTap: () {
              Get.back();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const RegisterBusiness()),
              );
            },
            child: const CategoryWIdget(
              image: 'assets/resources.jpeg',
              title: 'Resources',
            ),
          ),
          InkWell(
            onTap: () {
              Get.back();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const MainEvents()),
              );
            },
            child: const CategoryWIdget(
              image: 'assets/events.jpg',
              title: 'Events: Networking',
            ),
          ),
          InkWell(
            onTap: () {
              Get.back();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const RegisterBusiness()),
              );
            },
            child: const CategoryWIdget(
              image: 'assets/youth.jpeg',
              title: 'Youth Empowerment',
            ),
          ),
          InkWell(
            onTap: () {
              Get.back();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AboutUs()),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.info_rounded,
                    size: 112,
                  ),
                  Text('About')
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Get.back();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SupportUs()),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.feedback,
                    size: 112,
                  ),
                  Text('Feeback & Suggestions')
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryWIdget extends StatelessWidget {
  const CategoryWIdget({
    Key? key,
    required this.image,
    required this.title,
  }) : super(key: key);
  final String image;
  final String title;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(10),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: AssetImage(
              image,
            ),
            height: size.height * 0.2,
            width: size.width * 0.3,
            fit: BoxFit.cover,
          ),
          const SizedBox(
            height: 9,
          ),
          Text(title)
        ],
      ),
    );
  }
}

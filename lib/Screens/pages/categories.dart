import 'package:b2bmobile/userresources/user_resources_landing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:b2bmobile/Screens/business/register_business.dart';
import 'package:b2bmobile/Screens/drawer/black_kick_start.dart';
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
          crossAxisSpacing: 15,
          childAspectRatio: .8,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        children: [
          InkWell(
            onTap: () {
              Get.back();
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => const RegisterBusiness()),
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
              title: 'Women Empowerment\nPowered by Edwina',
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
              image: 'assets/mentaltile.jpeg',
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
                MaterialPageRoute(
                    builder: (context) => const ResourceLanding()),
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
              image: 'assets/events.jpeg',
              title: 'Events: Networking',
            ),
          ),
          InkWell(
            onTap: () {
              Get.back();
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => const RegisterBusiness()),
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
                MaterialPageRoute(builder: (context) => const MainEvents()),
              );
            },
            child: const CategoryWIdget(
              image: 'assets/news.jpeg',
              title: 'In The News',
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
            width: size.width * 0.5,
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

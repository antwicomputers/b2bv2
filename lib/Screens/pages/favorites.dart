import 'package:b2bmobile/models/business.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import 'business detal/business_detail_screen.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  late String currentUserUid = '';

  @override
  void initState() {
    super.initState();
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      currentUserUid = currentUser.uid;
    } else {
      // Handle the case when the user is not authenticated
      // You can show a login screen or redirect to the login page
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('businesses')
            .where('favoriteBy.$currentUserUid', isEqualTo: true)
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          final businesses = snapshot.data!.docs;

          if (businesses.isEmpty) {
            return const Center(
              child: Text('You have not favorited any businesses'),
            );
          }

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 15,
              childAspectRatio: .8,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            itemCount: businesses.length,
            itemBuilder: (BuildContext context, int index) {
              Business business =
                  Business.fromMap(snapshot.data!.docs[index].data());

              return CategoryWidget(
                image: business.businessUrl,
                title: business.businessName,
                onTap: () {
                  Get.to(() => BusinessDetailScreen(business: business));
                },
              );
            },
          );
        },
      ),
    );
  }
}

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({
    super.key,
    required this.image,
    required this.title,
    required this.onTap,
  });

  final String image;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.5),
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
              image: NetworkImage(image),
              height: size.height * 0.2,
              width: size.width * 0.5,
              fit: BoxFit.cover,
            ),
            const SizedBox(
              height: 9,
            ),
            Text(title),
          ],
        ),
      ),
    );
  }
}

import 'dart:math';

import 'package:b2bmobile/Screens/pages/all_esential.dart';
import 'package:b2bmobile/Screens/pages/all_featured.dart';
import 'package:b2bmobile/Screens/pages/all_sponsors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:b2bmobile/Screens/pages/business%20detal/business_detail_screen.dart';
import 'package:b2bmobile/models/business.dart';

import 'all_women.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _FavoritesState();
}

class _FavoritesState extends State<HomePage> {
  @override
  void initState() {
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        debugPrint("onMessage:");
        //log("onMessage: $message" as num);
        final snackBar =
            SnackBar(content: Text(message.notification?.title ?? ""));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 25.0,
              ),
              child: Text(
                'Shop Black Owned Businesses!',
                style: GoogleFonts.bebasNeue(
                  fontSize: 39,
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 25,
              ),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: Colors.white),
                  hintText: 'What are you looking for... ',
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade600)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Back2Black Sponsors',
                    style: GoogleFonts.bebasNeue(
                      fontSize: 18,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const AllSponsors()),
                      );
                    },
                    child: Text(
                      'Show All',
                      style: GoogleFonts.bebasNeue(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: size.height * 0.35,
              width: double.infinity,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('businesses')
                    .where('isSponsored', isEqualTo: true)
                    .where('isBlackOwned', isEqualTo: true)
                    .limit(30)
                    .snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.data?.docs.isEmpty ?? true) {
                    return const Center(
                      child: Text('No Sponsored Businesses available'),
                    );
                  }
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.docs.length > 30
                        ? 30
                        : snapshot.data!.docs.length,
                    itemBuilder: (ctx, index) {
                      Business business =
                          Business.fromMap(snapshot.data!.docs[index].data());
                      return HomeBusinessTile(
                        business: business,
                        size: size,
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Edwina\'s Move Her Forward',
                    style: GoogleFonts.bebasNeue(
                      fontSize: 18,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const AllWomen()),
                      );
                    },
                    child: Text(
                      'Show All',
                      style: GoogleFonts.bebasNeue(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: size.height * 0.35,
              width: double.infinity,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('businesses')
                    .where('womenOriented', isEqualTo: true)
                    .limit(30)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.data?.docs.isEmpty ?? true) {
                    return const Center(
                      child: Text('No Businesses to discover'),
                    );
                  }
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.docs.length > 30
                        ? 30
                        : snapshot.data!.docs.length,
                    itemBuilder: (ctx, index) {
                      Business business =
                          Business.fromMap(snapshot.data!.docs[index].data());
                      return HomeBusinessTile(
                        business: business,
                        size: size,
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Back2Black Mobile Essential Services',
                    style: GoogleFonts.bebasNeue(
                      fontSize: 18,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const AllEssential()),
                      );
                    },
                    child: Text(
                      'Show All',
                      style: GoogleFonts.bebasNeue(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: size.height * 0.35,
              width: double.infinity,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('businesses')
                    .where('isBlackOwned', isEqualTo: true)
                    .where('isEsential', isEqualTo: true)
                    .limit(30)
                    .snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.data?.docs.isEmpty ?? true) {
                    return const Center(
                      child: Text('No Businesses available'),
                    );
                  }
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.docs.length > 30
                        ? 30
                        : snapshot.data!.docs.length,
                    itemBuilder: (ctx, index) {
                      Business business =
                          Business.fromMap(snapshot.data!.docs[index].data());
                      return HomeBusinessTile(
                        business: business,
                        size: size,
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Back2Black Mobile Featured Brands',
                    style: GoogleFonts.bebasNeue(
                      fontSize: 18,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const AllFeatured()),
                      );
                    },
                    child: Text(
                      'Show All',
                      style: GoogleFonts.bebasNeue(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: size.height * 0.35,
              width: double.infinity,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('businesses')
                    .where('isFeatured', isEqualTo: true)
                    .where('isBlackOwned', isEqualTo: true)
                    .limit(30)
                    .snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.data?.docs.isEmpty ?? true) {
                    return const Center(
                      child: Text('No Featured Businesses available'),
                    );
                  }
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.docs.length > 30
                        ? 30
                        : snapshot.data!.docs.length,
                    itemBuilder: (ctx, index) {
                      Business business =
                          Business.fromMap(snapshot.data!.docs[index].data());
                      return HomeBusinessTile(
                        business: business,
                        size: size,
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Stream<QuerySnapshot<Object?>>? getRandomBusinessesStream() {
    final CollectionReference<Object?> businessesRef =
        FirebaseFirestore.instance.collection('businesses');
    final Random random = Random();

    return businessesRef
        .orderBy('businessName')
        .where('isBlackOwned', isEqualTo: true)
        .startAt([random.nextInt(10000).toString()])
        .limit(5)
        .snapshots();
  }
}

class HomeBusinessTile extends StatelessWidget {
  const HomeBusinessTile({
    Key? key,
    required this.business,
    required this.size,
  }) : super(key: key);
  final Business business;
  final Size size;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => BusinessDetailScreen(business: business));
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          width: size.width * 0.4,
          height: size.height * 0.35,
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
                Image(
                  image: NetworkImage(
                    business.businessUrl,
                  ),
                  width: size.width * 0.3,
                  height: size.height * 0.2,
                  fit: BoxFit.fill,
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Text(
                    business.businessName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 1,
                  ),
                ),
                Expanded(
                  child: Text(
                    business.businessCategory,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

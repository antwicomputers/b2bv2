import 'package:b2bmobile/models/business.dart';
import 'package:b2bmobile/providers/user_provider.dart';
import 'package:b2bmobile/utils/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:b2bmobile/models/detail_item_extensions.dart';
import 'package:b2bmobile/Screens/pages/universal_detail_screen.dart';

import 'package:b2bmobile/widgets/business_list_tile.dart';

class AllEssential extends StatefulWidget {
  const AllEssential({super.key});

  @override
  State<AllEssential> createState() => _AllEssentialState();
}

class _AllEssentialState extends State<AllEssential> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text('ESSENTIAL SERVICES', style: GoogleFonts.bebasNeue(letterSpacing: 1.5)),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('businesses')
            .where('isVerified', isEqualTo: true)
            .where('isEsential', isEqualTo: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }
          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return const Center(child: Text('Coming soon...', style: TextStyle(color: Colors.white38)));
          }
          return ListView.builder(
            itemCount: docs.length,
            padding: const EdgeInsets.only(top: 10, bottom: 40),
            itemBuilder: (context, index) {
              final business = Business.fromMap(docs[index].data() as Map<String, dynamic>);
              return BusinessListTile(business: business);
            },
          );
        },
      ),
    );
  }
}


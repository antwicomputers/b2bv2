import 'package:b2bmobile/models/business.dart';
import 'package:b2bmobile/providers/user_provider.dart';
import 'package:b2bmobile/utils/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'business detal/business_detail_screen.dart';

class AllSponsors extends StatefulWidget {
  const AllSponsors({super.key});

  @override
  State<AllSponsors> createState() => _AllSponsorsState();
}

class _AllSponsorsState extends State<AllSponsors> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 4,
      child: Consumer<UserProvider>(
        builder: (context, value, child) => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: const Text('Back2Black Sponsors'),
            centerTitle: true,
          ),
          body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('businesses')
                .where('isSponsored', isEqualTo: true)
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
                  child: Text('No businesses available'),
                );
              }
              return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  Business business =
                      Business.fromMap(snapshot.data!.docs[index].data());

                  if (!business.isVerified) {
                    Container();
                  }
                  return EventCardWidget(
                    business: business,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class EventCardWidget extends StatelessWidget {
  const EventCardWidget({
    super.key,
    required this.business,
  });
  final Business business;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Get.to(() => BusinessDetailScreen(business: business));
      },
      child: Container(
        height: size.height * 0.15,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: Image.network(
                  business.businessUrl,
                  height: size.height * 0.13,
                  width: size.height * 0.13,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        business.businessName,
                        style: AppConstants.titleStyle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        business.businessDescription,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

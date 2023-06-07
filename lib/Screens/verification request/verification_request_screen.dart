import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:b2bmobile/models/business.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verification Request'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        height: double.infinity,
        width: double.infinity,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('businesses')
              .where('isVerified', isEqualTo: false)
              // .orderBy('businessName')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (kDebugMode) {
              print(snapshot.data?.docs.length ?? 'noe');
            }
            if (snapshot.data?.docs.isEmpty ?? true) {
              return const Center(
                child: Text('No Businesses available'),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data?.docs.length ?? 0,
              itemBuilder: (context, index) {
                Business business =
                    Business.fromMap(snapshot.data!.docs[index].data());
                return Container(
                  margin: const EdgeInsets.only(top: 20),
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
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Image(
                        image: NetworkImage(
                          business.businessUrl,
                        ),
                        width: 250,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                      ExpansionTile(
                        title: Text(
                          business.businessName,
                        ),
                        expandedAlignment: Alignment.centerLeft,
                        expandedCrossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InfoWidget(
                            title: 'Description',
                            subtitle: business.businessDescription,
                          ),
                          InfoWidget(
                            title: 'Category',
                            subtitle: business.businessCategory,
                          ),
                        ],
                      ),
                      SwitchListTile(
                        value: business.isBlackOwned,
                        onChanged: (value) async {
                          await FirebaseFirestore.instance
                              .collection('businesses')
                              .doc(business.businessId)
                              .update({'isBlackOwned': !business.isBlackOwned});
                        },
                        title: const Text('isBlackOwned'),
                      ),
                      SwitchListTile(
                        value: business.womenOriented,
                        onChanged: (value) async {
                          await FirebaseFirestore.instance
                              .collection('businesses')
                              .doc(business.businessId)
                              .update(
                                  {'womenOriented': !business.womenOriented});
                        },
                        title: const Text('womenOriented'),
                      ),
                      SwitchListTile(
                        value: business.isEsential,
                        onChanged: (value) async {
                          await FirebaseFirestore.instance
                              .collection('businesses')
                              .doc(business.businessId)
                              .update({'isEsential': !business.isEsential});
                        },
                        title: const Text('isEsential'),
                      ),
                      SwitchListTile(
                        value: business.isFeatured,
                        onChanged: (value) async {
                          await FirebaseFirestore.instance
                              .collection('businesses')
                              .doc(business.businessId)
                              .update({'isFeatured': !business.isFeatured});
                        },
                        title: const Text('isFeatured'),
                      ),
                      SwitchListTile(
                        value: business.isSponsored,
                        onChanged: (value) async {
                          await FirebaseFirestore.instance
                              .collection('businesses')
                              .doc(business.businessId)
                              .update({'isSponsored': !business.isSponsored});
                        },
                        title: const Text('isSponsored'),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class InfoWidget extends StatelessWidget {
  const InfoWidget({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(subtitle),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:b2bmobile/models/support.dart';

class SupportRequest extends StatelessWidget {
  const SupportRequest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Support Request'),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        height: double.infinity,
        width: double.infinity,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('supportbusinesses')
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
                Support support =
                    Support.fromMap(snapshot.data!.docs[index].data());
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
                          support.SupportUrl,
                        ),
                        width: 250,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                      ExpansionTile(
                        title: Text(
                          support.supportName,
                        ),
                        expandedAlignment: Alignment.centerLeft,
                        expandedCrossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InfoWidget(
                            title: 'Description',
                            subtitle: support.supportDescription,
                          ),
                          InfoWidget(
                            title: 'Category',
                            subtitle: support.supportCategory,
                          ),
                        ],
                      ),
                      SwitchListTile(
                        value: support.isBlackOwned,
                        onChanged: (value) async {
                          await FirebaseFirestore.instance
                              .collection('supportbusinesses')
                              .doc(support.supportId)
                              .update({'isBlackOwned': !support.isBlackOwned});
                        },
                        title: const Text('isBlackOwned'),
                      ),
                      SwitchListTile(
                        value: support.womenOriented,
                        onChanged: (value) async {
                          await FirebaseFirestore.instance
                              .collection('supportbusinesses')
                              .doc(support.supportId)
                              .update(
                                  {'womenOriented': !support.womenOriented});
                        },
                        title: const Text('womenOriented'),
                      ),
                      SwitchListTile(
                        value: support.isEsential,
                        onChanged: (value) async {
                          await FirebaseFirestore.instance
                              .collection('supportbusinesses')
                              .doc(support.supportId)
                              .update({'isEsential': !support.isEsential});
                        },
                        title: const Text('isEsential'),
                      ),
                      SwitchListTile(
                        value: support.isFeatured,
                        onChanged: (value) async {
                          await FirebaseFirestore.instance
                              .collection('supportbusinesses')
                              .doc(support.supportId)
                              .update({'isFeatured': !support.isFeatured});
                        },
                        title: const Text('isFeatured'),
                      ),
                      SwitchListTile(
                        value: support.isSponsored,
                        onChanged: (value) async {
                          await FirebaseFirestore.instance
                              .collection('supportbusinesses')
                              .doc(support.supportId)
                              .update({'isSponsored': !support.isSponsored});
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

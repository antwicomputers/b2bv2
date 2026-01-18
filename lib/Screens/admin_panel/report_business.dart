import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../utils/dimensions.dart';

class BusinessReport extends StatefulWidget {
  const BusinessReport({super.key});

  @override
  State<BusinessReport> createState() => _BusinessReportState();
}

class _BusinessReportState extends State<BusinessReport> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor:
          width > webScreenSize ? webBackgroundColor : mobileBackgroundColor,
      appBar: width > webScreenSize
          ? null
          : AppBar(
              backgroundColor: mobileBackgroundColor,
              centerTitle: true,
              title: const Text('Business Report'),
              // actions: [
              //   IconButton(
              //     icon: const Icon(
              //       Icons.messenger_outline,
              //       color: primaryColor,
              //     ),
              //     onPressed: () {},
              //   ),
              // ],
            ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('userfeedback')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (ctx, index) => Padding(
              padding: const EdgeInsets.all(8),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    color: Colors.white,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                leading: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person),
                ),
                title: Row(
                  children: [
                    Text(
                      (snapshot.data! as dynamic).docs[index]['option'],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                subtitle: Text(
                  (snapshot.data! as dynamic).docs[index]['userInput'],
                ),
                trailing: const Icon(
                  Icons.more_vert,
                ),
                onTap: () => debugPrint('you pressed more'),
              ),
            ),
          );
        },
      ),
    );
  }
}

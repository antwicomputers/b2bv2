import 'package:b2bmobile/models/detail_item_extensions.dart';
import 'package:b2bmobile/Screens/pages/universal_detail_screen.dart';
import 'package:b2bmobile/models/support.dart';
import 'package:b2bmobile/providers/user_provider.dart';
import 'package:b2bmobile/utils/app_constants.dart';
import 'package:b2bmobile/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:b2bmobile/userresources/edit_resource_screen.dart';
import 'package:b2bmobile/resources/storage_methods.dart';

class MyResources extends StatefulWidget {
  const MyResources({super.key});

  @override
  State<MyResources> createState() => _MyResourcesState();
}

class _MyResourcesState extends State<MyResources> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('My Shared Resources'),
          centerTitle: true,
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('userresourcesupport')
              .where(
                'userId',
                isEqualTo: value.getUser!.uid,
              )
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data?.docs.isEmpty ?? true) {
              return const Center(
                child: Text('No Shared Resources available'),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                try {
                  Support support =
                    Support.fromMap(snapshot.data!.docs[index].data());
                  return MyResourceCardWidget(support: support);
                } catch (e) {
                   return const SizedBox.shrink();
                }
              },
            );
          },
        ),
      ),
    );
  }
}

class MyResourceCardWidget extends StatelessWidget {
  const MyResourceCardWidget({
    super.key,
    required this.support,
  });
  final Support support;

  Future<void> _deleteResource(BuildContext context) async {
    bool confirm = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Resource"),
        content: const Text("Are you sure you want to delete this resource? This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm) {
      // 1. Delete Image
      await StorageMethods().deleteImageFromStorage(support.supportUrl);
      // 2. Delete Doc
      await FirebaseFirestore.instance
          .collection('userresourcesupport')
          .doc(support.supportId)
          .delete();
      
      if(context.mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
             const SnackBar(content: Text('Resource Deleted')),
           );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Get.to(() => UniversalDetailScreen(item: support.toDetailItem()));
      },
      child: Container(
        height: size.height * 0.18,
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
                  support.supportUrl,
                  height: size.height * 0.15,
                  width: size.height * 0.13,
                  fit: BoxFit.cover,
                   errorBuilder: (context, error, stackTrace) =>
                      Container(color: Colors.grey, width: size.height * 0.13, height: size.height * 0.15, child: const Icon(Icons.error)),
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
                    Text(
                      support.supportName,
                      style: AppConstants.titleStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      support.supportDescription,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                         Container(
                           padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                           decoration: BoxDecoration(
                             color: support.isVerified ? Colors.green : Colors.orange,
                             borderRadius: BorderRadius.circular(4)
                           ),
                           child: Text(
                             support.isVerified ? "Verified" : "Pending",
                             style: const TextStyle(color: Colors.white, fontSize: 10),
                           ),
                         ),
                         const Spacer(),
                         IconButton(
                           icon: const Icon(Icons.edit, color: primaryColor),
                           onPressed: () {
                             Get.to(() => EditResourceScreen(support: support));
                           },
                         ),
                         IconButton(
                           icon: const Icon(Icons.delete, color: Colors.red),
                           onPressed: () => _deleteResource(context),
                         ),
                      ],
                    )
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

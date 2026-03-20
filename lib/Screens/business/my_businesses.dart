import 'package:b2bmobile/Screens/business/edit_business_screen.dart';
import 'package:b2bmobile/models/detail_item_extensions.dart';
import 'package:b2bmobile/Screens/pages/universal_detail_screen.dart';
import 'package:b2bmobile/models/business.dart';
import 'package:b2bmobile/providers/user_provider.dart';
import 'package:b2bmobile/resources/storage_methods.dart';
import 'package:b2bmobile/utils/app_constants.dart';
import 'package:b2bmobile/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class MyBusinesses extends StatefulWidget {
  const MyBusinesses({super.key});

  @override
  State<MyBusinesses> createState() => _MyBusinessesState();
}

class _MyBusinessesState extends State<MyBusinesses> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('My Businesses'),
          centerTitle: true,
        ),
        body: value.getUser == null 
            ? const Center(child: CircularProgressIndicator()) 
            : StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('businesses')
                    .where('userId', isEqualTo: value.getUser!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(child: Text('Error loading businesses'));
                  }
                  if (snapshot.data?.docs.isEmpty ?? true) {
                    return const Center(child: Text('No Registered Businesses'));
                  }

            return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                // Handle potential parsing errors gracefully
                try {
                  Business business =
                      Business.fromMap(snapshot.data!.docs[index].data());
                  return BusinessCardWidget(business: business);
                } catch (e) {
                  return const SizedBox.shrink(); // Skip corrupted data
                }
              },
            );
          },
        ),
      ),
    );
  }
}

class BusinessCardWidget extends StatelessWidget {
  final Business business;
  const BusinessCardWidget({super.key, required this.business});

  Future<void> _deleteBusiness(BuildContext context) async {
    bool confirm = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Business"),
        content: const Text("Are you sure you want to delete this business? This action cannot be undone."),
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
      await StorageMethods().deleteImageFromStorage(business.businessUrl);
      // 2. Delete Doc
      await FirebaseFirestore.instance
          .collection('businesses')
          .doc(business.businessId)
          .delete();
      
      if(context.mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
             const SnackBar(content: Text('Business Deleted')),
           );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Get.to(() => UniversalDetailScreen(item: business.toDetailItem()));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        height: size.height * 0.18, // Slightly taller for buttons
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.5),
              spreadRadius: 3,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: Image.network(
                  business.businessUrl,
                  height: size.height * 0.15,
                  width: size.height * 0.13,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(color: Colors.grey, width: size.height * 0.13, height: size.height * 0.15, child: const Icon(Icons.error)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      business.businessName,
                      style: AppConstants.titleStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      business.businessDescription,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                         Container(
                           padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                           decoration: BoxDecoration(
                             color: business.isVerified ? Colors.green : Colors.orange,
                             borderRadius: BorderRadius.circular(4)
                           ),
                           child: Text(
                             business.isVerified ? "Verified" : "Pending",
                             style: const TextStyle(color: Colors.white, fontSize: 10),
                           ),
                         ),
                         Row(
                           children: [
                             IconButton(
                               icon: const Icon(Icons.edit, color: primaryColor),
                               onPressed: () {
                                 Get.to(() => EditBusinessScreen(business: business));
                               },
                             ),
                             IconButton(
                               icon: const Icon(Icons.delete, color: Colors.red),
                               onPressed: () => _deleteBusiness(context),
                             ),
                           ],
                         )
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

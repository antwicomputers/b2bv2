import 'package:b2bmobile/models/detail_item_extensions.dart';
import 'package:b2bmobile/Screens/pages/universal_detail_screen.dart';
import 'package:b2bmobile/models/events.dart';
import 'package:b2bmobile/providers/user_provider.dart';
import 'package:b2bmobile/utils/app_constants.dart';
import 'package:b2bmobile/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:b2bmobile/Screens/drawer/edit_event_screen.dart';
import 'package:b2bmobile/resources/storage_methods.dart';

class MyEvents extends StatefulWidget {
  const MyEvents({super.key});

  @override
  State<MyEvents> createState() => _ViewAllEventsScreenState();
}

class _ViewAllEventsScreenState extends State<MyEvents> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('My Events'),
        ),
        body: value.getUser == null
            ? const Center(child: CircularProgressIndicator())
            : StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('events')
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
                child: Text('No Registered Events available'),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                Events event =
                    Events.fromMap(snapshot.data!.docs[index].data());
                return EventCardWidget(event: event);
              },
            );
          },
        ),
      ),
    );
  }
}

class EventCardWidget extends StatelessWidget {
  const EventCardWidget({
    super.key,
    required this.event,
  });
  final Events event;

  Future<void> _deleteEvent(BuildContext context) async {
    bool confirm = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Event"),
        content: const Text("Are you sure you want to delete this event? This action cannot be undone."),
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
      await StorageMethods().deleteImageFromStorage(event.eventUrl);
      // 2. Delete Doc
      await FirebaseFirestore.instance
          .collection('events')
          .doc(event.eventId)
          .delete();
      
      if(context.mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
             const SnackBar(content: Text('Event Deleted')),
           );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Get.to(() => UniversalDetailScreen(item: event.toDetailItem()));
      },
      child: Container(
        height: size.height * 0.18, // Increased height for buttons
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
                  event.eventUrl,
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
                      event.eventName,
                      style: AppConstants.titleStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      event.eventDescription,
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
                             color: event.isVerified ? Colors.green : Colors.orange,
                             borderRadius: BorderRadius.circular(4)
                           ),
                           child: Text(
                             event.isVerified ? "Verified" : "Pending",
                             style: const TextStyle(color: Colors.white, fontSize: 10),
                           ),
                         ),
                         const Spacer(),
                         IconButton(
                           icon: const Icon(Icons.edit, color: primaryColor),
                           onPressed: () {
                             Get.to(() => EditEventScreen(event: event));
                           },
                         ),
                         IconButton(
                           icon: const Icon(Icons.delete, color: Colors.red),
                           onPressed: () => _deleteEvent(context),
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

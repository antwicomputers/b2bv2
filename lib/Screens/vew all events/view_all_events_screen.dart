import 'package:b2bmobile/Screens/pages/event%20detail%20page/event_details_screen.dart';
import 'package:b2bmobile/models/events.dart';
import 'package:b2bmobile/providers/user_provider.dart';
import 'package:b2bmobile/utils/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ViewAllEventsScreen extends StatefulWidget {
  const ViewAllEventsScreen({super.key});

  @override
  State<ViewAllEventsScreen> createState() => _ViewAllEventsScreenState();
}

class _ViewAllEventsScreenState extends State<ViewAllEventsScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Consumer<UserProvider>(
        builder: (context, value, child) => Scaffold(
          appBar: AppBar(
            title: const Text('All Events'),
            bottom: const TabBar(tabs: [
              Tab(
                text: 'My',
              ),
              Tab(
                text: 'All',
              ),
              Tab(
                text: 'Past ',
              ),
              Tab(
                text: 'Sponsered',
              ),
            ]),
          ),
          body: TabBarView(
            children: [
              // My Events
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('events')
                    .where(
                      'userId',
                      isEqualTo: value.getUser!.uid,
                    )
                    .where('isVerified', isEqualTo: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.data?.docs.isEmpty ?? true) {
                    return const Center(
                      child: Text('No Verified Events available'),
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
              // All Events
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('events')
                    .where(
                      'asTimeStamp',
                      isGreaterThan: DateTime.now(),
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
                      child: Text('No Verified Events available'),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      Events event =
                          Events.fromMap(snapshot.data!.docs[index].data());

                      if (!event.isVerified) {
                        Container();
                      }
                      return EventCardWidget(
                        event: event,
                      );
                    },
                  );
                },
              ),
              // All Past
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('events')
                    .where(
                      'asTimeStamp',
                      isLessThan: DateTime.now(),
                    )
                    .limit(20)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.data?.docs.isEmpty ?? true) {
                    return const Center(
                      child: Text('No Past Events available'),
                    );
                  }

                  return ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      Events event =
                          Events.fromMap(snapshot.data!.docs[index].data());
                      if (!event.isVerified) {
                        return Container();
                      }
                      return EventCardWidget(event: event);
                    },
                  );
                },
              ),
              // All Sponsered
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('events')
                    .where('isSponsered', isEqualTo: true)
                    .where('isVerified', isEqualTo: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.data?.docs.isEmpty ?? true) {
                    return const Center(
                      child: Text('No Sponsered Events available'),
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
            ],
          ),
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
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Get.to(() => EventDetailsScreen(event: event));
      },
      child: Container(
        height: size.height * 0.15,
        width: double.infinity,
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
                        event.eventName,
                        style: AppConstants.titleStyle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        event.eventDescription,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          DateFormat('dd/MMM/yyyy HH:MM a')
                              .format(event.eventDate),
                          style: const TextStyle(
                            fontSize: 10,
                          ),
                        ),
                        const Spacer(),
                        const Text(
                          'Attending :12',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
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

import 'package:b2bmobile/Screens/vew%20all%20events/view_all_events_screen.dart';
import 'package:b2bmobile/models/events.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EventRequestScreen extends StatelessWidget {
  const EventRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Requests'),
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('events').snapshots(),
          builder: (context, snapshot) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                Events event = Events.fromMap(snapshot.data!.docs[index].data());
                return Card(
                  child: Column(
                    children: [
                      EventCardWidget(
                        event: event,
                      ),
                      SwitchListTile(
                        value: event.isVerified,
                        onChanged: (_) async {
                          await FirebaseFirestore.instance.collection('events').doc(event.eventId).update(
                            {
                              'isVerified': !event.isVerified,
                            },
                          );
                        },
                        title: const Text('isVerified'),
                      ),
                      SwitchListTile(
                        value: event.isSponsered,
                        onChanged: (_) async {
                          await FirebaseFirestore.instance.collection('events').doc(event.eventId).update(
                            {
                              'isSponsered': !event.isSponsered,
                            },
                          );
                        },
                        title: const Text('isSponsered'),
                      ),
                      SwitchListTile(
                        value: event.isWomenOriented,
                        onChanged: (_) async {
                          await FirebaseFirestore.instance.collection('events').doc(event.eventId).update(
                            {
                              'isWomenOriented': !event.isWomenOriented,
                            },
                          );
                        },
                        title: const Text('isWomenOriented'),
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

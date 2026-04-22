import 'package:b2bmobile/Screens/vew%20all%20events/view_all_events_screen.dart';
import 'package:b2bmobile/models/events.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EventRequestScreen extends StatefulWidget {
  const EventRequestScreen({super.key});

  @override
  State<EventRequestScreen> createState() => _EventRequestScreenState();
}

class _EventRequestScreenState extends State<EventRequestScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _activeFilter = 'Pending'; // Pending, All, Sponsored, Verified

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Manage Events', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val.toLowerCase()),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search events...',
                    hintStyle: const TextStyle(color: Colors.white38),
                    prefixIcon: const Icon(Icons.search, color: Colors.white38),
                    filled: true,
                    fillColor: const Color(0xFF1E1E1E),
                    contentPadding: const EdgeInsets.all(12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    _filterChip('Pending'),
                    _filterChip('All'),
                    _filterChip('Sponsored'),
                    _filterChip('Verified'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('events').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            var docs = snapshot.data?.docs ?? [];

            // APPLY FILTERS
            if (_searchQuery.isNotEmpty) {
              docs = docs.where((doc) {
                final name = (doc.data() as Map<String, dynamic>)['eventName']?.toString().toLowerCase() ?? '';
                return name.contains(_searchQuery);
              }).toList();
            }

            if (_activeFilter != 'All') {
              docs = docs.where((doc) {
                final data = doc.data() as Map<String, dynamic>;
                switch (_activeFilter) {
                  case 'Pending': return (data['isVerified'] ?? false) == false;
                  case 'Sponsored': return (data['isSponsered'] ?? false) == true;
                  case 'Verified': return (data['isVerified'] ?? false) == true;
                  default: return true;
                }
              }).toList();
            }

            if (docs.isEmpty) {
              return const Center(child: Text('No events found', style: TextStyle(color: Colors.white38)));
            }
            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                Events event = Events.fromMap(
                    docs[index].data() as Map<String, dynamic>);
                return Card(
                  child: Column(
                    children: [
                      EventCardWidget(event: event),
                      SwitchListTile(
                        value: event.isVerified,
                        onChanged: (_) async {
                          await FirebaseFirestore.instance
                              .collection('events')
                              .doc(event.eventId)
                              .update({'isVerified': !event.isVerified});
                        },
                        title: const Text('isVerified'),
                      ),
                      SwitchListTile(
                        value: event.isSponsered,
                        onChanged: (_) async {
                          await FirebaseFirestore.instance
                              .collection('events')
                              .doc(event.eventId)
                              .update({'isSponsered': !event.isSponsered});
                        },
                        title: const Text('isSponsered'),
                      ),
                      SwitchListTile(
                        value: event.isWomenOriented,
                        onChanged: (_) async {
                          await FirebaseFirestore.instance
                              .collection('events')
                              .doc(event.eventId)
                              .update({
                            'isWomenOriented': !event.isWomenOriented
                          });
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
  Widget _filterChip(String label) {
    final isSelected = _activeFilter == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (val) {
          if (val) setState(() => _activeFilter = label);
        },
        backgroundColor: const Color(0xFF141414),
        selectedColor: Colors.blueAccent,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.white38,
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: isSelected ? Colors.blueAccent : Colors.white12),
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:b2bmobile/models/support.dart';

class SupportRequest extends StatefulWidget {
  const SupportRequest({super.key});

  @override
  State<SupportRequest> createState() => _SupportRequestState();
}

class _SupportRequestState extends State<SupportRequest> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _activeFilter = 'Pending'; // Pending, All, Sponsored, Verified

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Manage Support', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                    hintText: 'Search support resources...',
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
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        height: double.infinity,
        width: double.infinity,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('supportbusinesses').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            var docs = snapshot.data?.docs ?? [];

            // APPLY FILTERS
            if (_searchQuery.isNotEmpty) {
              docs = docs.where((doc) {
                final name = (doc.data() as Map<String, dynamic>)['supportName']?.toString().toLowerCase() ?? '';
                return name.contains(_searchQuery);
              }).toList();
            }

            if (_activeFilter != 'All') {
              docs = docs.where((doc) {
                final data = doc.data() as Map<String, dynamic>;
                switch (_activeFilter) {
                  case 'Pending': return (data['isVerified'] ?? false) == false;
                  case 'Sponsored': return (data['isSponsored'] ?? false) == true;
                  case 'Verified': return (data['isVerified'] ?? false) == true;
                  default: return true;
                }
              }).toList();
            }

            if (docs.isEmpty) {
              return const Center(child: Text('No support resources found', style: TextStyle(color: Colors.white38)));
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
                        color: Colors.grey.withValues(alpha: 0.5),
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
                          support.supportUrl,
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

class InfoWidget extends StatelessWidget {
  const InfoWidget({
    super.key,
    required this.title,
    required this.subtitle,
  });
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

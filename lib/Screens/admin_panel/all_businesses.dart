import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BusinessAll extends StatefulWidget {
  const BusinessAll({super.key});

  @override
  State<BusinessAll> createState() => _ManageUsersState();
}

class _ManageUsersState extends State<BusinessAll> {
  void _toggleFlag(String docId, String field, bool current) {
    FirebaseFirestore.instance
        .collection('businesses')
        .doc(docId)
        .update({field: !current});
  }

  void _showManagementDialog(String docId, Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) {
        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('businesses')
              .doc(docId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const SizedBox();
            final businessData = snapshot.data!.data() as Map<String, dynamic>;

            return AlertDialog(
              backgroundColor: const Color(0xFF1A1A1A),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
              title: Text(
                businessData['businessName'] ?? 'Manage Business',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildToggle(docId, 'isVerified', 'Verified',
                        businessData['isVerified'] ?? false, Colors.blueAccent),
                    _buildToggle(
                        docId,
                        'isBlackOwned',
                        'Black Owned',
                        businessData['isBlackOwned'] ?? false,
                        Colors.white),
                    _buildToggle(
                        docId,
                        'womenOriented',
                        'Women Founded',
                        businessData['womenOriented'] ?? false,
                        Colors.pinkAccent),
                    _buildToggle(
                        docId,
                        'isEsential',
                        'Essential Service',
                        businessData['isEsential'] ?? false,
                        Colors.orangeAccent),
                    _buildToggle(
                        docId,
                        'isFeatured',
                        'Featured Brand',
                        businessData['isFeatured'] ?? false,
                        Colors.purpleAccent),
                    _buildToggle(
                        docId,
                        'isSponsored',
                        'Sponsored',
                        businessData['isSponsored'] ?? false,
                        Colors.amberAccent),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close',
                      style: TextStyle(color: Colors.white70)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildToggle(
      String docId, String field, String label, bool value, Color activeColor) {
    return SwitchListTile(
      title: Text(label,
          style: const TextStyle(color: Colors.white70, fontSize: 14)),
      value: value,
      onChanged: (val) => _toggleFlag(docId, field, value),
      activeThumbColor: activeColor,
      dense: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Consistent background
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'All Businesses',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('businesses').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data?.docs ?? [];
          return ListView.builder(
            itemCount: docs.length,
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemBuilder: (ctx, index) {
              final data = docs[index].data();
              final id = docs[index].id;
              final String imageUrl = data['businessUrl'] ?? '';

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF141414),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(10),
                        image: imageUrl.isNotEmpty
                            ? DecorationImage(
                                image: NetworkImage(imageUrl),
                                fit: BoxFit.cover)
                            : null,
                      ),
                      child: imageUrl.isEmpty
                          ? const Icon(Icons.business, color: Colors.white24)
                          : null,
                    ),
                    title: Text(
                      data['businessName'] ?? 'Unnamed',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          data['phone'] ?? 'No phone',
                          style: const TextStyle(color: Colors.white54),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          children: [
                            if (data['isVerified'] == true) _miniBadge(Icons.verified, Colors.blueAccent),
                            if (data['isSponsored'] == true) _miniBadge(Icons.star, Colors.amberAccent),
                            if (data['womenOriented'] == true) _miniBadge(Icons.female, Colors.pinkAccent),
                          ],
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.edit_note, color: Colors.white38),
                    onTap: () => _showManagementDialog(id, data),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _miniBadge(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 10),
    );
  }
}

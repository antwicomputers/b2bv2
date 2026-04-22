import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BusinessAll extends StatefulWidget {
  const BusinessAll({super.key});

  @override
  State<BusinessAll> createState() => _ManageUsersState();
}

class _ManageUsersState extends State<BusinessAll> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _activeFilter = 'All'; // All, Pending, Premium, Sponsored

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
                    const Divider(color: Colors.white24, height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent.withValues(alpha: 0.2),
                          foregroundColor: Colors.redAccent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        icon: const Icon(Icons.swap_horiz, size: 20),
                        label: const Text('Reassign Owner (Transfer)', style: TextStyle(fontWeight: FontWeight.bold)),
                        onPressed: () {
                           Navigator.pop(context); // close manage dialog
                           _showReassignDialog(docId);
                        },
                      ),
                    ),
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

  void _showReassignDialog(String docId) {
    final emailController = TextEditingController();
    bool isLoading = false;
    
    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setStateBuilder) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1E1E1E),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Text('Transfer Business', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                   const Text("Enter the email address of the registered user you want to transfer this business to.", style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4)),
                   const SizedBox(height: 20),
                   TextField(
                     controller: emailController,
                     style: const TextStyle(color: Colors.white),
                     decoration: InputDecoration(
                        hintText: "user@example.com",
                        hintStyle: const TextStyle(color: Colors.white38),
                        filled: true,
                        fillColor: const Color(0xFF141414),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.all(16),
                     ),
                   ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx), 
                  child: const Text("Cancel", style: TextStyle(color: Colors.white54))
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                  onPressed: isLoading ? null : () async {
                    setStateBuilder(() => isLoading = true);
                    final email = emailController.text.trim();
                    if (email.isEmpty) {
                       setStateBuilder(() => isLoading = false);
                       return;
                    }
                    try {
                       final userQuery = await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: email).limit(1).get();
                       if (userQuery.docs.isEmpty) {
                           Get.snackbar("Error", "No user found with the email: $email");
                           setStateBuilder(() => isLoading = false);
                           return;
                       }
                       final newUid = userQuery.docs.first.id;
                       await FirebaseFirestore.instance.collection('businesses').doc(docId).update({
                          'userId': newUid,
                       });
                       if (context.mounted) Navigator.pop(ctx);
                       Get.snackbar("Transfer Complete", "The business is now owned by $email 🚀", backgroundColor: Colors.green.withValues(alpha: 0.8), colorText: Colors.white);
                    } catch(e) {
                       Get.snackbar("Error", "Failed to transfer: $e");
                       setStateBuilder(() => isLoading = false);
                    }
                  },
                  child: isLoading 
                     ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white)) 
                     : const Text("Transfer", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            );
          }
        );
      }
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
                    hintText: 'Search business name...',
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
                    _filterChip('All'),
                    _filterChip('Pending'),
                    _filterChip('Premium'),
                    _filterChip('Sponsored'),
                    _filterChip('Verified'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('businesses').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          var docs = snapshot.data?.docs ?? [];

          // APPLY FILTERS
          if (_searchQuery.isNotEmpty) {
            docs = docs.where((doc) {
              final name = (doc.data()['businessName'] ?? '').toString().toLowerCase();
              return name.contains(_searchQuery);
            }).toList();
          }

          if (_activeFilter != 'All') {
            docs = docs.where((doc) {
              final data = doc.data();
              switch (_activeFilter) {
                case 'Pending': return (data['isVerified'] ?? false) == false;
                case 'Premium': return (data['isBlackOwned'] ?? false) == true;
                case 'Sponsored': return (data['isSponsored'] ?? false) == true;
                case 'Verified': return (data['isVerified'] ?? false) == true;
                default: return true;
              }
            }).toList();
          }

          if (docs.isEmpty) {
            return const Center(child: Text("No businesses found", style: TextStyle(color: Colors.white38)));
          }

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

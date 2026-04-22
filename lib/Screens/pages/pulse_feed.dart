import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:b2bmobile/models/business.dart';
import 'package:b2bmobile/models/detail_item_extensions.dart';
import 'package:b2bmobile/Screens/pages/universal_detail_screen.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:b2bmobile/providers/user_provider.dart';

class PulseFeed extends StatefulWidget {
  const PulseFeed({super.key});

  @override
  State<PulseFeed> createState() => _PulseFeedState();
}

class _PulseFeedState extends State<PulseFeed> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('The Pulse', style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24, shadows: [Shadow(color: Colors.black, blurRadius: 10)])),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('businesses')
            .where('isVerified', isEqualTo: true)
            // Limit and order as needed, for now just fetch
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No content available on The Pulse.", style: TextStyle(color: Colors.white)));
          }

          final docs = snapshot.data!.docs;
          // Shuffle them to make it feel like an endless discovery feed
          final businesses = docs.map((d) => Business.fromMap(d.data() as Map<String, dynamic>)).toList();
          businesses.shuffle();

          return PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: businesses.length,
            itemBuilder: (context, index) {
              final biz = businesses[index];
              final item = biz.toDetailItem();
              return Stack(
                fit: StackFit.expand,
                children: [
                  // Background
                  Image.network(
                    item.imageUrl.isNotEmpty ? item.imageUrl : 'https://images.unsplash.com/photo-1542204165-65bf26472b9b',
                    fit: BoxFit.cover,
                  ),
                  // Dark Gradient Overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.black.withValues(alpha: 0.1), Colors.black.withValues(alpha: 0.9)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  // Content
                  Positioned(
                    bottom: 40,
                    left: 20,
                    right: 80, // leave right for action buttons
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (item.isBlackOwned)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.8), borderRadius: BorderRadius.circular(6)),
                            child: const Text('Verified Premium', style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                        Text(item.name, style: GoogleFonts.outfit(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, height: 1.1)),
                        const SizedBox(height: 8),
                        Text(item.category.toUpperCase(), style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                        const SizedBox(height: 12),
                        Text(item.description, style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.4), maxLines: 3, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                  // Side Actions
                  Positioned(
                    bottom: 40,
                    right: 16,
                    child: Column(
                      children: [
                        _SideAction(
                          icon: Icons.person,
                          label: 'Profile',
                          onTap: () => Get.to(() => UniversalDetailScreen(item: item)),
                        ),
                        const SizedBox(height: 24),
                        _SideAction(
                          icon: Icons.favorite,
                          label: 'Support',
                          onTap: () async {
                             final userProv = Provider.of<UserProvider>(context, listen: false);
                             final user = userProv.userModel;
                             if (user == null) {
                               Get.snackbar('Error', 'Please log in to support businesses.');
                               return;
                             }
                             
                             try {
                               final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
                               final List favorites = (userDoc.data() as Map<String, dynamic>)['favorites'] ?? [];
                               
                               if (favorites.contains(item.id)) {
                                 Get.snackbar('Already Supported', 'You have already supported ${item.name}!', snackPosition: SnackPosition.TOP);
                                 return;
                               }

                               // 1. Give +10 points to the user profile and add to favorites
                               await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
                                 'points': FieldValue.increment(10),
                                 'favorites': FieldValue.arrayUnion([item.id])
                               }, SetOptions(merge: true));
                               
                               // 2. Log community action for the Gamification Leaderboard
                               await FirebaseFirestore.instance.collection('community_actions').add({
                                 'userId': user.uid,
                                 'userName': user.fullname.isEmpty ? user.username : user.fullname,
                                 'userPhoto': user.photoUrl,
                                 'actionType': 'support',
                                 'targetId': item.id,
                                 'targetName': item.name,
                                 'pointsAwarded': 10,
                                 'timestamp': FieldValue.serverTimestamp()
                               });

                               Get.snackbar(
                                 "Support Logged! 🏆", 
                                 "+10 Community Points! ${item.name} added to your Favorites.",
                                 backgroundColor: Colors.pinkAccent.withValues(alpha: 0.9),
                                 colorText: Colors.white,
                                 snackPosition: SnackPosition.TOP,
                                 duration: const Duration(seconds: 4),
                               );
                             } catch (e) {
                               Get.snackbar('Error', 'Could not save support: $e');
                             }
                          },
                        ),
                        const SizedBox(height: 24),
                        _SideAction(
                          icon: Icons.share,
                          label: 'Share',
                          onTap: () {
                             Get.snackbar("Shared", "Link copied to clipboard!");
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _SideAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SideAction({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.black45, shape: BoxShape.circle, border: Border.all(color: Colors.white24)),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

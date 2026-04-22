import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:b2bmobile/models/business.dart';
import 'package:b2bmobile/models/detail_item_extensions.dart';
import 'package:b2bmobile/Screens/pages/universal_detail_screen.dart';

class RFPPitchesScreen extends StatelessWidget {
  final String rfpId;
  final String rfpTitle;

  const RFPPitchesScreen({super.key, required this.rfpId, required this.rfpTitle});

  Future<void> _launchEmail(String email, String title, String name) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        'subject': 'Re: Pitch for $title',
        'body': 'Hi $name,\n\nI reviewed your pitch for my RFP "$title" on the B2B Service Board and would love to connect to discuss further!\n\nBest,\n',
      },
    );
    if (!await launchUrl(emailLaunchUri)) {
      Get.snackbar('Error', 'Could not launch email app.', backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }

  Future<void> _viewBusinessDetails(String businessId) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('businesses').doc(businessId).get();
      if (!doc.exists) return;
      final business = Business.fromMap(doc.data() as Map<String, dynamic>);
      Get.to(() => UniversalDetailScreen(item: business.toDetailItem()));
    } catch (e) {
      Get.snackbar('Error', 'Could not load business details.', backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text('Inbox: Pitches', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text('Reviewing pitches for:\n"$rfpTitle"', style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4)),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('rfps')
                  .doc(rfpId)
                  .collection('pitches')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Colors.white));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No pitches received yet.", style: TextStyle(color: Colors.white54)));
                }

                final docs = snapshot.data!.docs;

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  itemCount: docs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    final String name = data['pitcherName'] ?? 'Unknown User';
                    final String photo = data['pitcherPhoto'] ?? '';
                    final String businessName = data['businessName'] ?? 'Verified Business';
                    final String businessId = data['businessId'] ?? '';
                    final String email = data['businessEmail'] ?? '';

                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF141414),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: const Color(0xFF1E1E1E),
                                backgroundImage: photo.isNotEmpty ? NetworkImage(photo) : null,
                                child: photo.isEmpty ? const Icon(Icons.person, color: Colors.white30) : null,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(name, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 4),
                                    Text("Represents: $businessName", style: const TextStyle(color: Colors.blueAccent, fontSize: 13, fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.storefront, size: 16, color: Colors.black),
                                  label: const Text('View Profile', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
                                  onPressed: () => _viewBusinessDetails(businessId),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.mail_outline, size: 16, color: Colors.white),
                                  label: const Text('Connect', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, padding: const EdgeInsets.symmetric(vertical: 12)),
                                  onPressed: () => _launchEmail(email, rfpTitle, name),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:b2bmobile/providers/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:b2bmobile/models/business.dart';

class DigitalBlackCardScreen extends StatelessWidget {
  const DigitalBlackCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<UserProvider>(context, listen: false).userModel;
    
    if (userModel == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: Text("Please log in to view your Digital Black Card.", style: TextStyle(color: Colors.white))),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("B2B Black Card", style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white70),
            onPressed: () => _showPointsInfo(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(userModel.uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>?;
          final int points = (data?['points'] as num? ?? 0).toInt();
          final String name = userModel.fullname.isNotEmpty ? userModel.fullname : userModel.username;
          
          String tier = "MEMBER";
          Color topGradient = const Color(0xFF333333);
          Color bottomGradient = Colors.black;
          Color accentColor = Colors.white54;

          if (points >= 5000) {
            tier = "ELITE";
            topGradient = const Color(0xFF1F1C18);
            bottomGradient = const Color(0xFF000000);
            accentColor = const Color(0xFFFFD700); // Gold
          } else if (points >= 1500) {
            tier = "GOLD";
            topGradient = const Color(0xFF2A241A);
            bottomGradient = const Color(0xFF000000);
            accentColor = const Color(0xFFD4AF37); // Light Gold
          } else if (points >= 500) {
            tier = "SILVER";
            topGradient = const Color(0xFF2B2B2B);
            bottomGradient = const Color(0xFF000000);
            accentColor = const Color(0xFFC0C0C0); // Silver
          }

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Show this card at participating Black-owned businesses to receive community appreciation rewards.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white54, fontSize: 13, height: 1.5),
                  ),
                  const SizedBox(height: 40),
                  
                  // The 3D Card
                  Container(
                    height: 220,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [topGradient, bottomGradient],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: accentColor.withValues(alpha: 0.3), width: 1.5),
                      boxShadow: [
                        BoxShadow(color: accentColor.withValues(alpha: 0.15), blurRadius: 30, offset: const Offset(0, 15)),
                        const BoxShadow(color: Colors.black, blurRadius: 10, offset: Offset(0, -5), spreadRadius: -5),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Opacity(
                            opacity: 0.05,
                            child: Image.network('https://www.transparenttextures.com/patterns/cubes.png', repeat: ImageRepeat.repeat),
                          ),
                        ),
                        Positioned(
                          top: 30,
                          left: 24,
                          child: Container(
                            width: 45,
                            height: 35,
                            decoration: BoxDecoration(
                              color: accentColor.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: accentColor.withValues(alpha: 0.5)),
                            ),
                            child: Icon(Icons.wifi_rounded, color: accentColor.withValues(alpha: 0.7), size: 20),
                          ),
                        ),
                        Positioned(
                          top: 38,
                          left: 85,
                          child: Icon(Icons.contactless_outlined, color: Colors.white38, size: 24),
                        ),
                        Positioned(
                          top: 30,
                          right: 24,
                          child: Text(
                            "BACK 2 BLACK",
                            style: GoogleFonts.bebasNeue(color: accentColor, fontSize: 24, letterSpacing: 2.0),
                          ),
                        ),
                        Positioned(
                          bottom: 30,
                          left: 24,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "MEMBER NAME",
                                style: GoogleFonts.outfit(color: Colors.white38, fontSize: 9, letterSpacing: 1.5, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                name.toUpperCase(),
                                style: GoogleFonts.outfit(color: Colors.white, fontSize: 18, letterSpacing: 2.0, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 30,
                          right: 24,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                tier,
                                style: GoogleFonts.outfit(color: accentColor, fontSize: 13, letterSpacing: 2.5, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "$points PTS",
                                style: GoogleFonts.outfit(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.qr_code_2_rounded, size: 120, color: Colors.black87),
                        const SizedBox(height: 8),
                        Text(userModel.uid.substring(0, 8).toUpperCase(), style: GoogleFonts.robotoMono(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text("Member ID", style: TextStyle(color: Colors.white38, fontSize: 12, letterSpacing: 2.0)),
                  const SizedBox(height: 40),
                  _buildRewardsSection(context, points),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showPointsInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Points System 🏆", style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Earn Community Points by supporting verified Black-owned businesses and engaging with the community.",
                style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4)),
              const SizedBox(height: 20),
              _pointRow("Register Business", "+50 PTS"),
              _pointRow("Pulse Support", "+10 PTS"),
              _pointRow("Daily Engagement", "+5 PTS"),
              const Divider(color: Colors.white12, height: 32),
              _tierRow("ELITE", "5000+ PTS", const Color(0xFFFFD700)),
              _tierRow("GOLD", "1500+ PTS", const Color(0xFFD4AF37)),
              _tierRow("SILVER", "500+ PTS", const Color(0xFFC0C0C0)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Got it", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _pointRow(String label, String pointsLabel) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
          Text(pointsLabel, style: GoogleFonts.outfit(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildRewardsSection(BuildContext context, int points) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.card_giftcard_rounded, color: Colors.blueAccent, size: 20),
            const SizedBox(width: 12),
            Text(
              "COMMUNITY PERKS",
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          points < 500 
            ? "Reach Silver (500 PTS) to unlock exclusive community rewards."
            : "Showing exclusive perks available for your current tier.",
          style: const TextStyle(color: Colors.white38, fontSize: 12),
        ),
        const SizedBox(height: 24),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('businesses')
              .where('offersRewards', isEqualTo: true)
              .where('isVerified', isEqualTo: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Colors.white24));
            }
            final docs = snapshot.data?.docs ?? [];
            if (docs.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white12),
                ),
                child: const Center(
                  child: Text("No community rewards active yet. Check back soon!",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white54, fontSize: 14)),
                ),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final business = Business.fromMap(docs[index].data() as Map<String, dynamic>);
                String reward = "";
                Color rewardColor = Colors.white54;
                String tierName = "";

                if (points >= 5000) {
                  reward = business.eliteReward;
                  rewardColor = Colors.amber;
                  tierName = "ELITE PERK";
                } else if (points >= 1500) {
                  reward = business.goldReward;
                  rewardColor = const Color(0xFFD4AF37);
                  tierName = "GOLD PERK";
                } else if (points >= 500) {
                  reward = business.silverReward;
                  rewardColor = const Color(0xFFC0C0C0);
                  tierName = "SILVER PERK";
                }

                if (reward.isEmpty) return const SizedBox.shrink();

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF141414),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(12),
                          image: business.imageUrls.isNotEmpty 
                            ? DecorationImage(
                                image: NetworkImage(business.imageUrls[0]),
                                fit: BoxFit.cover,
                              )
                            : null,
                        ),
                        child: business.imageUrls.isEmpty 
                          ? const Icon(Icons.business, color: Colors.white24, size: 20) 
                          : null,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(business.businessName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                            const SizedBox(height: 2),
                            Text(business.businessCategory, style: const TextStyle(color: Colors.white38, fontSize: 11)),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: rewardColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: rewardColor.withValues(alpha: 0.3)),
                              ),
                              child: Text(
                                "$tierName: $reward",
                                style: GoogleFonts.outfit(color: rewardColor, fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white24, size: 14),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _tierRow(String label, String requirement, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6), border: Border.all(color: color.withValues(alpha: 0.5))),
            child: Text(label, style: GoogleFonts.outfit(color: color, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
          ),
          const Spacer(),
          Text(requirement, style: const TextStyle(color: Colors.white38, fontSize: 12)),
        ],
      ),
    );
  }
}

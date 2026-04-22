import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "Community Impact",
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .orderBy('points', descending: true)
                  .limit(50)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Colors.white));
                }
                
                if (snapshot.hasError) {
                   return const Center(child: Text("Unable to load leaderboard.", style: TextStyle(color: Colors.white)));
                }

                final docs = snapshot.data?.docs ?? [];
                // Filter out users with 0 or null points just in case
                final rankedUsers = docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return (data['points'] ?? 0) > 0;
                }).toList();

                if (rankedUsers.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Text(
                        "No points logged yet! Be the first to hit the Pulse feed and support a business to claim #1.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white54, fontSize: 16, height: 1.5),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  itemCount: rankedUsers.length,
                  itemBuilder: (context, index) {
                    final data = rankedUsers[index].data() as Map<String, dynamic>;
                    final int points = data['points'] ?? 0;
                    final String name = data['fullname'] != null && data['fullname'].toString().isNotEmpty
                        ? data['fullname']
                        : (data['username'] ?? 'Anonymous');
                    final String photoUrl = data['photoUrl'] ?? '';

                    return _LeaderboardTile(
                      rank: index + 1,
                      name: name,
                      points: points,
                      photoUrl: photoUrl,
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

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.black, const Color(0xFF141414)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: const Border(bottom: BorderSide(color: Colors.white12)),
      ),
      child: Column(
        children: [
          const Icon(Icons.emoji_events_rounded, color: Colors.amber, size: 48),
          const SizedBox(height: 12),
          Text(
            "THE WALL OF IMPACT",
            style: GoogleFonts.outfit(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          const SizedBox(height: 8),
          const Text(
            "Support verified businesses on The Pulse to earn Community Points and climb the ranks.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white54, fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }
}

class _LeaderboardTile extends StatelessWidget {
  final int rank;
  final String name;
  final int points;
  final String photoUrl;

  const _LeaderboardTile({
    required this.rank,
    required this.name,
    required this.points,
    required this.photoUrl,
  });

  @override
  Widget build(BuildContext context) {
    bool isTop3 = rank <= 3;
    Color rankColor;
    if (rank == 1) {
      rankColor = Colors.amber;
    } else if (rank == 2) {
      rankColor = Colors.blueGrey.shade300;
    } else if (rank == 3) {
      rankColor = Colors.brown.shade300;
    } else {
      rankColor = Colors.white54;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isTop3 ? rankColor.withValues(alpha: 0.1) : const Color(0xFF141414),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isTop3 ? rankColor.withValues(alpha: 0.3) : Colors.white12),
        boxShadow: isTop3 ? [
          BoxShadow(color: rankColor.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))
        ] : [],
      ),
      child: Row(
        children: [
          // Rank
          SizedBox(
            width: 30,
            child: Text(
              "#$rank",
              style: GoogleFonts.outfit(
                color: rankColor,
                fontSize: isTop3 ? 20 : 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // Avatar
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white12,
            backgroundImage: photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null,
            child: photoUrl.isEmpty ? const Icon(Icons.person, color: Colors.white54) : null,
          ),
          const SizedBox(width: 16),
          
          // Name & Tier
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: isTop3 ? Colors.white : Colors.white70,
                    fontSize: 16,
                    fontWeight: isTop3 ? FontWeight.bold : FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (points >= 500) 
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      children: [
                        Icon(
                          points >= 5000 ? Icons.workspace_premium : (points >= 1500 ? Icons.stars : Icons.military_tech),
                          color: points >= 5000 ? Colors.amber : (points >= 1500 ? const Color(0xFFD4AF37) : const Color(0xFFC0C0C0)),
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          points >= 5000 ? 'ELITE CONTRIBUTOR' : (points >= 1500 ? 'GOLD MEMBER' : 'SILVER MEMBER'),
                          style: GoogleFonts.outfit(
                            color: points >= 5000 ? Colors.amber : (points >= 1500 ? const Color(0xFFD4AF37) : const Color(0xFFC0C0C0)),
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          
          // Points
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
            ),
            child: Text(
              "$points PTS",
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:b2bmobile/models/review.dart';
import 'package:b2bmobile/widgets/add_review_bottom_sheet.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:b2bmobile/providers/user_provider.dart';
import 'package:b2bmobile/utils/utils.dart';
class ReviewListWidget extends StatelessWidget {
  final String targetId;
  const ReviewListWidget({super.key, required this.targetId});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "COMMUNITY REVIEWS",
              style: TextStyle(color: Color(0xFF8E8E93), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5),
            ),
            GestureDetector(
              onTap: () {
                final userProvider = Provider.of<UserProvider>(context, listen: false);
                if (checkGuestAccess(context, userProvider.userModel?.isGuest ?? true)) return;
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (ctx) => AddReviewBottomSheet(targetId: targetId),
                );
              },
              child: const Text("+ LEAVE REVIEW", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('reviews')
              .where('targetId', isEqualTo: targetId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Colors.white24));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 32),
                decoration: BoxDecoration(color: const Color(0xFF141414), borderRadius: BorderRadius.circular(16)),
                child: const Column(
                  children: [
                    Icon(Icons.star_outline, color: Colors.white24, size: 40),
                    SizedBox(height: 12),
                    Text("No reviews yet. Be the first to share your experience!", style: TextStyle(color: Colors.white54, fontSize: 12)),
                  ],
                ),
              );
            }

            final reviews = snapshot.data!.docs
                .map((doc) => Review.fromMap(doc.data() as Map<String, dynamic>))
                .where((r) => r.moderationStatus != 'shadowed')
                .toList();
            reviews.sort((a, b) => b.timestamp.compareTo(a.timestamp));
            
            // Calculate average rating
            double avgRating = 0;
            if (reviews.isNotEmpty) {
               avgRating = reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length;
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      avgRating.toStringAsFixed(1),
                      style: GoogleFonts.outfit(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              index < avgRating.round() ? Icons.star : Icons.star_border,
                              color: Colors.amber,
                              size: 16,
                            );
                          }),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Based on ${reviews.length} reviews",
                          style: const TextStyle(color: Colors.white54, fontSize: 11),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: reviews.length,
                  separatorBuilder: (context, index) => const Divider(color: Colors.white10, height: 30),
                  itemBuilder: (context, index) {
                    final review = reviews[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: const Color(0xFF1E1E1E),
                              backgroundImage: review.userPhoto.isNotEmpty ? NetworkImage(review.userPhoto) : null,
                              child: review.userPhoto.isEmpty ? const Icon(Icons.person, color: Colors.white30, size: 16) : null,
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(review.userName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                                    if (review.isAIVerified) ...[
                                      const SizedBox(width: 6),
                                      const Icon(Icons.verified, color: Colors.blueAccent, size: 12),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                            const Spacer(),
                            Row(
                              children: List.generate(5, (sIndex) {
                                return Icon(
                                  sIndex < review.rating ? Icons.star : Icons.star_border,
                                  color: Colors.amber,
                                  size: 14,
                                );
                              }),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          review.comment,
                          style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
                        ),
                      ],
                    );
                  },
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

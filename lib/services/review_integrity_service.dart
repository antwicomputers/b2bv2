import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:b2bmobile/models/review.dart';
import 'package:b2bmobile/models/users.dart';

class ReviewIntegrityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Analyzes a submitted review for authenticity and content quality.
  /// Returns a 'Review' object with AI-calculated trust metadata.
  Future<Review> analyzeReview(Review rawReview, UserModel user) async {
    // 1. Behavioral Check: Did the user interact with this business?
    bool isInteracted = user.viewedBusinesses.contains(rawReview.targetId);

    // 2. Trust Scoring Logic
    double score = 1.0;
    String status = 'none';

    // Penalize short, generic reviews
    if (rawReview.comment.length < 15) {
      score -= 0.3;
    }

    // Sentiment Heuristic: Check for common "spammy" patterns
    final spamKeywords = ['earn money', 'follow me', 'free clicks', 'discount code'];
    for (var keyword in spamKeywords) {
      if (rawReview.comment.toLowerCase().contains(keyword)) {
        score -= 0.6;
        status = 'flagged';
      }
    }

    // Shadowing Check: Automatically hide low-quality reviews for later review
    if (score < 0.4) {
      status = 'shadowed';
    }

    return Review(
      id: rawReview.id,
      targetId: rawReview.targetId,
      userId: rawReview.userId,
      userName: rawReview.userName,
      userPhoto: rawReview.userPhoto,
      rating: rawReview.rating,
      comment: rawReview.comment,
      imageUrl: rawReview.imageUrl,
      timestamp: rawReview.timestamp,
      isAIVerified: isInteracted,
      trustScore: score.clamp(0.0, 1.0),
      moderationStatus: status,
    );
  }

  /// Automatically flags suspicious review patterns for a specific business.
  Future<void> monitorReviewSpikes(String targetId) async {
    // Logic to detect if a business is getting suspicious spikes in 1-star or 5-star reviews
    // within a very short timeframe — signaling a potential bot attack.
    final now = DateTime.now();
    final hourAgo = now.subtract(const Duration(hours: 1));

    final snapshot = await _firestore
        .collection('reviews')
        .where('targetId', isEqualTo: targetId)
        .where('timestamp', isGreaterThan: hourAgo)
        .get();

    if (snapshot.docs.length > 50) {
      // Potentially an attack. Flag these reviews for secondary AI analysis.
      for (var doc in snapshot.docs) {
        await doc.reference.update({'moderationStatus': 'flagged'});
      }
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:b2bmobile/models/business.dart';
import 'package:b2bmobile/models/users.dart';

class MatchmakingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Returns a list of businesses tailored to the specific user's interests 
  /// and past behavior.
  Future<List<Business>> getPersonalizedRecommendations(UserModel user, {int limit = 10}) async {
    try {
      // 1. Fetch all verified businesses
      QuerySnapshot query = await _firestore
          .collection('businesses')
          .where('isVerified', isEqualTo: true)
          .limit(50) // Fetch a pool to filter from
          .get();

      List<Business> allBusinesses = query.docs
          .map((doc) => Business.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      // 2. Score each business based on user profile
      List<ScoredBusiness> scoredList = allBusinesses.map((business) {
        double score = 0;

        // Interest Match: High weight
        if (user.interests.contains(business.businessCategory)) {
          score += 10.0;
        }

        // Behavioral Match: Medium weight
        // If they viewed a business in this category before
        bool seenCategory = user.viewedBusinesses.any((id) {
          // This would ideally be a category-lookup, but we'll approximate with ID matches for now
          return id == business.businessId; 
        });
        if (seenCategory) score += 5.0;

        // "Elite" or Featured Boost: Low weight
        if (business.isFeatured) score += 2.0;
        if (business.offersRewards) score += 1.5;

        return ScoredBusiness(business, score);
      }).toList();

      // 3. Sort by score and take the top matches
      scoredList.sort((a, b) => b.score.compareTo(a.score));

      return scoredList.map((e) => e.business).take(limit).toList();
    } catch (e) {
      print("Matchmaking Error: $e");
      return [];
    }
  }

  /// Automatically track that a user has viewed a business to improve future AI matches.
  Future<void> trackBusinessView(String userId, String businessId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'viewedBusinesses': FieldValue.arrayUnion([businessId])
      });
    } catch (e) {
      print("Error tracking view: $e");
    }
  }
}

class ScoredBusiness {
  final Business business;
  final double score;
  ScoredBusiness(this.business, this.score);
}

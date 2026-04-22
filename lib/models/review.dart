import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String id;
  final String targetId; // ID of the business/event/support
  final String userId;
  final String userName;
  final String userPhoto;
  final double rating;
  final String comment;
  final String imageUrl;
  final DateTime timestamp;

  final bool isAIVerified;
  final double trustScore; // 0.0 to 1.0
  final String moderationStatus; // 'none', 'flagged', 'shadowed'

  Review({
    required this.id,
    required this.targetId,
    required this.userId,
    required this.userName,
    required this.userPhoto,
    required this.rating,
    required this.comment,
    required this.imageUrl,
    required this.timestamp,
    this.isAIVerified = false,
    this.trustScore = 1.0,
    this.moderationStatus = 'none',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'targetId': targetId,
      'userId': userId,
      'userName': userName,
      'userPhoto': userPhoto,
      'rating': rating,
      'comment': comment,
      'imageUrl': imageUrl,
      'timestamp': timestamp,
      'isAIVerified': isAIVerified,
      'trustScore': trustScore,
      'moderationStatus': moderationStatus,
    };
  }

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      id: map['id'] ?? '',
      targetId: map['targetId'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? 'Anonymous',
      userPhoto: map['userPhoto'] ?? '',
      rating: (map['rating'] ?? 5.0).toDouble(),
      comment: map['comment'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      timestamp: map['timestamp'] != null 
          ? (map['timestamp'] is Timestamp ? (map['timestamp'] as Timestamp).toDate() : DateTime.now())
          : DateTime.now(),
      isAIVerified: map['isAIVerified'] ?? false,
      trustScore: (map['trustScore'] ?? 1.0).toDouble(),
      moderationStatus: map['moderationStatus'] ?? 'none',
    );
  }
}

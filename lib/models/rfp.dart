import 'package:cloud_firestore/cloud_firestore.dart';

class RFP {
  final String id;
  final String authorId;
  final String authorName;
  final String authorPhoto;
  final String title;
  final String description;
  final String category; // e.g., 'Accounting', 'Legal', 'Marketing', 'Design'
  final String budget;
  final DateTime timestamp;
  final bool isActive;

  RFP({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.authorPhoto,
    required this.title,
    required this.description,
    required this.category,
    required this.budget,
    required this.timestamp,
    required this.isActive,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'authorId': authorId,
      'authorName': authorName,
      'authorPhoto': authorPhoto,
      'title': title,
      'description': description,
      'category': category,
      'budget': budget,
      'timestamp': timestamp,
      'isActive': isActive,
    };
  }

  factory RFP.fromMap(Map<String, dynamic> map) {
    return RFP(
      id: map['id'] ?? '',
      authorId: map['authorId'] ?? '',
      authorName: map['authorName'] ?? 'Anonymous',
      authorPhoto: map['authorPhoto'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      budget: map['budget'] ?? 'Negotiable',
      timestamp: map['timestamp'] != null 
          ? (map['timestamp'] is Timestamp ? (map['timestamp'] as Timestamp).toDate() : DateTime.now())
          : DateTime.now(),
      isActive: map['isActive'] ?? true,
    );
  }
}

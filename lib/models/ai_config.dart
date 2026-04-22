import 'package:cloud_firestore/cloud_firestore.dart';

class AIConfig {
  final bool isConciergeEnabled;
  final bool isReviewerEnabled;
  final String providerUrl; // For OpenClaw or backend endpoint

  AIConfig({
    required this.isConciergeEnabled,
    required this.isReviewerEnabled,
    required this.providerUrl,
  });

  factory AIConfig.fromMap(Map<String, dynamic> map) {
    return AIConfig(
      isConciergeEnabled: map['isConciergeEnabled'] ?? false,
      isReviewerEnabled: map['isReviewerEnabled'] ?? false,
      providerUrl: map['providerUrl'] ?? '',
    );
  }

  static Future<AIConfig> fetch() async {
    final doc = await FirebaseFirestore.instance.collection('config').doc('ai_settings').get();
    if (!doc.exists) {
      return AIConfig(isConciergeEnabled: false, isReviewerEnabled: false, providerUrl: '');
    }
    return AIConfig.fromMap(doc.data()!);
  }
}

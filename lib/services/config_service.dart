import 'package:cloud_firestore/cloud_firestore.dart';

class ConfigService {
  static final ConfigService _instance = ConfigService._internal();
  factory ConfigService() => _instance;
  ConfigService._internal();

  /// Fetches a sensitive API key from the secure AppConfig collection.
  /// Ensure Firestore rules are set to restricted access for this collection.
  Future<String> getSecretKey(String keyName) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('AppConfig')
          .doc('secrets')
          .get();
      
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        final val = (data[keyName] as String?) ?? "";
        if (val.isNotEmpty) {
          print('✅ ConfigService: Successfully fetched $keyName');
        } else {
          print('⚠️ ConfigService: Key $keyName is empty in Firestore');
        }
        return val;
      }
      print('❌ ConfigService: Document AppConfig/secrets does not exist');
      return "";
    } catch (e) {
      print('❌ ConfigService: Error fetching $keyName: $e');
      return "";
    }
  }
}

import 'package:algolia/algolia.dart';
import '../services/config_service.dart';

class AlgoliaApplication {
  static Future<Algolia> instance() async {
    final appId = await ConfigService().getSecretKey('algolia_app_id');
    final apiKey = await ConfigService().getSecretKey('algolia_search_key');
    
    return Algolia.init(
      applicationId: appId.isNotEmpty ? appId : '7ID12WNW47', // Fallback for local testing if not in DB
      apiKey: apiKey.isNotEmpty ? apiKey : 'a505630b1ad41820d77a530672338433',
    );
  }
}

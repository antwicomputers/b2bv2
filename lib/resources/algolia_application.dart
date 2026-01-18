import 'package:algolia/algolia.dart';

class AlgoliaApplication {
  static const Algolia algolia = Algolia.init(
    applicationId: '7ID12WNW47', //ApplicationID
    apiKey:
        'a505630b1ad41820d77a530672338433', //search-only api key in flutter code
  );
}

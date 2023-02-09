// import 'package:cloud_firestore/cloud_firestore.dart';

// class Business {
//   bool isBlack;
//   String businessID;
//   String businessName;
//   String country;
//   String city;
//   String category;
//   String businessDescription;
//   String fullAddress;
//   String twitterAccount;
//   String linkedInAccount;
//   String instagramAccount;
//   String facebookAccount;
//   String phone;
//   String email;
//   String discordAccount;
//   String twitchAccount;
//   String website;
//   String youtube;
//   bool isFeatured = false;
//   int favouriteCount = 0;
//   List<String> favouritedBy = [];
//   DateTime dateCreated = DateTime.now();
//   String imgURL;
//   bool isVerified = false;
//   int reviewCount;
//   double rating;
//   GeoPoint location;
//   List<String> reviewedBy = [];
//   List<String> images = [];
//   List<String> searchFilters = [];
//   bool isWomenOriented;
//   bool isEssentials;
//   String registrantID;
//   String podcast;

//   Business({
//     this.businessID,
//     this.imgURL,
//     this.businessDescription,
//     this.businessName,
//     this.category,
//     this.city,
//     this.country,
//     this.facebookAccount,
//     this.fullAddress,
//     this.instagramAccount,
//     this.linkedInAccount,
//     this.twitterAccount,
//     this.phone,
//     this.email,
//     this.twitchAccount,
//     this.discordAccount,
//     this.website,
//     this.youtube,
//     this.reviewCount,
//     this.location,
//     this.rating,
//     this.reviewedBy,
//     this.images,
//     this.isBlack,
//     this.searchFilters,
//     this.isWomenOriented,
//     this.isEssentials,
//     this.registrantID,
//     this.podcast,
//   }) {
//     dateCreated = DateTime.now();
//   }

//   Map<String, dynamic> toJson() => {
//         'isBlack': isBlack,
//         'reviewCount': reviewCount,
//         'location': location,
//         'rating': rating,
//         'reviewedBy': reviewedBy,
//         'youtube': youtube,
//         'website': website,
//         'phone': phone,
//         'email': email,
//         'twitchAccount': twitchAccount,
//         'discordAccount': discordAccount,
//         'timeStamp': FieldValue.serverTimestamp(),
//         'isVerified': isVerified,
//         'businessID': businessID,
//         'imgURL': imgURL,
//         'businessName': businessName,
//         'country': country,
//         'city': city,
//         'category': category,
//         'businessDescription': businessDescription,
//         'fullAddress': fullAddress,
//         'twitterAccount': twitterAccount,
//         'linkedInAccount': linkedInAccount,
//         'instagramAccount': instagramAccount,
//         'facebookAccount': facebookAccount,
//         'isFeatured': isFeatured,
//         'favouriteCount': favouriteCount,
//         'favouritedBy': favouritedBy,
//         'dateCreated': dateCreated.toIso8601String(),
//         'images': images,
//         'searchFilters': List.generate(fullAddress.split(',').length,
//             (index) => fullAddress.split(',')[index].trim()),
//         'isWomenOriented': isWomenOriented,
//         'isEssentials': isEssentials,
//         'registrantID': registrantID,
//         'podcast': podcast,
//       };

//   Map<String, dynamic> toJsonForSearch() => {
//         'isBlack': isBlack ?? true,
//         'reviewCount': reviewCount,
//         'rating': rating ?? 5.0,
//         'reviewedBy': reviewedBy,
//         'youtube': youtube,
//         'website': website,
//         'phone': phone,
//         'email': email,
//         'twitchAccount': twitchAccount,
//         'discordAccount': discordAccount,
//         // 'timeStamp': FieldValue.serverTimestamp(),
//         'isVerified': isVerified,
//         'businessID': businessID,
//         'imgURL': imgURL,
//         'businessName': businessName,
//         'country': country,
//         'city': city,
//         'category': category,
//         'businessDescription': businessDescription,
//         'fullAddress': fullAddress,
//         'twitterAccount': twitterAccount,
//         'linkedInAccount': linkedInAccount,
//         'instagramAccount': instagramAccount,
//         'facebookAccount': facebookAccount,
//         'isFeatured': isFeatured,
//         'favouriteCount': favouriteCount,
//         'favouritedBy': favouritedBy,
//         'dateCreated': dateCreated.toIso8601String(),
//         'images': images,
//         'searchFilters': List.generate(fullAddress.split(',').length,
//             (index) => fullAddress.split(',')[index].trim()),
//         'isWomenOriented': isWomenOriented,
//         'isEssentials': isEssentials,
//         'registrantID': registrantID,
//       };

//   Business.fromJson(Map<String, dynamic> json) {
//     searchFilters = json['searchFilters']?.cast<String>() ?? [];
//     json['images'] != null
//         ? images = json['images'].cast<String>()
//         : images = [];
//     reviewCount = json['reviewCount'] ?? 0;
//     location = json['location'] ?? null;
//     rating = double.tryParse(json['rating'].toString()) ?? 5.0;
//     json['reviewedBy'] != null
//         ? reviewedBy = json['reviewedBy'].cast<String>()
//         : reviewedBy = [];
//     youtube = json['youtube'] ?? "";
//     website = json['website'] ?? "";
//     phone = json['phone'] ?? "";
//     email = json['email'] ?? "";
//     twitchAccount = json['twitchAccount'] ?? "";
//     discordAccount = json['discordAccount'] ?? "";
//     isVerified = json['isVerified'] ?? false;
//     businessID = json['businessID'];
//     imgURL = json['imgURL'];
//     businessName = json['businessName'];
//     country = json['country'];
//     city = json['city'];
//     category = json['category'];
//     businessDescription = json['businessDescription'];
//     fullAddress = json['fullAddress'];
//     twitterAccount = json['twitterAccount'];
//     linkedInAccount = json['linkedInAccount'];
//     instagramAccount = json['instagramAccount'];
//     facebookAccount = json['facebookAccount'];
//     isFeatured = json['isFeatured'] ?? false;
//     favouriteCount = json['favouriteCount'];
//     favouritedBy = json['favouritedBy'].cast<String>();
//     dateCreated = DateTime.parse(json['dateCreated']);
//     isBlack = json['isBlack'] ?? true;
//     isWomenOriented = json['isWomenOriented'] ?? false;
//     isEssentials = json['isEssentials'] ?? false;
//     registrantID = json['registrantID'] ?? '';
//     podcast = json['podcast'] ?? "";
//   }

//   static Business getDummy() {
//     return Business(
//       businessDescription:
//           "Test description Test descriptionTest descriptionTest descriptionTest descriptionTest descriptionTest descriptionTest description",
//       businessName: "test business name",
//       category: "Fashion",
//       city: "Lahore",
//       country: "Pakistan",
//       facebookAccount: "zubairasdasd",
//       fullAddress: "123 A Block, DHA Lahore, Pakistan",
//       instagramAccount: "zubi1001",
//       linkedInAccount: "zubi1001",
//       twitterAccount: "zubi1001",
//     );
//   }

//   factory Business.fromMap(Map<String, dynamic> map) {
//     if (map == null || map.isEmpty) return null;
//     return Business.fromJson(map);
//   }
// }
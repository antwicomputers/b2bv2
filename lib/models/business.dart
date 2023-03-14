import 'package:cloud_firestore/cloud_firestore.dart';

class Business {
  final String businessName;
  final String businessDescription;
  final String businessAddress;
  final String businessCategory;
  final String phone;
  final String email;
  final String website;
  final String twitter;
  final String facebook;
  final String linkedIn;
  final String instagram;
  final String tiktok;
  final String twitch;
  final String podcast;
  final String businessUrl;

  const Business({
    required this.businessName,
    required this.businessDescription,
    required this.businessAddress,
    required this.businessCategory,
    required this.phone,
    required this.email,
    required this.website,
    required this.twitter,
    required this.facebook,
    required this.linkedIn,
    required this.instagram,
    required this.tiktok,
    required this.twitch,
    required this.podcast,
    required this.businessUrl,
  });

  Map<String, dynamic> toJson() => {
        'timestamp': FieldValue.serverTimestamp(),
        'businessName': businessName,
        'businessDescription': businessDescription,
        'businessAddress': businessAddress,
        'businessCategory': businessCategory,
        'phone': phone,
        'email': email,
        'website': website,
        'twitter': twitter,
        'facebook': facebook,
        'linkedIn': linkedIn,
        'instagram': instagram,
        'tikTok': tiktok,
        'twitch': twitch,
        'podcast': podcast,
        'businessUrl': businessUrl
      };

  static Business fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Business(
      businessName: snapshot['businessName'],
      businessDescription: snapshot['businessDescription'],
      businessAddress: snapshot['businessAddress'],
      businessCategory: snapshot['businessCategory'],
      phone: snapshot['phone'],
      email: snapshot['email'],
      website: snapshot['website'],
      twitter: snapshot['twitter'],
      facebook: snapshot['facebook'],
      linkedIn: snapshot['linkedIn'],
      instagram: snapshot['instagram'],
      tiktok: snapshot['tiktok'],
      twitch: snapshot['twitch'],
      podcast: snapshot['podcast'],
      businessUrl: snapshot['businessUrl'],
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class Business {
  final String businessName;
  final String uid;
  final String country;
  final String city;
  final String category;
  final String address;
  final String twitter;
  final String linkedIn;
  final String instagram;
  final String facebook;
  final String businessDescription;
  final String podcast;

  const Business({
    required this.businessName,
    required this.uid,
    required this.country,
    required this.city,
    required this.category,
    required this.address,
    required this.businessDescription,
    required this.twitter,
    required this.linkedIn,
    required this.instagram,
    required this.facebook,
    required this.podcast,
  });

  Map<String, dynamic> toJson() => {
        'businessName': businessName,
        'uid': uid,
        'country': country,
        'city': city,
        'category': category,
        'address': address,
        'twitter': twitter,
        'linkedIn': linkedIn,
        'instagram': instagram,
        'facebook': facebook,
        'businessDescription': businessDescription,
        'podcast': podcast,
      };

  static Business fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Business(
      businessName: snapshot['businessName'],
      uid: snapshot['uid'],
      country: snapshot['country'],
      city: snapshot['city'],
      category: snapshot['category'],
      address: snapshot['address'],
      twitter: snapshot['twitter'],
      linkedIn: snapshot['linkedIn'],
      instagram: snapshot['instagram'],
      facebook: snapshot['facebook'],
      businessDescription: snapshot['businessDescription'],
      podcast: snapshot['podcast'],
    );
  }
}

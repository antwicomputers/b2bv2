import 'package:cloud_firestore/cloud_firestore.dart';

class Events {
  final String eventName;
  final String eventDescription;
  final String eventAddress;
  final String eventCategory;
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

  const Events(
      {required this.eventName,
      required this.eventDescription,
      required this.eventAddress,
      required this.eventCategory,
      required this.phone,
      required this.email,
      required this.website,
      required this.twitter,
      required this.facebook,
      required this.linkedIn,
      required this.instagram,
      required this.tiktok,
      required this.twitch,
      required this.podcast});

  Map<String, dynamic> toJson() => {
        'timestamp': FieldValue.serverTimestamp(),
        'eventName': eventName,
        'eventDescription': eventDescription,
        'eventAddress': eventAddress,
        'eventCategory': eventCategory,
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
      };

  static Events fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Events(
      eventName: snapshot['eventName'],
      eventDescription: snapshot['eventDescription'],
      eventAddress: snapshot['eventAddress'],
      eventCategory: snapshot['eventCategory'],
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
    );
  }
}

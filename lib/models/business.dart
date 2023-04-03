import 'dart:convert';

class Business {
  final String businessName;
  final String businessDescription;
  final String businessAddress;
  final String businessCategory;
  final String businessId;
  final String userId;
  final DateTime? createdAt;
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
  final bool isBlackOwned;
  final bool womenOriented;
  final bool isVerified;
  final bool isEsential;
  final bool isFeatured;
  final bool isSponsored;

  const Business({
    required this.businessName,
    required this.businessDescription,
    required this.businessAddress,
    required this.businessCategory,
    required this.createdAt,
    required this.phone,
    required this.isVerified,
    required this.businessId,
    required this.userId,
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
    required this.isBlackOwned,
    required this.womenOriented,
    required this.isEsential,
    required this.isFeatured,
    required this.isSponsored,
  });

  // Map<String, dynamic> toJson() => {
  //       'timestamp': FieldValue.serverTimestamp(),
  //       'businessName': businessName,
  //       'businessDescription': businessDescription,
  //       'businessAddress': businessAddress,
  //       'businessCategory': businessCategory,
  //       'phone': phone,
  //       'email': email,
  //       'website': website,
  //       'twitter': twitter,
  //       'facebook': facebook,
  //       'linkedIn': linkedIn,
  //       'instagram': instagram,
  //       'tikTok': tiktok,
  //       'twitch': twitch,
  //       'podcast': podcast,
  //       'businessUrl': businessUrl
  //     };

  // static Business fromSnap(DocumentSnapshot snap) {
  //   var snapshot = snap.data() as Map<String, dynamic>;

  //   return Business(
  //     businessName: snapshot['businessName'],
  //     businessDescription: snapshot['businessDescription'],
  //     businessAddress: snapshot['businessAddress'],
  //     businessCategory: snapshot['businessCategory'],
  //     phone: snapshot['phone'],
  //     email: snapshot['email'],
  //     website: snapshot['website'],
  //     twitter: snapshot['twitter'],
  //     facebook: snapshot['facebook'],
  //     linkedIn: snapshot['linkedIn'],
  //     instagram: snapshot['instagram'],
  //     tiktok: snapshot['tiktok'],
  //     twitch: snapshot['twitch'],
  //     podcast: snapshot['podcast'],
  //     businessUrl: snapshot['businessUrl'],
  //   );
  // }

  Business copyWith({
    String? businessName,
    String? businessDescription,
    String? businessAddress,
    String? businessCategory,
    DateTime? createdAt,
    String? phone,
    String? email,
    String? website,
    String? twitter,
    String? facebook,
    String? linkedIn,
    String? userId,
    String? instagram,
    String? tiktok,
    String? twitch,
    String? podcast,
    String? businessUrl,
    bool? isBlackOwned,
    bool? isVerified,
    bool? womenOriented,
    bool? isEsential,
    bool? isFeatured,
    String? businessId,
    bool? isSponsored,
  }) {
    return Business(
      businessName: businessName ?? this.businessName,
      businessDescription: businessDescription ?? this.businessDescription,
      businessAddress: businessAddress ?? this.businessAddress,
      businessCategory: businessCategory ?? this.businessCategory,
      createdAt: createdAt ?? this.createdAt,
      isVerified: isVerified ?? this.isVerified,
      phone: phone ?? this.phone,
      businessId: businessId ?? this.businessId,
      email: email ?? this.email,
      website: website ?? this.website,
      twitter: twitter ?? this.twitter,
      facebook: facebook ?? this.facebook,
      userId: userId ?? this.userId,
      linkedIn: linkedIn ?? this.linkedIn,
      instagram: instagram ?? this.instagram,
      tiktok: tiktok ?? this.tiktok,
      twitch: twitch ?? this.twitch,
      podcast: podcast ?? this.podcast,
      businessUrl: businessUrl ?? this.businessUrl,
      isBlackOwned: isBlackOwned ?? this.isBlackOwned,
      womenOriented: womenOriented ?? this.womenOriented,
      isEsential: isEsential ?? this.isEsential,
      isFeatured: isFeatured ?? this.isFeatured,
      isSponsored: isSponsored ?? this.isSponsored,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'businessName': businessName,
      'businessDescription': businessDescription,
      'businessAddress': businessAddress,
      'businessCategory': businessCategory,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'phone': phone,
      'email': email,
      'isVerified': isVerified,
      'website': website,
      'userId': userId,
      'twitter': twitter,
      'facebook': facebook,
      'linkedIn': linkedIn,
      'instagram': instagram,
      'tiktok': tiktok,
      'twitch': twitch,
      'businessId': businessId,
      'podcast': podcast,
      'businessUrl': businessUrl,
      'isBlackOwned': isBlackOwned,
      'womenOriented': womenOriented,
      'isEsential': isEsential,
      'isFeatured': isFeatured,
      'isSponsored': isSponsored,
    };
  }

  factory Business.fromMap(Map<String, dynamic> map) {
    return Business(
      businessName: map['businessName'] ?? '',
      businessDescription: map['businessDescription'] ?? '',
      businessAddress: map['businessAddress'] ?? '',
      businessCategory: map['businessCategory'] ?? '',
      createdAt: map['createdAt'] == null ? null : DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      phone: map['phone'] ?? '',
      businessId: map['businessId'] ?? '',
      email: map['email'] ?? '',
      website: map['website'] ?? '',
      userId: map['userId'] ?? '',
      twitter: map['twitter'] ?? '',
      facebook: map['facebook'] ?? '',
      isVerified: map['isVerified'] ?? false,
      linkedIn: map['linkedIn'] ?? '',
      instagram: map['instagram'] ?? '',
      tiktok: map['tiktok'] ?? '',
      twitch: map['twitch'] ?? '',
      podcast: map['podcast'] ?? '',
      businessUrl: map['businessUrl'] ?? '',
      isBlackOwned: map['isBlackOwned'] ?? false,
      womenOriented: map['womenOriented'] ?? false,
      isEsential: map['isEsential'] ?? false,
      isFeatured: map['isFeatured'] ?? false,
      isSponsored: map['isSponsored'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Business.fromJson(String source) => Business.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Business(businessName: $businessName, businessDescription: $businessDescription, businessAddress: $businessAddress, businessCategory: $businessCategory, createdAt: $createdAt, phone: $phone, email: $email, website: $website, twitter: $twitter, facebook: $facebook, linkedIn: $linkedIn, instagram: $instagram, tiktok: $tiktok, twitch: $twitch, podcast: $podcast, businessUrl: $businessUrl, isBlackOwned: $isBlackOwned, womenOriented: $womenOriented, isEsential: $isEsential, isFeatured: $isFeatured, isSponsored: $isSponsored)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Business &&
        other.businessName == businessName &&
        other.businessDescription == businessDescription &&
        other.businessAddress == businessAddress &&
        other.businessCategory == businessCategory &&
        other.createdAt == createdAt &&
        other.phone == phone &&
        other.email == email &&
        other.website == website &&
        other.twitter == twitter &&
        other.facebook == facebook &&
        other.linkedIn == linkedIn &&
        other.businessId == businessId &&
        other.userId == userId &&
        other.createdAt == createdAt &&
        other.isVerified == isVerified &&
        other.instagram == instagram &&
        other.tiktok == tiktok &&
        other.twitch == twitch &&
        other.podcast == podcast &&
        other.businessUrl == businessUrl &&
        other.isBlackOwned == isBlackOwned &&
        other.womenOriented == womenOriented &&
        other.isEsential == isEsential &&
        other.isFeatured == isFeatured &&
        other.isSponsored == isSponsored;
  }

  @override
  int get hashCode {
    return businessName.hashCode ^
        businessDescription.hashCode ^
        businessAddress.hashCode ^
        businessCategory.hashCode ^
        createdAt.hashCode ^
        phone.hashCode ^
        email.hashCode ^
        website.hashCode ^
        twitter.hashCode ^
        facebook.hashCode ^
        linkedIn.hashCode ^
        instagram.hashCode ^
        tiktok.hashCode ^
        twitch.hashCode ^
        isVerified.hashCode ^
        podcast.hashCode ^
        userId.hashCode ^
        createdAt.hashCode ^
        businessUrl.hashCode ^
        isBlackOwned.hashCode ^
        womenOriented.hashCode ^
        isEsential.hashCode ^
        isFeatured.hashCode ^
        isSponsored.hashCode;
  }
}

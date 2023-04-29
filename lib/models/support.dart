import 'dart:convert';

class Support {
  final String supportName;
  final String supportDescription;
  final String supportAddress;
  final String supportCategory;
  final String supportId;
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
  final String SupportUrl;
  final bool isBlackOwned;
  final String youtube;
  final bool womenOriented;
  final bool isVerified;
  final bool isEsential;
  final bool isFeatured;
  final bool isSponsored;

  const Support({
    required this.supportName,
    required this.supportDescription,
    required this.supportAddress,
    required this.supportCategory,
    required this.createdAt,
    required this.phone,
    required this.youtube,
    required this.isVerified,
    required this.supportId,
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
    required this.SupportUrl,
    required this.isBlackOwned,
    required this.womenOriented,
    required this.isEsential,
    required this.isFeatured,
    required this.isSponsored,
  });

  Support copyWith({
    String? SupportName,
    String? SupportDescription,
    String? SupportAddress,
    String? SupportCategory,
    DateTime? createdAt,
    String? phone,
    String? email,
    String? youtube,
    String? website,
    String? twitter,
    String? facebook,
    String? linkedIn,
    String? userId,
    String? instagram,
    String? tiktok,
    String? twitch,
    String? podcast,
    String? SupportUrl,
    bool? isBlackOwned,
    bool? isVerified,
    bool? womenOriented,
    bool? isEsential,
    bool? isFeatured,
    String? SupportId,
    bool? isSponsored,
  }) {
    return Support(
      supportName: SupportName ?? this.supportName,
      supportDescription: SupportDescription ?? this.supportDescription,
      supportAddress: SupportAddress ?? this.supportAddress,
      supportCategory: SupportCategory ?? this.supportCategory,
      createdAt: createdAt ?? this.createdAt,
      isVerified: isVerified ?? this.isVerified,
      phone: phone ?? this.phone,
      youtube: youtube ?? this.youtube,
      supportId: SupportId ?? this.supportId,
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
      SupportUrl: SupportUrl ?? this.SupportUrl,
      isBlackOwned: isBlackOwned ?? this.isBlackOwned,
      womenOriented: womenOriented ?? this.womenOriented,
      isEsential: isEsential ?? this.isEsential,
      isFeatured: isFeatured ?? this.isFeatured,
      isSponsored: isSponsored ?? this.isSponsored,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'SupportName': supportName,
      'SupportDescription': supportDescription,
      'SupportAddress': supportAddress,
      'SupportCategory': supportCategory,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'phone': phone,
      'email': email,
      'isVerified': isVerified,
      'website': website,
      'userId': userId,
      'youtube': youtube,
      'twitter': twitter,
      'facebook': facebook,
      'linkedIn': linkedIn,
      'instagram': instagram,
      'tiktok': tiktok,
      'twitch': twitch,
      'SupportId': supportId,
      'podcast': podcast,
      'SupportUrl': SupportUrl,
      'isBlackOwned': isBlackOwned,
      'womenOriented': womenOriented,
      'isEsential': isEsential,
      'isFeatured': isFeatured,
      'isSponsored': isSponsored,
    };
  }

  factory Support.fromMap(Map<String, dynamic> map) {
    return Support(
      supportName: map['SupportName'] ?? '',
      supportDescription: map['SupportDescription'] ?? '',
      supportAddress: map['SupportAddress'] ?? '',
      supportCategory: map['SupportCategory'] ?? '',
      createdAt: map['createdAt'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      phone: map['phone'] ?? '',
      supportId: map['SupportId'] ?? '',
      email: map['email'] ?? '',
      website: map['website'] ?? '',
      userId: map['userId'] ?? '',
      twitter: map['twitter'] ?? '',
      facebook: map['facebook'] ?? '',
      youtube: map['youtube'] ?? '',
      isVerified: map['isVerified'] ?? false,
      linkedIn: map['linkedIn'] ?? '',
      instagram: map['instagram'] ?? '',
      tiktok: map['tiktok'] ?? '',
      twitch: map['twitch'] ?? '',
      podcast: map['podcast'] ?? '',
      SupportUrl: map['SupportUrl'] ?? '',
      isBlackOwned: map['isBlackOwned'] ?? false,
      womenOriented: map['womenOriented'] ?? false,
      isEsential: map['isEsential'] ?? false,
      isFeatured: map['isFeatured'] ?? false,
      isSponsored: map['isSponsored'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Support.fromJson(String source) =>
      Support.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Support(SupportName: $supportName, youtube: $youtube,SupportDescription: $supportDescription, SupportAddress: $supportAddress, SupportCategory: $supportCategory, createdAt: $createdAt, phone: $phone, email: $email, website: $website, twitter: $twitter, facebook: $facebook, linkedIn: $linkedIn, instagram: $instagram, tiktok: $tiktok, twitch: $twitch, podcast: $podcast, SupportUrl: $SupportUrl, isBlackOwned: $isBlackOwned, womenOriented: $womenOriented, isEsential: $isEsential, isFeatured: $isFeatured, isSponsored: $isSponsored)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Support &&
        other.supportName == supportName &&
        other.supportDescription == supportDescription &&
        other.supportAddress == supportAddress &&
        other.supportCategory == supportCategory &&
        other.createdAt == createdAt &&
        other.phone == phone &&
        other.email == email &&
        other.website == website &&
        other.twitter == twitter &&
        other.youtube == youtube &&
        other.facebook == facebook &&
        other.linkedIn == linkedIn &&
        other.supportId == supportId &&
        other.userId == userId &&
        other.createdAt == createdAt &&
        other.isVerified == isVerified &&
        other.instagram == instagram &&
        other.tiktok == tiktok &&
        other.twitch == twitch &&
        other.podcast == podcast &&
        other.SupportUrl == SupportUrl &&
        other.isBlackOwned == isBlackOwned &&
        other.womenOriented == womenOriented &&
        other.isEsential == isEsential &&
        other.isFeatured == isFeatured &&
        other.isSponsored == isSponsored;
  }

  @override
  int get hashCode {
    return supportName.hashCode ^
        supportDescription.hashCode ^
        supportAddress.hashCode ^
        supportCategory.hashCode ^
        createdAt.hashCode ^
        phone.hashCode ^
        youtube.hashCode ^
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
        SupportUrl.hashCode ^
        isBlackOwned.hashCode ^
        womenOriented.hashCode ^
        isEsential.hashCode ^
        isFeatured.hashCode ^
        isSponsored.hashCode;
  }
}

import 'dart:convert';

class Events {
  final String eventName;
  final String eventDescription;
  final String eventAddress;
  final String eventCategory;
  final String phone;
  final String userId;
  final bool isOnlineEvent;
  final String email;
  final bool isVerified;
  final String website;
  final String twitter;
  final String eventId;
  final String facebook;
  final String linkedIn;
  final String instagram;
  final String tiktok;
  final String twitch;
  final DateTime createdAt;
  final DateTime eventDate;
  final String podcast;
  final String eventUrl;
  final bool isSponsered;
  final String youtube;
  final bool isWomenOriented;
  final DateTime? asTimeStamp;
  Events({
    required this.eventName,
    required this.youtube,
    required this.eventDescription,
    required this.eventAddress,
    required this.eventCategory,
    required this.phone,
    required this.userId,
    required this.isOnlineEvent,
    required this.email,
    required this.isVerified,
    required this.website,
    required this.twitter,
    required this.eventId,
    required this.facebook,
    required this.linkedIn,
    required this.instagram,
    required this.tiktok,
    required this.twitch,
    required this.createdAt,
    required this.eventDate,
    required this.podcast,
    required this.eventUrl,
    required this.isSponsered,
    required this.isWomenOriented,
    this.asTimeStamp,
  });

  Events copyWith({
    String? eventName,
    String? eventDescription,
    String? eventAddress,
    String? eventCategory,
    String? phone,
    String? userId,
    bool? isOnlineEvent,
    String? youtube,
    String? email,
    bool? isVerified,
    String? website,
    String? twitter,
    String? eventId,
    String? facebook,
    String? linkedIn,
    String? instagram,
    String? tiktok,
    String? twitch,
    DateTime? createdAt,
    DateTime? eventDate,
    String? podcast,
    String? eventUrl,
    bool? isSponsered,
    bool? isWomenOriented,
    DateTime? asTimeStamp,
  }) {
    return Events(
      eventName: eventName ?? this.eventName,
      eventDescription: eventDescription ?? this.eventDescription,
      eventAddress: eventAddress ?? this.eventAddress,
      eventCategory: eventCategory ?? this.eventCategory,
      phone: phone ?? this.phone,
      userId: userId ?? this.userId,
      youtube: youtube ?? this.youtube,
      isOnlineEvent: isOnlineEvent ?? this.isOnlineEvent,
      email: email ?? this.email,
      isVerified: isVerified ?? this.isVerified,
      website: website ?? this.website,
      twitter: twitter ?? this.twitter,
      eventId: eventId ?? this.eventId,
      facebook: facebook ?? this.facebook,
      linkedIn: linkedIn ?? this.linkedIn,
      instagram: instagram ?? this.instagram,
      tiktok: tiktok ?? this.tiktok,
      twitch: twitch ?? this.twitch,
      createdAt: createdAt ?? this.createdAt,
      eventDate: eventDate ?? this.eventDate,
      podcast: podcast ?? this.podcast,
      eventUrl: eventUrl ?? this.eventUrl,
      isSponsered: isSponsered ?? this.isSponsered,
      isWomenOriented: isWomenOriented ?? this.isWomenOriented,
      asTimeStamp: asTimeStamp ?? this.asTimeStamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'eventName': eventName,
      'eventDescription': eventDescription,
      'eventAddress': eventAddress,
      'eventCategory': eventCategory,
      'phone': phone,
      'userId': userId,
      'isOnlineEvent': isOnlineEvent,
      'email': email,
      'isVerified': isVerified,
      'website': website,
      'twitter': twitter,
      'eventId': eventId,
      'facebook': facebook,
      'linkedIn': linkedIn,
      'instagram': instagram,
      'youtube': youtube,
      'tiktok': tiktok,
      'twitch': twitch,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'eventDate': eventDate.millisecondsSinceEpoch,
      'podcast': podcast,
      'eventUrl': eventUrl,
      'isSponsered': isSponsered,
      'isWomenOriented': isWomenOriented,
      'asTimeStamp': asTimeStamp,
    };
  }

  factory Events.fromMap(Map<String, dynamic> map) {
    return Events(
      eventName: map['eventName'] ?? '',
      eventDescription: map['eventDescription'] ?? '',
      eventAddress: map['eventAddress'] ?? '',
      eventCategory: map['eventCategory'] ?? '',
      phone: map['phone'] ?? '',
      youtube: map['youtube'] ?? '',
      userId: map['userId'] ?? '',
      isOnlineEvent: map['isOnlineEvent'] ?? false,
      email: map['email'] ?? '',
      isVerified: map['isVerified'] ?? false,
      website: map['website'] ?? '',
      twitter: map['twitter'] ?? '',
      eventId: map['eventId'] ?? '',
      facebook: map['facebook'] ?? '',
      linkedIn: map['linkedIn'] ?? '',
      instagram: map['instagram'] ?? '',
      tiktok: map['tiktok'] ?? '',
      twitch: map['twitch'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      eventDate: DateTime.fromMillisecondsSinceEpoch(map['eventDate']),
      podcast: map['podcast'] ?? '',
      eventUrl: map['eventUrl'] ?? '',
      isSponsered: map['isSponsered'] ?? false,
      isWomenOriented: map['isWomenOriented'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Events.fromJson(String source) => Events.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Events(eventName: $eventName, youtube: $youtube,eventDescription: $eventDescription, eventAddress: $eventAddress, eventCategory: $eventCategory, phone: $phone, userId: $userId, isOnlineEvent: $isOnlineEvent, email: $email, isVerified: $isVerified, website: $website, twitter: $twitter, eventId: $eventId, facebook: $facebook, linkedIn: $linkedIn, instagram: $instagram, tiktok: $tiktok, twitch: $twitch, createdAt: $createdAt, eventDate: $eventDate, podcast: $podcast, eventUrl: $eventUrl, isSponsered: $isSponsered, isWomenOriented: $isWomenOriented, asTimeStamp: $asTimeStamp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Events &&
        other.eventName == eventName &&
        other.eventDescription == eventDescription &&
        other.eventAddress == eventAddress &&
        other.eventCategory == eventCategory &&
        other.phone == phone &&
        other.userId == userId &&
        other.isOnlineEvent == isOnlineEvent &&
        other.email == email &&
        other.isVerified == isVerified &&
        other.website == website &&
        other.twitter == twitter &&
        other.eventId == eventId &&
        other.facebook == facebook &&
        other.linkedIn == linkedIn &&
        other.instagram == instagram &&
        other.youtube == youtube &&
        other.tiktok == tiktok &&
        other.twitch == twitch &&
        other.createdAt == createdAt &&
        other.eventDate == eventDate &&
        other.podcast == podcast &&
        other.eventUrl == eventUrl &&
        other.isSponsered == isSponsered &&
        other.isWomenOriented == isWomenOriented &&
        other.asTimeStamp == asTimeStamp;
  }

  @override
  int get hashCode {
    return eventName.hashCode ^
        eventDescription.hashCode ^
        eventAddress.hashCode ^
        eventCategory.hashCode ^
        youtube.hashCode ^
        phone.hashCode ^
        userId.hashCode ^
        isOnlineEvent.hashCode ^
        email.hashCode ^
        isVerified.hashCode ^
        website.hashCode ^
        twitter.hashCode ^
        eventId.hashCode ^
        facebook.hashCode ^
        linkedIn.hashCode ^
        instagram.hashCode ^
        tiktok.hashCode ^
        twitch.hashCode ^
        createdAt.hashCode ^
        eventDate.hashCode ^
        podcast.hashCode ^
        eventUrl.hashCode ^
        isSponsered.hashCode ^
        isWomenOriented.hashCode ^
        asTimeStamp.hashCode;
  }
}

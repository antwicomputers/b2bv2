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
  final String podcast;
  final String eventUrl;
  Events({
    required this.eventName,
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
    required this.podcast,
    required this.eventUrl,
  });

  Events copyWith({
    String? eventName,
    String? eventDescription,
    String? eventAddress,
    String? eventCategory,
    String? phone,
    String? userId,
    bool? isOnlineEvent,
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
    String? podcast,
    String? eventUrl,
  }) {
    return Events(
      eventName: eventName ?? this.eventName,
      eventDescription: eventDescription ?? this.eventDescription,
      eventAddress: eventAddress ?? this.eventAddress,
      eventCategory: eventCategory ?? this.eventCategory,
      phone: phone ?? this.phone,
      userId: userId ?? this.userId,
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
      podcast: podcast ?? this.podcast,
      eventUrl: eventUrl ?? this.eventUrl,
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
      'tiktok': tiktok,
      'twitch': twitch,
      'podcast': podcast,
      'eventUrl': eventUrl,
    };
  }

  factory Events.fromMap(Map<String, dynamic> map) {
    return Events(
      eventName: map['eventName'] ?? '',
      eventDescription: map['eventDescription'] ?? '',
      eventAddress: map['eventAddress'] ?? '',
      eventCategory: map['eventCategory'] ?? '',
      phone: map['phone'] ?? '',
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
      podcast: map['podcast'] ?? '',
      eventUrl: map['eventUrl'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Events.fromJson(String source) => Events.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Events(eventName: $eventName, eventDescription: $eventDescription, eventAddress: $eventAddress, eventCategory: $eventCategory, phone: $phone, userId: $userId, isOnlineEvent: $isOnlineEvent, email: $email, isVerified: $isVerified, website: $website, twitter: $twitter, eventId: $eventId, facebook: $facebook, linkedIn: $linkedIn, instagram: $instagram, tiktok: $tiktok, twitch: $twitch, podcast: $podcast, eventUrl: $eventUrl)';
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
      other.tiktok == tiktok &&
      other.twitch == twitch &&
      other.podcast == podcast &&
      other.eventUrl == eventUrl;
  }

  @override
  int get hashCode {
    return eventName.hashCode ^
      eventDescription.hashCode ^
      eventAddress.hashCode ^
      eventCategory.hashCode ^
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
      podcast.hashCode ^
      eventUrl.hashCode;
  }
}

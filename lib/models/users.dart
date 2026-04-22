import 'dart:convert';
import 'package:flutter/foundation.dart';

class UserModel {
  final String username;
  final String uid;
  final String email;
  final String fullname;
  final String photoUrl;
  final bool isBlack;
  final int points;
  final List<String> interests;
  final List<String> viewedBusinesses;
  final bool isGuest;

  String get tier {
    if (points >= 5000) return 'ELITE';
    if (points >= 1500) return 'GOLD';
    if (points >= 500) return 'SILVER';
    return 'MEMBER';
  }

  UserModel({
    required this.username,
    required this.uid,
    required this.email,
    required this.fullname,
    required this.photoUrl,
    this.isBlack = false,
    this.points = 0,
    this.interests = const [],
    this.viewedBusinesses = const [],
    this.isGuest = false,
  });

  UserModel copyWith({
    String? username,
    String? uid,
    String? email,
    String? fullname,
    String? photoUrl,
    bool? isBlack,
    int? points,
    List<String>? interests,
    List<String>? viewedBusinesses,
    bool? isGuest,
  }) {
    return UserModel(
      username: username ?? this.username,
      uid: uid ?? this.uid,
      email: email ?? this.email,
      fullname: fullname ?? this.fullname,
      photoUrl: photoUrl ?? this.photoUrl,
      isBlack: isBlack ?? this.isBlack,
      points: points ?? this.points,
      interests: interests ?? this.interests,
      viewedBusinesses: viewedBusinesses ?? this.viewedBusinesses,
      isGuest: isGuest ?? this.isGuest,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'uid': uid,
      'email': email,
      'fullname': fullname,
      'photoUrl': photoUrl,
      'isBlack': isBlack,
      'points': points,
      'interests': interests,
      'viewedBusinesses': viewedBusinesses,
      'isGuest': isGuest,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      username: map['username'] ?? '',
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      fullname: map['fullname'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      isBlack: map['isBlack'] ?? false,
      points: map['points'] ?? 0,
      interests: List<String>.from(map['interests'] ?? []),
      viewedBusinesses: List<String>.from(map['viewedBusinesses'] ?? []),
      isGuest: map['isGuest'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(username: $username, uid: $uid, email: $email, fullname: $fullname, photoUrl: $photoUrl, isBlack: $isBlack, interests: $interests, isGuest: $isGuest)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.username == username &&
        other.uid == uid &&
        other.email == email &&
        other.fullname == fullname &&
        other.photoUrl == photoUrl &&
        other.isBlack == isBlack &&
        listEquals(other.interests, interests) &&
        listEquals(other.viewedBusinesses, viewedBusinesses) &&
        other.isGuest == isGuest;
  }

  @override
  int get hashCode {
    return username.hashCode ^
        uid.hashCode ^
        email.hashCode ^
        fullname.hashCode ^
        photoUrl.hashCode ^
        isBlack.hashCode ^
        interests.hashCode ^
        viewedBusinesses.hashCode ^
        isGuest.hashCode;
  }
}

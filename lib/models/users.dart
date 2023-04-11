import 'dart:convert';

class UserModel {
  final String username;
  final String uid;
  final String email;
  final String fullname;
  final String photoUrl;
  UserModel({
    required this.username,
    required this.uid,
    required this.email,
    required this.fullname,
    required this.photoUrl,
  });

  UserModel copyWith({
    String? username,
    String? uid,
    String? email,
    String? fullname,
    String? photoUrl,
  }) {
    return UserModel(
      username: username ?? this.username,
      uid: uid ?? this.uid,
      email: email ?? this.email,
      fullname: fullname ?? this.fullname,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'uid': uid,
      'email': email,
      'fullname': fullname,
      'photoUrl': photoUrl,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      username: map['username'] ?? '',
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      fullname: map['fullname'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(username: $username, uid: $uid, email: $email, fullname: $fullname, photoUrl: $photoUrl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.username == username &&
        other.uid == uid &&
        other.email == email &&
        other.fullname == fullname &&
        other.photoUrl == photoUrl;
  }

  @override
  int get hashCode {
    return username.hashCode ^ uid.hashCode ^ email.hashCode ^ fullname.hashCode ^ photoUrl.hashCode;
  }
}

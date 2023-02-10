import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String username;
  final String uid;
  final String email;
  final String fullname;
  final String photoUrl;

  const User(
      {required this.username,
      required this.uid,
      required this.email,
      required this.fullname,
      required this.photoUrl});

  Map<String, dynamic> toJson() => {
        'username': username,
        'uid': uid,
        'email': email,
        'fullname': fullname,
        'photoUrl': photoUrl
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      username: snapshot['username'],
      uid: snapshot['uid'],
      email: snapshot['email'],
      fullname: snapshot['fullname'],
      photoUrl: snapshot['photoUrl'],
    );
  }
}

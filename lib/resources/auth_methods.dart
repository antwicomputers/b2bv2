import 'package:b2bmobile/resources/storage_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:b2bmobile/models/users.dart' as model;
import 'package:b2bmobile/models/business.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //get user data
  Future<model.User> getUserData() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(snap);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  //sign up a user

  Future<String> signUpUser({
    required String email,
    required String password,
    required String fullname,
    required String username,
    required Uint8List file,
  }) async {
    String res = "Some error occured";

    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          fullname.isNotEmpty ||
          username.isNotEmpty) ;
      // file != null) ;
      //register the user
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      print(cred.user!.uid);

      String photoUrl = await StorageMethods()
          .uploadImageToStoage('profilePics', file, false);

      //add user to database

      model.User user = model.User(
          username: username,
          uid: cred.user!.uid,
          email: email,
          fullname: fullname,
          photoUrl: photoUrl);

      await _firestore
          .collection('users')
          .doc(cred.user!.uid)
          .set(user.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //login user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = 'Some error occurred';

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
      } else {
        res = 'Please enter all the fields';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // // register business
  // Future<String> businessRegistration({
  //   required businessName,
  //   required country,
  //   required city,
  //   required category,
  //   required address,
  //   twitter,
  //   linkedIn,
  //   instagram,
  //   facebook,
  //   required businessDescription,
  //   required podcast,
  // }) async {
  //   String res = "Some error occured";

  //   try {
  //     if (businessName.isNotEmpty ||
  //         country.isNotEmpty ||
  //         city.isNotEmpty ||
  //         category.isNotEmpty ||
  //         address.isNotEmpty ||
  //         businessDescription.isNotEmpty) ;

  //     //register business in the database
  //     Business business = new Business(
  //         businessName: businessName,
  //         uid: cred.user!.uid,
  //         country: country,
  //         city: city,
  //         category: category,
  //         address: address,
  //         businessDescription: businessDescription,
  //         twitter: twitter,
  //         linkedIn: linkedIn,
  //         instagram: instagram,
  //         facebook: facebook,
  //         podcast: podcast);

  //          await _firestore
  //         .collection('businesses')
  //         .doc(cred.user!.uid)
  //         .set(business.toJson());
  //     res = "success";
  //   } catch (err) {
  //     res = err.toString();
  //   }
  //   return res;
  // }
}

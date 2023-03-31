import 'package:b2bmobile/resources/storage_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:b2bmobile/models/users.dart' as model;
import 'package:b2bmobile/models/business.dart' as model;
import 'package:b2bmobile/models/events.dart' as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //get user data
  Future<model.User> getUserData() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap = await _firestore.collection('users').doc(currentUser.uid).get();

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
      if (email.isNotEmpty || password.isNotEmpty || fullname.isNotEmpty || username.isNotEmpty) {}
      UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      if (kDebugMode) {
        print(cred.user!.uid);
      }
      String photoUrl = await StorageMethods().uploadImageToStoage('profilePics', file, false);
      //add user to database
      model.User user = model.User(
        username: username,
        uid: cred.user!.uid,
        email: email,
        fullname: fullname,
        photoUrl: photoUrl,
      );
      await _firestore.collection('users').doc(cred.user!.uid).set(user.toJson());
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
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        res = 'success';
      } else {
        res = 'Please enter all the fields';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //resgister business
  Future<String> registerBusiness(
      {required String businessName,
      required String businessDescription,
      required String businessAddress,
      required String businessCategory,
      required String phone,
      required String email,
      required String website,
      required String twitter,
      required String facebook,
      required String linkedIn,
      required String instagram,
      required String tiktok,
      required String twitch,
      required String podcast,
      required Uint8List businessFile}) async {
    String message = 'some error occured';

    String businessUrl = await StorageMethods().uploadImageToStoage('businessPics', businessFile, false);
    final ref = FirebaseFirestore.instance.collection('businesses').doc().id;
    model.Business business = model.Business(
        businessName: businessName,
        businessId: ref,
        businessDescription: businessDescription,
        businessAddress: businessAddress,
        isVerified: false,
        userId: _auth.currentUser!.uid,
        businessCategory: businessCategory,
        createdAt: DateTime.now(),
        phone: phone,
        isBlackOwned: false,
        isEsential: false,
        isFeatured: false,
        isSponsored: false,
        womenOriented: false,
        email: email,
        website: website,
        twitter: twitter,
        facebook: facebook,
        linkedIn: linkedIn,
        instagram: instagram,
        tiktok: tiktok,
        twitch: twitch,
        podcast: podcast,
        businessUrl: businessUrl);

    try {
      await FirebaseFirestore.instance.collection('businesses').doc(ref).set(
            business.toMap(),
          );

      // await collection.doc().set(
      //       business.toMap(),
      //     );
    } catch (err) {
      message = err.toString();
    }
    return message;
  }

  //register event
  Future<String> registerEvent(
      {required String eventName,
      required String eventDescription,
      required String eventAddress,
      required String eventCategory,
      required String phone,
      required String email,
      required String website,
      required String twitter,
      required String facebook,
      required String linkedIn,
      required String instagram,
      required String tiktok,
      required String twitch,
      required String podcast,
      required Uint8List eventFile}) async {
    String message = 'some error occured';

    String eventUrl = await StorageMethods().uploadImageToStoage('eventPics', eventFile, false);

    model.Events business = model.Events(
        eventName: eventName,
        eventDescription: eventDescription,
        eventAddress: eventAddress,
        eventCategory: eventCategory,
        phone: phone,
        email: email,
        website: website,
        twitter: twitter,
        facebook: facebook,
        linkedIn: linkedIn,
        instagram: instagram,
        tiktok: tiktok,
        twitch: twitch,
        podcast: podcast,
        eventUrl: eventUrl);

    try {
      final collection = FirebaseFirestore.instance.collection('events');

      await collection.doc().set(
            business.toJson(),
          );
    } catch (err) {
      message = err.toString();
    }
    return message;
  }
}

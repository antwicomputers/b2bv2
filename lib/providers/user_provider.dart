import 'dart:async';

import 'package:b2bmobile/models/support.dart';
import 'package:b2bmobile/models/users.dart';
import 'package:flutter/foundation.dart';
import 'package:b2bmobile/resources/storage_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:b2bmobile/models/business.dart' as model;
import 'package:b2bmobile/models/events.dart' as model;
import 'package:b2bmobile/models/support.dart' as model;
import 'package:get/get.dart';
import '../Screens/authenticate/login_screen.dart';
import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';

class UserProvider with ChangeNotifier {
  UserProvider() {
    Timer(
      const Duration(seconds: 2),
      () async {
        _user = _auth.currentUser;
        if (_user != null) {
          await getUserData(_user!);
          userDataStream(_user!);
          navigateToTabsPage(_user);
        } else {
          Get.offAll(() => const LoginScreen());
        }
      },
    );
  }
  Future<bool> getUserData(User firebaseUser) async {
    final document = await FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseUser.uid)
        .get();
    if (document.exists) {
      userModel = UserModel.fromMap(document.data()!);
      return true;
    }
    userModel = null;
    return false;
  }

  void userDataStream(User firebaseUser) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseUser.uid)
        .snapshots()
        .listen((document) {
      if (kDebugMode) {
        print("USER STREAM WMITTING VALUE");
      }
      if (document.exists) {
        userModel = UserModel.fromMap(document.data()!);
        if (kDebugMode) {
          print("NOTIFTING LISTENERS");
        }
        notifyListeners();
      }
    });
  }

  Future<void> navigateToTabsPage(User? firebaseUser) async {
    if (firebaseUser != null) {
      Get.offAll(() => const ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout(),
          ));
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserModel? userModel;
  User? _user;
  User? get getUser => _user;
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
          username.isNotEmpty) {}
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (kDebugMode) {
        print(cred.user!.uid);
      }
      String photoUrl = await StorageMethods()
          .uploadImageToStoage('profilePics', file, false);
      //add user to database
      UserModel user = UserModel(
        username: username,
        uid: cred.user!.uid,
        email: email,
        fullname: fullname,
        photoUrl: photoUrl,
      );
      await _firestore
          .collection('users')
          .doc(cred.user!.uid)
          .set(user.toMap());
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
      required String youtube,
      required Uint8List businessFile}) async {
    String message = 'some error occured';
    String businessUrl = await StorageMethods()
        .uploadImageToStoage('businessPics', businessFile, false);
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
      youtube: youtube,
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
      businessUrl: businessUrl,
    );

    try {
      await FirebaseFirestore.instance.collection('businesses').doc(ref).set(
            business.toMap(),
          );
    } catch (err) {
      message = err.toString();
    }
    return message;
  }

//resgister support
  Future<String> registerSupport(
      {required String supportName,
      required String supportDescription,
      required String supportAddress,
      required String supportCategory,
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
      required String youtube,
      required Uint8List businessFile}) async {
    String message = 'some error occured';
    String supportUrl = await StorageMethods()
        .uploadImageToStoage('supportPics', businessFile, false);
    final ref =
        FirebaseFirestore.instance.collection('supportbusinesses').doc().id;
    model.Support support = model.Support(
      supportName: supportName,
      supportId: ref,
      supportDescription: supportDescription,
      supportAddress: supportAddress,
      isVerified: false,
      userId: _auth.currentUser!.uid,
      supportCategory: supportCategory,
      createdAt: DateTime.now(),
      phone: phone,
      youtube: youtube,
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
      SupportUrl: supportUrl,
    );

    try {
      await FirebaseFirestore.instance
          .collection('supportbusinesses')
          .doc(ref)
          .set(
            support.toMap(),
          );
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
      required DateTime eventDate,
      required String twitch,
      required String youtube,
      required bool isOnline,
      required String podcast,
      required Uint8List eventFile}) async {
    String message = 'some error occured';
    String eventUrl = await StorageMethods()
        .uploadImageToStoage('eventPics', eventFile, false);
    String ref = FirebaseFirestore.instance.collection('events').doc().id;
    model.Events business = model.Events(
      eventName: eventName,
      eventId: ref,
      youtube: youtube,
      isSponsered: false,
      asTimeStamp: eventDate,
      isWomenOriented: false,
      eventDescription: eventDescription,
      eventAddress: eventAddress,
      createdAt: DateTime.now(),
      eventCategory: eventCategory,
      phone: phone,
      eventDate: eventDate,
      isOnlineEvent: isOnline,
      userId: _auth.currentUser!.uid,
      email: email,
      website: website,
      isVerified: false,
      twitter: twitter,
      facebook: facebook,
      linkedIn: linkedIn,
      instagram: instagram,
      tiktok: tiktok,
      twitch: twitch,
      podcast: podcast,
      eventUrl: eventUrl,
    );
    try {
      await FirebaseFirestore.instance.collection('events').doc(ref).set(
            business.toMap(),
          );
    } catch (err) {
      message = err.toString();
    }
    return message;
  }

  //register user support
  Future<String> userRegister(
      {required String supportName,
      required String supportDescription,
      required String supportAddress,
      required String supportCategory,
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
      required String youtube,
      required Uint8List businessFile}) async {
    String message = 'some error occured';
    String supportUrl = await StorageMethods()
        .uploadImageToStoage('supportPics', businessFile, false);
    final ref =
        FirebaseFirestore.instance.collection('userresourcesupport').doc().id;
    model.Support support = model.Support(
      supportName: supportName,
      supportId: ref,
      supportDescription: supportDescription,
      supportAddress: supportAddress,
      isVerified: false,
      userId: _auth.currentUser!.uid,
      supportCategory: supportCategory,
      createdAt: DateTime.now(),
      phone: phone,
      youtube: youtube,
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
      SupportUrl: supportUrl,
    );

    try {
      await FirebaseFirestore.instance
          .collection('userresourcesupport')
          .doc(ref)
          .set(
            support.toMap(),
          );
    } catch (err) {
      message = err.toString();
    }
    return message;
  }
}

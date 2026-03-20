import 'dart:async';
import 'package:b2bmobile/models/users.dart';
import 'package:flutter/foundation.dart';
import 'package:b2bmobile/resources/storage_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:b2bmobile/models/business.dart' as model;
import 'package:b2bmobile/models/events.dart' as model;
import 'package:b2bmobile/models/support.dart' as model;
import 'package:get/get.dart';
import 'package:geocoding/geocoding.dart';
import '../Screens/authenticate/login_screen.dart';
import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';

class UserProvider with ChangeNotifier {
  UserProvider() {
    Timer(
      const Duration(seconds: 2),
      () async {
        try {
          _user = _auth.currentUser;
          if (_user != null) {
            bool userExists = false;
            try {
              userExists = await getUserData(_user!);
            } catch (e) {
              debugPrint("Error fetching user data: $e");
              userExists = false; // Treat error as missing user
            }

            if (userExists) {
              userDataStream(_user!);
              navigateToTabsPage(_user);
            } else {
              debugPrint("User missing or error. Signing out.");
              await _auth.signOut();
              Get.offAll(() => const LoginScreen());
            }
          } else {
            Get.offAll(() => const LoginScreen());
          }
        } catch (e) {
           debugPrint("Critical UserProvider Error: $e");
           await _auth.signOut();
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
        debugPrint("USER STREAM WMITTING VALUE");
      }
      if (document.exists) {
        userModel = UserModel.fromMap(document.data()!);
        if (kDebugMode) {
          debugPrint("NOTIFTING LISTENERS");
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
          username.isNotEmpty) {
        
        // 1. AUTHENTICATION
        UserCredential cred;
        try {
           cred = await _auth.createUserWithEmailAndPassword(
              email: email, password: password);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            return 'The password provided is too weak.';
          } else if (e.code == 'email-already-in-use') {
            return 'The account already exists for that email.';
          }
          return "Auth Failed [${e.code}]: ${e.message}";
        } catch (e) {
          return "Auth Failed (Generic): ${e.toString()}";
        }
        
        if (kDebugMode) {
          debugPrint("Auth Success: ${cred.user!.uid}");
        }

        // 2. STORAGE UPLOAD
        String photoUrl;
        try {
          photoUrl = await StorageMethods()
            .uploadImageToStorage('users', file, false);
        } catch (e) {
           return "Storage Failed: ${e.toString()}";
        }

        // 3. DATABASE WRITE
        try {
          //add user to database
          UserModel user = UserModel(
            username: username,
            uid: cred.user!.uid,
            email: email,
            fullname: fullname,
            photoUrl: photoUrl,
          );
          
          if (kDebugMode) {
            debugPrint("Attempting to write to Firestore: users/${cred.user!.uid}");
          }

          await _firestore
              .collection('users')
              .doc(cred.user!.uid)
              .set(user.toMap());
              
           if (kDebugMode) {
              debugPrint("Firestore Write SUCCESS");
           }
           
           // UPDATE LOCAL STATE
           _user = cred.user;
           userModel = user;
           userDataStream(cred.user!);
           notifyListeners();

        } on FirebaseException catch (e) {
           if (kDebugMode) {
             debugPrint("FIRESTORE ERROR: Code=${e.code}, Message=${e.message}");
           }
           if (e.code == 'permission-denied') {
             return "Firestore Permission Denied. Please check Database Rules.";
           }
           rethrow;
        } catch (e) {
           if (kDebugMode) {
             debugPrint("Generic Firestore Error: $e");
           }
           return "Database Failed: ${e.toString()}";
        }

        res = "success";
      }
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
      bool isBlackOwned = false,
      bool isEsential = false,
      bool womenOriented = false,
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
    
    // 1. Generate ID first
    final ref = FirebaseFirestore.instance.collection('businesses').doc().id;
    
    // 2. Upload Image using that ID
    String businessUrl = await StorageMethods()
        .uploadImageToStorage('businesses', businessFile, false, customId: ref);
        
    // 3. Geocode Address
    double latitude = 0.0;
    double longitude = 0.0;
    try {
      List<Location> locations = await locationFromAddress(businessAddress);
      if (locations.isNotEmpty) {
        latitude = locations.first.latitude;
        longitude = locations.first.longitude;
      }
    } catch (e) {
      debugPrint("Geocoding Error: $e");
    }

    // 4. Create Model
    model.Business business = model.Business(
      businessName: businessName,
      businessId: ref,
      latitude: latitude,
      longitude: longitude,
      businessDescription: businessDescription,
      businessAddress: businessAddress,
      isVerified: false,
      userId: _auth.currentUser!.uid,
      businessCategory: businessCategory,
      createdAt: DateTime.now(),
      phone: phone,
      youtube: youtube,
      isBlackOwned: isBlackOwned,
      isEsential: isEsential,
      isFeatured: false,
      isSponsored: false,
      womenOriented: womenOriented,
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
      isLiked: [],
      isFavorite: [],
    );

    try {
      await FirebaseFirestore.instance.collection('businesses').doc(ref).set(
            business.toMap(),
          );
      message = 'success';
    } catch (err) {
      message = err.toString();
    }
    return message;
  }

  // update business
  Future<String> updateBusiness({
    required String businessId,
    required String businessName,
    required String businessDescription,
    required String businessAddress,
    required String businessCategory,
    bool isBlackOwned = false,
    bool isEsential = false,
    bool womenOriented = false,
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
    required String currentBusinessUrl,
    Uint8List? businessFile,
  }) async {
    String message = 'some error occurred';

    try {
      String businessUrl = currentBusinessUrl;
      // 1. Upload new image if provided
      if (businessFile != null) {
        businessUrl = await StorageMethods().uploadImageToStorage(
            'businesses', businessFile, false,
            customId: businessId);
      }

      // 2. Geocode Address (always re-geocode to be safe, or check if changed)
      double latitude = 0.0;
      double longitude = 0.0;
      try {
        List<Location> locations = await locationFromAddress(businessAddress);
        if (locations.isNotEmpty) {
          latitude = locations.first.latitude;
          longitude = locations.first.longitude;
        }
      } catch (e) {
        debugPrint("Geocoding Error: $e");
      }

      // 3. Update Firestore
      // We don't need to recreate the whole model if we just update fields, 
      // but creating a map is cleaner.
      // Note: We should preserve existing fields like 'createdAt', 'isVerified', 'userId', 'isLiked', 'isFavorite', 'isFeatured', 'isSponsored'.
      // Since we don't have the old model here, we typically merge.
      
      Map<String, dynamic> dataToUpdate = {
        'businessName': businessName,
        'businessDescription': businessDescription,
        'businessAddress': businessAddress,
        'businessCategory': businessCategory,
        'phone': phone,
        'email': email,
        'website': website,
        'twitter': twitter,
        'facebook': facebook,
        'linkedIn': linkedIn,
        'instagram': instagram,
        'tiktok': tiktok,
        'twitch': twitch,
        'podcast': podcast,
        'youtube': youtube,
        'businessUrl': businessUrl,
        'isBlackOwned': isBlackOwned,
        'isEsential': isEsential,
        'womenOriented': womenOriented,
        'latitude': latitude,
        'longitude': longitude,
      };

      await FirebaseFirestore.instance
          .collection('businesses')
          .doc(businessId)
          .update(dataToUpdate);

      message = 'success';
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
    
    // 1. Generate ID first
    final ref =
        FirebaseFirestore.instance.collection('supportbusinesses').doc().id;

    // 2. Upload Image using that ID
    String supportUrl = await StorageMethods()
        .uploadImageToStorage('supportbusinesses', businessFile, false, customId: ref);
        
    // 3. Geocode Address
    double latitude = 0.0;
    double longitude = 0.0;
    try {
      List<Location> locations = await locationFromAddress(supportAddress);
      if (locations.isNotEmpty) {
        latitude = locations.first.latitude;
        longitude = locations.first.longitude;
      }
    } catch (e) {
      debugPrint("Geocoding Error: $e");
    }
        
    // 4. Create Model
    model.Support support = model.Support(
      latitude: latitude,
      longitude: longitude,
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
      supportUrl: supportUrl,
    );

    try {
      await FirebaseFirestore.instance
          .collection('supportbusinesses')
          .doc(ref)
          .set(
            support.toMap(),
          );
      message = 'success';
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
    
    // 1. Generate ID first
    String ref = FirebaseFirestore.instance.collection('events').doc().id;

    // 2. Upload Image using that ID
    String eventUrl = await StorageMethods()
        .uploadImageToStorage('events', eventFile, false, customId: ref);
        
    // 3. Geocode Address
    double latitude = 0.0;
    double longitude = 0.0;
    try {
      List<Location> locations = await locationFromAddress(eventAddress);
      if (locations.isNotEmpty) {
        latitude = locations.first.latitude;
        longitude = locations.first.longitude;
      }
    } catch (e) {
      debugPrint("Geocoding Error: $e");
    }

    // 4. Create Model
    model.Events business = model.Events(
      latitude: latitude,
      longitude: longitude,
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
      message = 'success';
    } catch (err) {
      message = err.toString();
    }
    return message;
  }

  // update event
  Future<String> updateEvent({
    required String eventId,
    required String eventName,
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
    required String currentEventUrl,
    Uint8List? eventFile,
  }) async {
    String message = 'some error occurred';

    try {
      String eventUrl = currentEventUrl;
      // 1. Upload new image if provided
      if (eventFile != null) {
        eventUrl = await StorageMethods().uploadImageToStorage(
            'events', eventFile, false,
            customId: eventId);
      }

      // 2. Geocode Address
      double latitude = 0.0;
      double longitude = 0.0;
      try {
        List<Location> locations = await locationFromAddress(eventAddress);
        if (locations.isNotEmpty) {
          latitude = locations.first.latitude;
          longitude = locations.first.longitude;
        }
      } catch (e) {
        debugPrint("Geocoding Error: $e");
      }

      // 3. Update Firestore
      Map<String, dynamic> dataToUpdate = {
        'eventName': eventName,
        'eventDescription': eventDescription,
        'eventAddress': eventAddress,
        'eventCategory': eventCategory,
        'phone': phone,
        'email': email,
        'website': website,
        'twitter': twitter,
        'facebook': facebook,
        'linkedIn': linkedIn,
        'instagram': instagram,
        'tiktok': tiktok,
        'twitch': twitch,
        'podcast': podcast,
        'youtube': youtube,
        'eventUrl': eventUrl,
        'eventDate': eventDate,
        'latitude': latitude,
        'longitude': longitude,
        'asTimeStamp': eventDate,
        'isOnlineEvent': isOnline,
      };

      await FirebaseFirestore.instance
          .collection('events')
          .doc(eventId)
          .update(dataToUpdate);

      message = 'success';
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
    
    // 1. Generate ID First
    final ref =
        FirebaseFirestore.instance.collection('userresourcesupport').doc().id;
    
    // 2. Upload Image using that ID
    String supportUrl = await StorageMethods()
        .uploadImageToStorage('userresourcesupport', businessFile, false, customId: ref);
        
    // 3. Geocode Address
    double latitude = 0.0;
    double longitude = 0.0;
    try {
      List<Location> locations = await locationFromAddress(supportAddress);
      if (locations.isNotEmpty) {
        latitude = locations.first.latitude;
        longitude = locations.first.longitude;
      }
    } catch (e) {
      debugPrint("Geocoding Error: $e");
    }
        
    // 4. Create Model
    model.Support support = model.Support(
      latitude: latitude,
      longitude: longitude,
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
      supportUrl: supportUrl,
    );

    try {
      await FirebaseFirestore.instance
          .collection('userresourcesupport')
          .doc(ref)
          .set(
            support.toMap(),
          );
      message = 'success';
    } catch (err) {
      message = err.toString();
    }
    return message;
  }

  //register youth support
  Future<String> youthRegister(
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
    
    // 1. Generate ID first
    final ref = FirebaseFirestore.instance.collection('youthresource').doc().id;

    // 2. Upload Image using that ID
    String supportUrl = await StorageMethods()
        .uploadImageToStorage('youthresource', businessFile, false, customId: ref);
        
    // 3. Geocode Address
    double latitude = 0.0;
    double longitude = 0.0;
    try {
      List<Location> locations = await locationFromAddress(supportAddress);
      if (locations.isNotEmpty) {
        latitude = locations.first.latitude;
        longitude = locations.first.longitude;
      }
    } catch (e) {
      debugPrint("Geocoding Error: $e");
    }
        
    // 4. Create Model
    model.Support support = model.Support(
      latitude: latitude,
      longitude: longitude,
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
      supportUrl: supportUrl,
    );

    try {
      await FirebaseFirestore.instance.collection('youthresource').doc(ref).set(
            support.toMap(),
          );
      message = 'success';
    } catch (err) {
      message = err.toString();
    }
    return message;
  }

  // update user resource
  Future<String> updateUserResource({
    required String supportId,
    required String supportName,
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
    required String currentSupportUrl,
    Uint8List? businessFile,
  }) async {
    String message = 'some error occurred';

    try {
      String supportUrl = currentSupportUrl;
      // 1. Upload new image if provided
      if (businessFile != null) {
        supportUrl = await StorageMethods().uploadImageToStorage(
            'userresourcesupport', businessFile, false,
            customId: supportId);
      }

      // 2. Geocode Address
      double latitude = 0.0;
      double longitude = 0.0;
      try {
        List<Location> locations = await locationFromAddress(supportAddress);
        if (locations.isNotEmpty) {
          latitude = locations.first.latitude;
          longitude = locations.first.longitude;
        }
      } catch (e) {
        debugPrint("Geocoding Error: $e");
      }

      // 3. Update Firestore
      Map<String, dynamic> dataToUpdate = {
        'supportName': supportName,
        'supportDescription': supportDescription,
        'supportAddress': supportAddress,
        'supportCategory': supportCategory,
        'phone': phone,
        'email': email,
        'website': website,
        'twitter': twitter,
        'facebook': facebook,
        'linkedIn': linkedIn,
        'instagram': instagram,
        'tiktok': tiktok,
        'twitch': twitch,
        'podcast': podcast,
        'youtube': youtube,
        'supportUrl': supportUrl,
        'latitude': latitude,
        'longitude': longitude,
      };

      await FirebaseFirestore.instance
          .collection('userresourcesupport')
          .doc(supportId)
          .update(dataToUpdate);

      message = 'success';
    } catch (err) {
      message = err.toString();
    }
    return message;
  }

  // update youth resource
  Future<String> updateYouthResource({
    required String supportId,
    required String supportName,
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
    required String currentSupportUrl,
    Uint8List? businessFile,
  }) async {
    String message = 'some error occurred';

    try {
      String supportUrl = currentSupportUrl;
      // 1. Upload new image if provided
      if (businessFile != null) {
        supportUrl = await StorageMethods().uploadImageToStorage(
            'youthresource', businessFile, false,
            customId: supportId);
      }

      // 2. Geocode Address
      double latitude = 0.0;
      double longitude = 0.0;
      try {
        List<Location> locations = await locationFromAddress(supportAddress);
        if (locations.isNotEmpty) {
          latitude = locations.first.latitude;
          longitude = locations.first.longitude;
        }
      } catch (e) {
        debugPrint("Geocoding Error: $e");
      }

      // 3. Update Firestore
      Map<String, dynamic> dataToUpdate = {
        'supportName': supportName,
        'supportDescription': supportDescription,
        'supportAddress': supportAddress,
        'supportCategory': supportCategory,
        'phone': phone,
        'email': email,
        'website': website,
        'twitter': twitter,
        'facebook': facebook,
        'linkedIn': linkedIn,
        'instagram': instagram,
        'tiktok': tiktok,
        'twitch': twitch,
        'podcast': podcast,
        'youtube': youtube,
        'supportUrl': supportUrl,
        'latitude': latitude,
        'longitude': longitude,
      };

      await FirebaseFirestore.instance
          .collection('youthresource')
          .doc(supportId)
          .update(dataToUpdate);

      message = 'success';
    } catch (err) {
      message = err.toString();
    }
    return message;
  }
}

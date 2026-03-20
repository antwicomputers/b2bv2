// import 'dart:typed_data'; // unnecessary import provided by foundation.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //adding image to firebase storage
  Future<String> uploadImageToStorage(String childName, Uint8List file, bool isPost, {String? customId}) async {
    Reference ref;
    
    if (customId != null) {
      // New logic: Store directly under the collection/entityID
      // e.g., 'businesses/business_123'
      ref = _storage.ref().child(childName).child(customId);
    } else {
      // Legacy logic: Store under users/uid/timestamp
      // Used for profile pics or non-ID posts
      ref = _storage.ref().child(childName).child(_auth.currentUser!.uid).child(
            DateTime.now().microsecondsSinceEpoch.toString(),
          );
    }

    if (kDebugMode) {
      debugPrint('Storage Bucket: ${_storage.app.options.storageBucket}');
      debugPrint('Uploading to: ${ref.fullPath}');
      debugPrint('File size: ${file.length} bytes');
    }

    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot snap = await uploadTask;
    
    if (kDebugMode) {
      debugPrint('Upload State: ${snap.state}');
      debugPrint('Bytes Transferred: ${snap.bytesTransferred} / ${snap.totalBytes}');
    }

    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> deleteImageFromStorage(String url) async {
    try {
      await _storage.refFromURL(url).delete();
    } catch (e) {
      debugPrint("Error deleting image: $e");
    }
  }
}

import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //adding image to firebase storage
  Future<String> uploadImageToStoage(String childName, Uint8List file, bool isPost) async {
    //pointer to file in storage
    Reference ref = _storage.ref().child(childName).child(_auth.currentUser!.uid).child(
          DateTime.now().microsecondsSinceEpoch.toString(),
        );

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
}

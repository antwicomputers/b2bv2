import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<Uint8List?> pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();

  XFile? file = await imagePicker.pickImage(source: source);

  if (file != null) {
    return await file.readAsBytes();
  }
  debugPrint('No Image selected');
  return null;
}

Future<Uint8List?> pickVideo(ImageSource src, BuildContext context) async {
  final video = await ImagePicker().pickVideo(source: src);

  if (video != null) {
    return await video.readAsBytes();
  }
  return null;
}

void showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

bool checkGuestAccess(BuildContext context, bool isGuest) {
  if (isGuest) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF141414),
        title: const Text('Account Required', style: TextStyle(color: Colors.white)),
        content: const Text('You must create an account or sign in to perform this action.', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Usually we would redirect to login screen here or clear state
            },
            child: const Text('Understood', style: TextStyle(color: Colors.amber)),
          ),
        ],
      ),
    );
    return true;
  }
  return false;
}

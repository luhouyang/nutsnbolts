// Dart imports
import 'dart:io';
import 'dart:typed_data';

// Flutter imports
import 'package:flutter/material.dart';

// Third-party package imports
import 'package:firebase_storage/firebase_storage.dart';

class StorargeModel {
  static Reference storageRef = FirebaseStorage.instance.ref();

  Future postImage(String fileName, String docRef, File file) async {
    final folderRef = storageRef.child(docRef); // use other filed as duplicates might exist
    final imageRef = folderRef.child(fileName);

    try {
      TaskSnapshot taskSnapshot = await imageRef.putFile(file);
      return taskSnapshot.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      debugPrint("Error: $e");
    }
    return null;
  }

  Future<Uint8List?> retrieveImage(String fileName, String docRef) async {
    final folderRef = storageRef.child(docRef);
    final imageRef = folderRef.child(fileName);

    try {
      final Uint8List? imageData = await imageRef.getData();
      return imageData;
    } on FirebaseException catch (e) {
      debugPrint("Error: $e");
    }
    return null;
  }

  Future<void> deleteImage(String fileName, String docRef) async {
    final folderRef = storageRef.child(docRef);
    final imageRef = folderRef.child(fileName);

    try {
      await imageRef.delete();
    } on FirebaseException catch (e) {
      debugPrint("Error: $e");
    }
  }
}

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class SignUpController {
  Future<void> addUserToFirebase(String name, String email, String phone,
      Uint8List fileBytes, String password) async {
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');

    //print("hi $imageId");

    try {
      final userData = {
        'Username': name,
        'Email': email,
        'Phone': phone,
        'Password': password,
        'ImageURL': '',
      };

      if (fileBytes != null) {
        try {
          // Upload the image file to Firebase Storage
          //storageRef is a reference to the specific location in Firebase Storage where the image file will be uploaded.
          //child('user_images') is creates the parent directory
          //child(name) creates a child reference under the "user_images" directory
          final storageRef =
              FirebaseStorage.instance.ref().child('user_images').child(name);
          //storageRef.putFile(imageId) - upload of the imageId file to the specified location in Firebase



          final uploadTask = storageRef.putData(fileBytes, SettableMetadata(contentType: "image/jpeg"));
          //TaskSnapshot contains information about the uploaded file, such as bytes transferred, download URL
          final TaskSnapshot uploadSnapshot =
              await uploadTask.whenComplete(() {});

          // Get the image URL from Firebase Storage
          final imageURL = await uploadSnapshot.ref.getDownloadURL();
          userData['ImageURL'] = imageURL;
        } catch (e) {
          print('Error uploading image to Firebase Storage: $e');
        }
      }
      
      //edd the data to the new document
      await usersCollection.add(userData);
      print('User added to Firebase successfully');
    } catch (e) {
      print('Error adding user to Firebase: $e');
    }
  }
}







// class SignUpController {
//   Future<void> addUserToFirebase(String name, String email, String phone,
//       File? imageId, String password) async {
//     CollectionReference usersCollection =
//         FirebaseFirestore.instance.collection('users');

//     try {
//       final userData = {
//         'Username': name,
//         'Email': email,
//         'Phone': phone,
//         'Password': password,
//         // Add any other relevant fields to the user data
//       };

//       if (imageId != null) {
//         try {
//           // Upload the image file to Firebase Storage
//           final storageRef =
//               FirebaseStorage.instance.ref().child('user_images').child(name);
//           final uploadTask = storageRef.putFile(imageId);
//           final TaskSnapshot uploadSnapshot =
//               await uploadTask.whenComplete(() {});

//           // Get the image URL from Firebase Storage
//           final imageURL = await uploadSnapshot.ref.getDownloadURL();
//           userData['ImageURL'] = imageURL;
//         } catch (e) {
//           print('Error uploading image to Firebase Storage: $e');
//         }
//       }

//       await usersCollection.add(userData);
//       print('User added to Firebase successfully');
//     } catch (e) {
//       print('Error adding user to Firebase: $e');
//     }
//   }

// Future<void> addUserToFirebase(String name, String email, String phone, String password, File? imageId, String password) async {

// CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

//   try {
//     await usersCollection.add({
//       'Username': name,
//       'Email': email,
//       'Phone': phone,
//       'Password': password,
//     });
//     print('User added to Firebase successfully');
//   } catch (e) {
//     print('Error adding user to Firebase: $e');
//   }
// }

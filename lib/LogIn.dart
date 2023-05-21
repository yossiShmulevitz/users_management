import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'SignUp.dart';

class LogIn {
  /// Checks if the provided username and password exist in the "users" collection in Firebase.
  /// Returns:
  /// A [Future] that completes with a [bool] indicating if the credentials are valid or not.
  ///
  /// Throws:
  /// - [FirebaseException] if there is an error while accessing Firebase Firestore.
  Future<bool> isUserExists(String username, String password) async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .where('Username', isEqualTo: username)
        .where('Password', isEqualTo: password)
        .get();

    return snapshot.docs.isNotEmpty;
  }
}

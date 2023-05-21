import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';


Future<bool> UserAuthentication(BuildContext context, String phoneNumber) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  Completer<bool> completer = Completer<bool>();

  void verificationCompleted(PhoneAuthCredential credential) async {
    UserCredential userCredential = await auth.signInWithCredential(credential);
    User? user = userCredential.user;
    if (user != null) {
      print('User signed in: ${user.uid}');
      completer.complete(true); // Authentication successful
    } else {
      print('Failed to sign in with OTP');
      completer.complete(false); // Authentication failed
    }
  }

  void verificationFailed(FirebaseAuthException exception) {
    print('Failed to verify phone number: ${exception.code} - ${exception.message}');
    completer.complete(false); // Authentication failed
  }

  void codeSent(String verificationId, int? resendToken) async {
    String smsCode = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter sms password'),
          content: TextFormField(
            onChanged: (value) {
              smsCode = value;
            },
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                PhoneAuthCredential credential = PhoneAuthProvider.credential(
                  verificationId: verificationId,
                  smsCode: smsCode,
                );

                UserCredential userCredential = await auth.signInWithCredential(credential);
                User? user = userCredential.user;
                if (user != null) {
                  print('User signed in: ${user.uid}');
                  completer.complete(true); // Authentication successful
                } else {
                  print('Failed to sign in with OTP');
                  completer.complete(false); // Authentication failed
                }

                Navigator.pop(context);
              },
              child: Text('Verify'),
            ),
          ],
        );
      },
    );
  }

  void codeAutoRetrievalTimeout(String verificationId) {
    print('OTP auto-retrieval timed out');
    completer.complete(false); // Authentication failed
  }

  await FirebaseAuth.instance.verifyPhoneNumber(
    phoneNumber: phoneNumber,
    verificationCompleted: verificationCompleted,
    verificationFailed: verificationFailed,
    codeSent: codeSent,
    codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
  );

  return completer.future;
}







// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// //Future - asynchronous operation. Future<void> - return void
// Future<void> UserAuthentication(BuildContext context, String phoneNumber) async {
//   //FirebaseAuth.instance - signing in users, creating user accounts, verifying phone numbers, etc. 
//   FirebaseAuth auth = FirebaseAuth.instance;

//   // Configure the OTP(One-Time Password) verification options
//   //callback - a function that is passed as an argument to another function 
//   //PhoneAuthCredential - represents the credentials required for phone number authentication.
//   Future<void> verificationCompleted(PhoneAuthCredential credential) async {
//     // This callback will be triggered when the verification is done automatically
//     // based on the auto-retrieval feature.
//     // You can proceed with the authentication process here.
//     // For example, you can sign in the user with the obtained credential.

//     //UserCredential - represents the result of an authentication operation
//     UserCredential userCredential = await auth.signInWithCredential(credential);
//     User? user = userCredential.user;
//     if (user != null) {
//       // Authentication successful
//       print('User signed in: ${user.uid}');
//     } else {
//       // Authentication failed
//       print('Failed to sign in with OTP');
//     }
//   }

//   void verificationFailed(FirebaseAuthException exception) {
//     // This callback will be triggered when the verification fails.
//     // You can handle the failure scenario here.
//     print('Failed to verify phone number: ${exception.code} - ${exception.message}');
//   }

//   void codeSent(String verificationId, int? resendToken) async {
//     // This callback will be triggered when the verification code is successfully sent.
//     // You should store the verification ID to use it later when the user enters the OTP.
//     String smsCode = ''; // The OTP entered by the user

//     // Prompt the user to enter the OTP
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Enter sms password'),
//           content: TextFormField(
//             onChanged: (value) {
//               smsCode = value;
//             },
//           ),
//           actions: [
//             ElevatedButton(
//               onPressed: () async {
//                 // Verify the OTP entered by the user
//                 PhoneAuthCredential credential = PhoneAuthProvider.credential(
//                   verificationId: verificationId,
//                   smsCode: smsCode,
//                 );

//                 // Sign in the user with the obtained credential
//                 UserCredential userCredential = await auth.signInWithCredential(credential);
//                 User? user = userCredential.user;
//                 if (user != null) {
//                   // Authentication successful
//                   print('User signed in: ${user.uid}');
//                 } else {
//                   // Authentication failed
//                   print('Failed to sign in with OTP');
//                 }

//                 // Close the dialog
//                 Navigator.pop(context);
//               },
//               child: Text('Verify'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void codeAutoRetrievalTimeout(String verificationId) {
//     // This callback will be triggered when the verification code auto-retrieval times out.
//     // You can handle the timeout scenario here.
//     print('OTP auto-retrieval timed out');
//   }

//   // Start the OTP verification process
//   await FirebaseAuth.instance.verifyPhoneNumber(
//     phoneNumber: phoneNumber,
//     verificationCompleted: verificationCompleted,
//     verificationFailed: verificationFailed,
//     codeSent: codeSent,
//     codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
//   );
// }

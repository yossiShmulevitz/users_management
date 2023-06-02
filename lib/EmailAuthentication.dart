import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//EmailAuthentication 

import 'package:flutter/material.dart';
//import 'SignUp.dart';

// class EmailAuthentication  extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.green, // Set the background color to green
//       appBar: AppBar(
//         title: Text('Green Page'),
//       ),
//       body: Center(
//         child: Text(
//           'This is a green page!',
//           style: TextStyle(
//             fontSize: 24,
//             color: Colors.white,
//           ),
//         ),
//       ),
//     );
//   }
// }


//secondPage


class EmailAuthentication extends StatelessWidget {
  final String email;
  const EmailAuthentication({required this.email, super.key});

  // final String email;
  //constructor
  // const emailAuthentication({required this.email, super.key});

  @override
  Widget build(BuildContext context) {
    print('A link sent to the email: ${this.email}');

    const email = 'yossishmulevitz@gmail.com';
    const password = '123123';
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Column(
        children: [
          Text('Signed in user email: ${currentUser?.email}'),
          Text('User is verified: ${currentUser?.emailVerified}'),
          OutlinedButton(
            onPressed: () async {
              final actionCode =
                  ActionCodeSettings(url: 'https://usersdb-4d55a.web.app');
              User? user;
              try {
                final userCreds =
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                user = userCreds.user;
              } on FirebaseAuthException catch (e) {
                if (e.code == 'email-already-in-use') {
                  final userCreds =
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: email,
                    password: password,
                  );
                  user = userCreds.user;
                }
              }
              if (user != null) {
                if (user.emailVerified) {
                  print('Already verfied');
                  return;
                }
                await user.sendEmailVerification(actionCode);
                print('Sent!!!');
                Navigator.pop(context, true); //return true value
              } else {
                print('Shit!!!');
              }
            },
            child: Text('Sign up and send verificastion email'),
          ),
        ],
      ),
    );
  }
}






















// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:mailer/mailer.dart';
// import 'package:mailer/smtp_server.dart';
// import 'package:email_otp/email_otp.dart';
// import 'package:flutter/material.dart';

// // Function to send an email using Firebase and SMTP
// Future<bool> emailAuthentication(
//     BuildContext context, String emailAddress) async {
//   //print(emailAddress);

//   // Initialize Firebase
//   await Firebase.initializeApp();

//   // Get the user's password using a text input dialog
//   String password = await showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text('Enter Password'),
//         content: TextField(
//           obscureText: true,
//           decoration: InputDecoration(hintText: 'Password'),
//         ),
//         actions: <Widget>[
//           TextButton(
//             child: Text('Submit'),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//         ],
//       );
//     },
//   );

//   // Verify the password
//   if (password == 'correct_password') {
//     // Set up the SMTP server details
//     final smtpServer = gmail('your_email@gmail.com', 'your_password');

//     // Create the email message
//     final message = Message()
//       ..from = Address('your_email@gmail.com')
//       ..recipients.add(emailAddress)
//       ..subject = 'Authentication Password'
//       ..text = 'Your authentication password is: $password';

//     try {
//       // Send the email
//       final sendReport = await send(message, smtpServer);

//       print('Message sent successfully!');
//       return true;
//     } catch (e) {
//       print('Error sending email: $e');
//     }
//   }

//   return false;
// }

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:mailer/mailer.dart';
// import 'package:mailer/smtp_server.dart';

// // Function to send an email using Firebase and SMTP
// Future<bool> emailAuthentication(
//     BuildContext context, String emailAddress) async {
//   //print(emailAddress);

//   // Initialize Firebase
//   await Firebase.initializeApp();

//   // Get the user's password using a text input dialog
//   String password = await showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text('Enter Password'),
//         content: TextField(
//           obscureText: true,
//           decoration: InputDecoration(hintText: 'Password'),
//         ),
//         actions: <Widget>[
//           TextButton(
//             child: Text('Submit'),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//         ],
//       );
//     },
//   );

//   // Verify the password
//   if (password == 'correct_password') {
//     // Set up the SMTP server details
//     final smtpServer = gmail('your_email@gmail.com', 'your_password');

//     // Create the email message
//     final message = Message()
//       ..from = Address('your_email@gmail.com')
//       ..recipients.add(emailAddress)
//       ..subject = 'Authentication Password'
//       ..text = 'Your authentication password is: $password';

//     try {
//       // Send the email
//       final sendReport = await send(message, smtpServer);

//       print('Message sent successfully!');
//       return true;
//     } catch (e) {
//       print('Error sending email: $e');
//     }
//   }

//   return false;
// }

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'dart:async';

// Future<bool> emailAuthentication(BuildContext context, String email) async {
//   print(email);
//   FirebaseAuth auth = FirebaseAuth.instance;
//   Completer<bool> completer = Completer<bool>();

//   void verificationCompleted(AuthCredential credential) async {
//     UserCredential userCredential = await auth.signInWithCredential(credential);
//     User? user = userCredential.user;
//     if (user != null) {
//       print('User signed in: ${user.uid}');
//       completer.complete(true); // Authentication successful
//     } else {
//       print('Failed to sign in with email');
//       completer.complete(false); // Authentication failed
//     }
//   }

//   void verificationFailed(FirebaseAuthException exception) {
//     print('Failed to verify email: ${exception.code} - ${exception.message}');
//     completer.complete(false); // Authentication failed
//   }

//   void codeSent(String verificationId, int? resendToken) async {
//     String emailCode = '';

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Enter email password'),
//           content: TextFormField(
//             onChanged: (value) {
//               emailCode = value;
//             },
//           ),
//           actions: [
//             ElevatedButton(
//               onPressed: () async {
//                 AuthCredential credential = EmailAuthProvider.credential(
//                   email: email,
//                   password: emailCode,
//                 );

//                 verificationCompleted(credential); // Call verificationCompleted with the credential

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
//     print('Email verification timed out');
//     completer.complete(false); // Authentication failed
//   }

//   // Set up the email verification listeners
//   auth.authStateChanges().listen((User? user) {
//     if (user != null) {
//       completer.complete(true); // Authentication successful
//     }
//   }, onError: (dynamic error) {
//     print('Failed to verify email: $error');
//     completer.complete(false); // Authentication failed
//   });

//   // Call codeSent to show the email password dialog
//   codeSent('', null);

//   return completer.future;
// }

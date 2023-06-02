import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class TestEmailVerify extends StatelessWidget {
  const TestEmailVerify({super.key});

  @override
  Widget build(BuildContext context) {
    const email = 'yossishmulevitz@gmail.com';
    const password = '123123';
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Column(
        children: [
          Text('Sign up with email link: ${currentUser?.email}'),
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
                print('Sent!');
              } else {
                print('Error!');
              }
            },
            child: Text('Sign up & send verificastion email'),
          ),
        ],
      ),
    );
  }
}

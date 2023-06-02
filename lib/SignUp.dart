import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

import 'SignUpController.dart';
import 'PhoneNumAuthentication.dart';
import 'EmailAuthentication.dart';

//yossishmulevitz@gmail.com

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUp createState() => _SignUp();
}

class _SignUp extends State<SignUp> {
  String username = "";
  String email = "";
  bool emailAuthRes = false;
  String phone = "";
  String password = "";

  final _formKey = GlobalKey<FormState>();
  //blob URL: object representing an image file on the local system
  Uint8List? fileBytes;
  SignUpController suc = new SignUpController();

  //handle the image selection from the devic
  Future<void> _selectImage() async {
    //creat object for  access the device's image gallery or camera
    final picker = ImagePicker();
    //pickedImage - stores the image that is retrieved from the gallery.
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      //imageId - file path of the selected image.
      final imageBytes = await pickedImage.readAsBytes();
      setState(() {
        fileBytes = Uint8List.fromList(imageBytes);
      });
    }
  }

  // bool result = false;
  // void navigateToEmailAuthentication() async {
  //   final bool receivedResult = await Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //         builder: (context) => emailAuthentication(email: email)),
  //   );
  //   setState(() {
  //     result = receivedResult;
  //   });
  //   print('navigateToEmailAuthentication called');
  // }
  // void navigateToEmailAuthentication() {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => EmailAuthentication()),
  //   );
  //   print('navigateToEmailAuthentication called');
  // }

  Future<void> navigateToEmailAuthentication() async {
    emailAuthRes = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EmailAuthentication(email: 'email')),
    );

    print('email hath return: ${emailAuthRes}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Sign Up'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Username text field
              TextFormField(
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
                onSaved: (value) {
                  username = value!;
                },
              ),
              // Email text field
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email address';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
                onSaved: (value) {
                  email = value!;
                },
              ),
              // Phone text field
              TextFormField(
                decoration: InputDecoration(labelText: 'Phone'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
                onSaved: (value) {
                  phone = value!;
                },
              ),
              // Password text field
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 4) {
                    return 'Password must be at least 4 characters long';
                  }
                  return null;
                },
                onSaved: (value) {
                  password = value!;
                },
              ),
              SizedBox(height: 16.0),
              // Upload Image button
              ElevatedButton(
                onPressed: _selectImage,
                child: Text('Upload ID Image'),
              ),
              SizedBox(height: 16.0),
              //Sign up button
              ElevatedButton(
                onPressed: () async {
                  // Validate form data
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    //User phone Authentication
                    bool authenticationResult =
                        await phoneNumAuthentication(context, "+972$phone");

                    // Phone assword is correct
                    if (authenticationResult) {
                      print('phone Authentication: ${authenticationResult}');

                      await navigateToEmailAuthentication();
                      if (emailAuthRes) {
                        //sign up
                        await suc.addUserToFirebase(
                            username, email, phone, fileBytes!, password);

                        Navigator.pop(context);
                      } else {
                        print(
                            'there was a problem withe the email huthentication');
                      }
                      //print('Email authentication: ${result}');

                      //sign up
                      // await suc.addUserToFirebase(
                      //     username, email, phone, fileBytes!, password);

                      // Phonne password is incorrect
                    } else {
                      //   print('phone Authentication: ${authenticationResult}');
                    }
                  }
                },
                child: Text('Sign up'),
              ),
              // SizedBox(height: 16.0),
              // ElevatedButton(
              //   onPressed: () async {
              //     navigateToEmailAuthentication();
              //   },
              //   child: Text('Go to Email Authentication'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

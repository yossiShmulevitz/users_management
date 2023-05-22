import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'SignUpController.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'UserAuthentication.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUp createState() => _SignUp();
}

//class _SignUp extends StatelessWidget {
class _SignUp extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  //***the "_" means private
  //***string? can contain null
  //String? _username;
  String username = "";
  String email = "";
  String phone = "";
  //File can either hold a reference to a File object or be null
  //blob URL: object representing an image file on the local system
  //File? imageId;
  Uint8List? fileBytes;
  String password = "";

  //object for adding new user
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
                  //value! - can be NULL
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
                  // Validate and save form data
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    // Calling UserAuthentication function in UserAuthentication.dart
                    bool authenticationResult =
                        await UserAuthentication(context, "+972$phone");

                    if (authenticationResult) {
                      // Password is correct
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Correct!'),
                            content: Text('The password is correct.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Close'),
                              ),
                            ],
                          );
                        },
                      );

                    await suc.addUserToFirebase(
                        username, email, phone, fileBytes!, password);

                    // Navigator - stack of routes(screens) allows replace screens
                    // the (context) refers to the BuildContext parameter that is typically passed as an argument
                    // Navigator.pop(context) - return to previos route
                    Navigator.pop(context);
                    } else {
                      // Password is incorrect
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Error!'),
                            content: Text('Try again'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Close'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  }
                },
                child: Text('Sign up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}













// import 'package:flutter/material.dart';

// import 'UserAuthentication.dart';

// class SignUp extends StatelessWidget {
//   final String phoneNumber;

//   const SignUp({required this.phoneNumber});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Authentication'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () async {
//             await UserAuthentication(context, phoneNumber);
//           },
//           child: Text('Authenticate'),
//         ),
//       ),
//     );
//   }
// }

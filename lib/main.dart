import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'SignUp.dart';
import 'LogIn.dart';
import 'Home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Login page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Counter variable for demonstration purposes
  int _counter = 0;

  // Form key for validation and saving
  final _formKey = GlobalKey<FormState>();

  // Variables for storing username and password
  String? _username;
  String? _password;
  LogIn li = new LogIn();

  // Method to handle button tap and navigate to SignUpPage
  void _navigateToSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUp()),
    );
  }

  void _navigateToHome() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Home()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
                  _username = value;
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
                  return null;
                },
                onSaved: (value) {
                  _password = value;
                },
              ),
              SizedBox(height: 16.0),
              // Login button
              ElevatedButton(
                onPressed: () async {
                  // Validate form and save
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    bool exists = await li.isUserExists(_username!, _password!);
                    if (exists) {
                      // User exists
                      _navigateToHome(); // Add parentheses to call the method
                    } else {
                      // User does not exist
                      // Display an error message
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Login Failed'),
                            content: Text('Invalid username or password.'),
                            actions: [
                              TextButton(
                                child: Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  }
                },
                child: Text('Login'),
              ),

              SizedBox(height: 16.0),
              //Sign up button
              ElevatedButton(
                onPressed: _navigateToSignUp,
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

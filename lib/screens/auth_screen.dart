import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ask_pdf/services/auth_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

//create the AuthServide object
final AuthService _authService = AuthService();

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;
  //form key and form states
  final _formKey = GlobalKey<FormState>();
  var _enteredEmail = " ";
  var _enteredPassword = " ";
  var _enteredUsername = " ";
  File? _userProfileImage;

  //loading state till the profile image is uploaded
  var _isLoading = false;

  void _formSubmit() async {
    final isFormValid = _formKey.currentState!.validate();

    if (!context.mounted) {
      return;
    }

    try {
      if (!isFormValid) {
        return;
      }

      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      if (_isLogin) {
        await _authService.loginWithEmailPassword(
            email: _enteredEmail, password: _enteredPassword, context: context);
      } else {
        await _authService.registerWithEmailPassword(
            username: _enteredUsername,
            email: _enteredEmail,
            password: _enteredPassword,
            profileImage: _userProfileImage,
            context: context);
      }

      // Check if the widget is still mounted before updating the state
      if (context.mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error during setState: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  //upload Image
  void _selectImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text("Select a Profile Image"),
          children: [
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Take a Photo"),
              onPressed: () async {
                Navigator.of(context).pop();
                final userImage =
                    await ImagePicker().pickImage(source: ImageSource.camera);

                setState(() {
                  _userProfileImage = File(userImage!.path);
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Choose form Gallery"),
              onPressed: () async {
                Navigator.of(context).pop();
                final userImage =
                    await ImagePicker().pickImage(source: ImageSource.gallery);

                setState(() {
                  _userProfileImage = File(userImage!.path);
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Close"),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Container(
              //   margin: const EdgeInsets.only(
              //       top: 30, bottom: 20, left: 20, right: 20),
              //   width: 300,
              //   child: Image.asset(
              //     "assets/chat.png",
              //   ),
              // ),

              //form
              Card(
                color: const Color.fromARGB(255, 252, 251, 251),
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          !_isLogin
                              ? Stack(
                                  children: [
                                    CircleAvatar(
                                        radius: 50,
                                        backgroundColor: Colors.grey[400],
                                        backgroundImage:
                                            _userProfileImage != null
                                                ? FileImage(_userProfileImage!)
                                                : null),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        decoration: const BoxDecoration(
                                          color: Colors.white70,
                                          shape: BoxShape.circle,
                                        ),
                                        child: IconButton(
                                          onPressed: () {
                                            _selectImage(context);
                                          },
                                          icon: const Icon(Icons.add_a_photo),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),
                          !_isLogin
                              ? TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: "Username",
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  autocorrect: false,
                                  enableSuggestions: false,
                                  textCapitalization: TextCapitalization.none,
                                  validator: (value) {
                                    if (value == null ||
                                        value.trim().length < 4) {
                                      return "Please enter a valid username";
                                    } else {
                                      return null;
                                    }
                                  },
                                  onSaved: (value) {
                                    _enteredUsername = value!;
                                  },
                                )
                              : Container(),

                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: "Email Address",
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  !value.contains("@")) {
                                return "Please enter a valid email";
                              } else {
                                return null;
                              }
                            },
                            onSaved: (value) {
                              _enteredEmail = value!;
                            },
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: "Password",
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.trim().length < 6) {
                                return "enter a valid password";
                              } else {
                                return null;
                              }
                            },
                            onSaved: (value) {
                              _enteredPassword = value!;
                            },
                          ),
                          //buttons
                          const SizedBox(
                            height: 12,
                          ),
                          ElevatedButton(
                            onPressed: _formSubmit,
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber, elevation: 0),
                            child: _isLoading
                                ? const CircularProgressIndicator()
                                : Text(
                                    _isLogin ? "Login" : "Signin",
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                          ),

                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isLogin = !_isLogin;
                              });
                            },
                            child: Text(
                              _isLogin
                                  ? "Create an Account"
                                  : "Already have an account",
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:ask_pdf/helpers/helper_functions.dart';

class AuthService {
  //create the firebase auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> registerWithEmailPassword({
    required String username,
    required String email,
    required String password,
    required File? profileImage,
    required BuildContext context,
  }) async {
    try {
      // Create user with email and password
      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Store the image in Firebase Storage
      if (profileImage != null) {
        print("Uploading image...");

        final storageRef = FirebaseStorage.instance
            .ref()
            .child("user-images")
            .child("${userCredential.user!.uid}.jpg");

        try {
          // Upload the profile image
          await storageRef.putFile(
            profileImage,
            // Set the image metadata
            SettableMetadata(
              contentType: 'image/jpg',
            ),
          );

          // Get the download URL of the uploaded image
          final imageUrl = await storageRef.getDownloadURL();
          print("Image URL: $imageUrl");

          //store the user data in firestore
          await FirebaseFirestore.instance
              .collection("users")
              .doc(userCredential.user!.uid)
              .set({
            "email": email,
            "profileImageUrl": imageUrl,
            "username": username,
          });
        } catch (uploadError) {
          print('Error uploading profile image: $uploadError');

          return null;
        }
      }

      // Registration successful without image URL
      print('Account created successfully!');
      return null;
    } on FirebaseAuthException catch (error) {
      // Handle FirebaseAuth errors
      if (error.code == "email-already-in-use" && context.mounted) {
        showSnackBarBottom(context, error.message);
      } else if (error.code == "invalid-email" && context.mounted) {
        showSnackBarBottom(context, error.message);
      } else if (error.code == "weak-password" && context.mounted) {
        showSnackBarBottom(context, error.message);
      } else {
        // Handle other FirebaseAuth exceptions
        print('FirebaseAuthException: $error');
        // You may want to show a Snackbar or other user feedback here
      }
      return null; // Signal failure due to FirebaseAuth exception
    } catch (generalError) {
      // Handle other unexpected errors
      print('Unexpected error: $generalError');
      // You may want to show a Snackbar or other user feedback here
      return null; // Signal unexpected error
    }
  }

  //login with email and password
  Future loginWithEmailPassword(
      {required email,
      required password,
      required BuildContext context}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      context.mounted ? (context, "Login Sucessful!") : null;
    } on FirebaseException catch (error) {
      if (error.code == "invalid-email" && context.mounted) {
        //show a snackbar accorgingly
        showSnackBarBottom(context, error.message);
      }
      if (error.code == "wrong-password" && context.mounted) {
        //show a snackbar accorgingly
        showSnackBarBottom(context, error.message);
      }
    }
  }
  //logout

  Future logOutUser() async {
    try {
      await _auth.signOut();
    } catch (error) {
      print(error.toString());
    }
  }
  //Google login
  //facebook login
}

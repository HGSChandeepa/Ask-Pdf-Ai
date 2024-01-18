import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  //instance for the firestore
  final firestore = FirebaseFirestore.instance;

  //save the user data in a users collection
  // TODO:
  //save the chat data in a chat collection
  Future storeTheChats(String message) async {
    try {
      //get the current user data
      final currentUserID = FirebaseAuth.instance.currentUser!.uid;
      //get the username /email/profileImage form  the database

      //create the doc snapshot

      final DocumentSnapshot userSnapshot =
          await firestore.collection("users").doc(currentUserID).get();

      //chcek weather the snapshot exists
      if (userSnapshot.exists) {
        final username = userSnapshot.get("username");
        final email = userSnapshot.get("email");
        final profileImageUrl = userSnapshot.get("profileImageUrl");

        //create a new chat doc using this data
        final DocumentReference chats = firestore.collection("chats").doc();

        //store the new chat
        await chats.set({
          'message': message,
          'senderID': currentUserID,
          'username': username,
          'email': email,
          'profileImage': profileImageUrl,
          'timestamp': FieldValue.serverTimestamp(),
        });

        print("chat stored!");
      }
    } catch (error) {
      print(error.toString());
    }
  }
}

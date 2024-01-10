import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class signInWithGoogle with ChangeNotifier {
  // class signInWithGoogle that inherits from ChangeNotifier to use notify listeners
  final googleSignIn = GoogleSignIn();
  // create an instance of GoogleSignIn to handle the signin process
  googlelogin(Function onSignInSuccess) async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    // Once signed in, return the UserCredential
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    String uid = userCredential.user!.uid;
    // here we insert new doccument that has the username and the email of the user in the firstore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set({'email': googleUser!.email, 'username': googleUser.displayName});
    notifyListeners();
    await onSignInSuccess();
  }
}

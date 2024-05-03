// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class Auth {
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

//   User? get currentUser => _firebaseAuth.currentUser;

//   Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
//   final GoogleSignIn googleSignIn = GoogleSignIn();

//   Future<void> signInWithEmailAndPassword({
//     required String email,
//     required String password,
//   }) async {
//     await _firebaseAuth.signInWithEmailAndPassword(email: '', password: '');
//   }

//   Future<void> createUserWithEmailAndPassword({
//     required String email,
//     required String password,
//   }) async {
//     await _firebaseAuth.createUserWithEmailAndPassword(email: '', password: '');
//   }

//   Future<void> signOut() async {
//     await googleSignIn.signOut();
//     await _firebaseAuth.signOut();
//   }

//   Future<void> signInWithGoogle() async {
//     try {
//       final GoogleSignInAccount? googleSignInAccount =
//           await googleSignIn.signIn();
//       if (googleSignInAccount != null) {
//         final GoogleSignInAuthentication googleSignInAuthentication =
//             await googleSignInAccount.authentication;
//         final AuthCredential credential = GoogleAuthProvider.credential(
//           accessToken: googleSignInAuthentication.accessToken,
//           idToken: googleSignInAuthentication.idToken,
//         );
//         await _firebaseAuth.signInWithCredential(credential);
//       }
//     } catch (e) {
//       print(e.toString());
//       throw e;
//     }
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:healwiz/models/users.dart';

import '../Screens/storage.dart';

class AuthMethods {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<Users> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snapsht =
        await _firestore.collection("users").doc(currentUser.uid).get();

    return Users.fromSnaptoUserm(snapsht);
  }

  // signup

  signUp(
      {required String username,
      required String email,
      required String password,
      BuildContext? context}) async {
    String res = 'some error occured';

    try {
      if (username.isNotEmpty || email.isEmpty || password.isEmpty) {
        // firebase auth signup

        final UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // get url to store in db

        // final String photoUrl = await StorageMethods()
        //     .uploadImageToString('profile-pic', file, false);

// save in firestore

        Users user = Users(
          username: username,
          email: email,
          password: password,
          uid: cred.user!.uid,
        );

        await _firestore.collection('users').doc(cred.user!.uid).set(
              user.tojson(),
            );

        res = "succes";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

// login

  login({
    required String email,
    required String password,
  }) async {
    String res = "some error occured";

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = 'success';
      } else {
        res = "enter all fields";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  signout() async {
    await FirebaseAuth.instance.signOut();
  }

  resetPassword({
    required String email,
    required BuildContext context,
  }) {
    try {
      FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }
}

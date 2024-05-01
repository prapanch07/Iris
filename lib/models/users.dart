import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  final String username;
  final String email;
  final String password;
  final String uid;

  Users({
    required this.username,
    required this.email,
    required this.password,
    required this.uid,
  });

  Map<String, dynamic> tojson() => {
        "username": username,
        "email": email,
        "password": password,
        "uid": uid,
      };

  static Users fromSnaptoUserm(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Users(
      username: snapshot['username'],
      email: snapshot['email'],
      password: snapshot['password'],
      uid: snapshot['uid'],
    );
  }
}

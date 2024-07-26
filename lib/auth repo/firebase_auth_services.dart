import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class FirebaseAuthViewModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<User?> signInwithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } catch (e) {

      Fluttertoast.showToast(
          msg: "User Not Found",
          backgroundColor: Colors.red,
          textColor: Colors.white);
      return null;
    }
  }

  Future<User?> signUpwithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          backgroundColor: Colors.red,
          textColor: Colors.white);

      return null;
    }
  }

  Future<User?> signUpwithGoogle() async {
    try {
      GoogleAuthProvider google = GoogleAuthProvider();
      UserCredential credential = await _auth.signInWithProvider(google);
      return credential.user;
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          backgroundColor: Colors.red,
          textColor: Colors.white);

      return null;
    }
  }

  Future<void> signout() async {
    try {
      _auth.signOut();
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          backgroundColor: Colors.red,
          textColor: Colors.white);
    }
  }
}

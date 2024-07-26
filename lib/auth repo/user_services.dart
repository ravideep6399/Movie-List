import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movieslist/auth%20repo/firebase_auth_services.dart';
import 'package:movieslist/google_sign_in.dart';
import 'package:movieslist/movies_list_page.dart';

class UserViewModel with ChangeNotifier {
  final repo = FirebaseAuthViewModel();
  // ignore: non_constant_identifier_names
  bool Loading = false;
  bool get _Loading => Loading;
  setLoading(value) {
    Loading = value;
    notifyListeners();
  }

  Future<void> googleSignIn(BuildContext context) async {
    setLoading(true);
    repo.signUpwithGoogle().then((value) {
      setLoading(false);
      if (value == null) {
        throw ();
      }
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const MoviesListPage()));
    }).onError((error, stackTrace) {
      Fluttertoast.showToast(
          msg: "Some Error Ocurred",
          backgroundColor: Colors.red,
          textColor: Colors.white);
    });
  }

  Future<void> signOut(BuildContext context) async {
    repo.signout();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginView()));
    Fluttertoast.showToast(
        msg: "You have been logut",
        backgroundColor: const Color.fromARGB(255, 54, 200, 244),
        textColor: Colors.white);
  }
}

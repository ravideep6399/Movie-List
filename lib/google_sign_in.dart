import 'package:flutter/material.dart';
import 'package:movieslist/auth%20repo/user_services.dart';
import 'package:movieslist/long_button.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<UserViewModel>(context);
    bool loading = auth.Loading;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child:loading? const CircularProgressIndicator(color: Colors.blue,):LongButton(
          value: "sign in with Google",
          onPress: () {
            auth.googleSignIn(context);
          },
          color: Colors.blue,
          width: 325,
        ),
      ),
    );
  }
}

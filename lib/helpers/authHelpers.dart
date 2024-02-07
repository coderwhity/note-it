import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:noteit/screens/HomePage.dart';
import 'package:noteit/screens/LoginPage.dart';

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.authStateChanges().first,
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {

          return CircularProgressIndicator();
        } else {

          if (snapshot.hasData && snapshot.data != null) {
            return HomePage();
          }
          return LoginPage();
        }
      },
    );
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:noteit/helpers/authHelpers.dart';
import 'package:noteit/screens/LoginPage.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fbs = FirebaseFirestore.instance;
  Future<void> signInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => StartScreen()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _showToastMessage('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        _showToastMessage('Wrong password provided for that user.');
      } else {
        _showToastMessage("Wrong Email or Password provided.");
      }
    } catch (e) {
      _showToastMessage('Error: $e');
    }
  }

  Future<void> logoutUser(BuildContext context) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  Future<void> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      _showToastMessage("Password reset instructions have been sent to your email");
    } catch (e) {
      // Handle different error cases
      String errorMessage = 'Password reset failed';
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'invalid-email':
            errorMessage = 'Invalid email address';
            break;
          case 'user-not-found':
            errorMessage = 'User not found';
            break;
          default:
            errorMessage = 'Password reset failed';
            break;
        }
      }
      _showToastMessage(errorMessage);
    }
  }

  Future<int> registerWithEmailAndPassword(
      String email, String password, String name) async {
    UserCredential? userCred;
    try {
      userCred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _showToastMessage('The password provided is too weak.');
        return 0;
      } else if (e.code == 'email-already-in-use') {
        _showToastMessage('The account already exists for that email.');
        return 0;
      } else {
        _showToastMessage('Error: ${e.message}');
        return 0;
      }
    } catch (e) {
      _showToastMessage('Error: $e');
      return 0;
    }

    if (userCred != null) {
      try {
        await _fbs.collection("users").doc(userCred.user?.email).set({
          'name': name,
          'email': email,
        });
        _showToastMessage('User registered successfully.');
        return 1;
      } catch (e) {
        _showToastMessage('Error adding user data! Please try again.: $e');
        userCred.user?.delete();
        return 0;
      }
    }
    return 0;
  }

  void _showToastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
    // scaffoldKey.currentState?.showSnackBar(
    //   SnackBar(
    //     content: Text(message),
    //     duration: Duration(seconds: 3),
    //   ),
    // );
  }
}
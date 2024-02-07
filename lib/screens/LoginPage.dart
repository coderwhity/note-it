import 'dart:math';

import 'package:flutter/material.dart';
import 'package:noteit/components/formButton.dart';
import 'package:noteit/components/inputField.dart';
import 'package:noteit/screens/ForgotPasswordPage.dart';
import 'package:noteit/screens/SignupPage.dart';
import 'package:noteit/services/authServices.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool loadingState = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  AuthService authService = new AuthService();

  void _login() async {
    setState(() {
      loadingState = true;
      print("LOADING : ${loadingState}");
    });
    final String email = emailController.text.trim();
    final String password = passController.text;

    if (email.isNotEmpty && password.isNotEmpty) {
      RegExp EmailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
      if (EmailRegex.hasMatch(email)) {
        await authService.signInWithEmailAndPassword(email, password, context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please enter valid Email.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter both email and password'),
          duration: Duration(seconds: 3),
        ),
      );
    }

    setState(() {
      print("END");
      print("LOADING : ${loadingState}");
      loadingState = false;
      print("LOADING : ${loadingState}");
    });
  }

  Color getRadomColor() {
    var colorList = [
      Color.fromARGB(255, 255, 209, 242), // Light Pink
      Color.fromARGB(255, 255, 245, 186), // Light Yellow
      Color.fromARGB(255, 214, 255, 188), // Light Green
      Color.fromARGB(255, 179, 226, 255), // Light Blue
      Color.fromARGB(255, 204, 198, 117), // Pale Gold
      Color.fromARGB(255, 200, 180, 225), // Lavender
      Color.fromARGB(255, 196, 235, 209), // Mint
      Color.fromARGB(255, 153, 204, 255), // Sky Blue
      Color.fromARGB(255, 224, 207, 196), // Muted Rose
      Color.fromARGB(255, 173, 216, 230), // Light Blue
    ];
    Random random = Random();
    int index = random.nextInt(colorList.length);
    return colorList[index];
  }

  void setTitleColor() {
    titleColor = getRadomColor();
    setState(() {
      titleColor;
    });
  }

  Color titleColor = Colors.white;

  @override
  void initState() {
    // TODO: implement initState
    setTitleColor();
    loadingState = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Color.fromARGB(255, 20, 21, 29),
      body: Container(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.note_alt_rounded,
                      size: 60,
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Text(
                      "Welcome Back",
                      style: TextStyle(
                          color: titleColor,
                          fontSize: 23,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    CustomTextInputField(
                        controller: emailController,
                        hintText: "Enter Email",
                        obscureText: false),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTextInputField(
                        controller: passController,
                        hintText: "Enter Password",
                        obscureText: true),
                    SizedBox(
                      height: 20,
                    ),
                    SubmitButton(
                      onTap: () {
                        _login();
                      },
                      title: "Login",
                      loadingState: loadingState,
                      bgColor: titleColor,
                      color: Colors.black,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have account? ",
                          style: TextStyle(color: Colors.white),
                        ),
                        GestureDetector(
                            onTap: () {
                              Route route = MaterialPageRoute(
                                  builder: (context) => SignupPage());
                              Navigator.pushReplacement(context, route);
                            },
                            child: (Text(
                              "Sign Up",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ))),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                            onTap: () {
                              Route route = MaterialPageRoute(
                                  builder: (context) => ForgotPasswordPage());
                              Navigator.pushReplacement(context, route);
                            },
                            child: (Text(
                              "Forgot Password ?",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ))),
                      ],
                    )
                  ]),
            ),
          ),
        ),
      ),
    ));
  }
}

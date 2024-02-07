import 'dart:math';

import 'package:flutter/material.dart';
import 'package:noteit/components/formButton.dart';
import 'package:noteit/components/inputField.dart';
import 'package:noteit/screens/LoginPage.dart';
import 'package:noteit/services/authServices.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool loadingState = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController rePassController = TextEditingController();
  AuthService authService = new AuthService();

  void _signup() async {
    setState(() {
      loadingState = true;
    });
    final String name = nameController.text;
    final String email = emailController.text.trim();
    final String password = passController.text;
    final String repass = rePassController.text;

    if (email.isNotEmpty && password.isNotEmpty && name.isNotEmpty) {
      if (password == repass) {
        RegExp EmailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
        if (EmailRegex.hasMatch(email)) {
          int authResponse = await authService.registerWithEmailAndPassword(
              email, password, name);
          if (authResponse == 1) {
            Route route = MaterialPageRoute(builder: (context) => LoginPage());
            Navigator.pushReplacement(context, route);
          }
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
            content: Text('Passwords do not match'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all the fields.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
    setState(() {
      loadingState = false;
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

  Color titleColor = Colors.black;
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
                      "Hello Welcome to Note It",
                      style: TextStyle(
                          color: titleColor,
                          fontSize: 23,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    CustomTextInputField(
                        controller: nameController,
                        hintText: "Enter Name",
                        obscureText: false),
                    SizedBox(
                      height: 10,
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
                      height: 10,
                    ),
                    CustomTextInputField(
                        controller: rePassController,
                        hintText: "Re-Enter Password",
                        obscureText: true),
                    SizedBox(
                      height: 20,
                    ),
                    SubmitButton(
                      onTap: () {
                        _signup();
                      },
                      title: "Sign Up",
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
                        Text("Already have an account? ",style: TextStyle(color: Colors.white),),
                        GestureDetector(
                            onTap: () {
                              Route route = MaterialPageRoute(
                                  builder: (context) => LoginPage());
                              Navigator.pushReplacement(context, route);
                            },
                            child: (Text(
                              "Login",
                              style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
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

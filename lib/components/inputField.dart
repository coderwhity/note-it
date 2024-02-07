import 'package:flutter/material.dart';

class CustomTextInputField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final String hintText;

  CustomTextInputField({super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(fontSize: 13),
      obscureText: obscureText,
      controller: controller,
      decoration: InputDecoration(
          
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.grey,)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          fillColor: Colors.grey[100],
          filled: true,
          hintText: hintText,
        ),
            
    );  
  }
}
import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final void Function()? onTap;

  final String title;
  bool loadingState;
  var bgColor = Colors.black;
  var color = Colors.white;
  SubmitButton({
    super.key,
    required this.onTap,
    required this.title,
    required this.loadingState,
    Color? bgColor,
    Color? color,
    
  }) : bgColor = bgColor ?? Colors.black,
  color = color ?? Colors.white
  ;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: loadingState ? (){} : onTap,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: bgColor, borderRadius: BorderRadius.circular(15)),
        child: Center(
          child: loadingState? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              semanticsLabel: 'Loading',
              color: Colors.white,
              strokeWidth: 1,
            ),
          ) : Text(
            title,
            style: TextStyle(color: color, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      // ),
    );
  }
}
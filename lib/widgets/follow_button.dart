import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final Function()? function;
  final String text;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
   FollowButton({required this.function, required this.text, required this.borderColor, required this.textColor, required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top:2),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(5),
        ),
        alignment: Alignment.center,
        child: Text(text, style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),),
        width: 250,
        height: 27,
      ),
    );
  }
}


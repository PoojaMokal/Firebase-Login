
import 'package:firebase/widgets/raisedbutton.dart';
import 'package:flutter/cupertino.dart';

class SignInButton extends customeRaisedButton{
  SignInButton({
    String text,
    Color color,
    Color textColor,
    VoidCallback onPressed,
   }): super(
    child: Text(
      text,style: TextStyle(color: textColor,fontSize: 15.0),
    ),
    color: color,
    height: 40.0,
    onPressed: onPressed,
  );
}
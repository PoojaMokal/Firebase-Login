import 'package:firebase/widgets/raisedbutton.dart';
import 'package:flutter/cupertino.dart';

class SocialSignInButton extends customeRaisedButton{
  SocialSignInButton({
    String assetname,
    String text,
    Color color,
    Color textColor,
    VoidCallback onPressed,
  }): super(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: 18,),
        Image.asset(assetname,height: 20,width: 20,),
        SizedBox(width: 10,),
        Text(text,style: TextStyle(color: textColor,fontSize: 15.0),),
      ],
    ),
    color: color,
    height: 40.0,
    onPressed: onPressed,
  );
}
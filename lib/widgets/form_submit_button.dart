import 'package:firebase/widgets/raisedbutton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FormSubmitButton extends customeRaisedButton{
  FormSubmitButton({
    @required String text,
    VoidCallback onPressed,
}): super(
    child: Text(
      text,
      style: TextStyle(color: Colors.white,fontSize: 20.0),
    ),
    height: 44.0,
    color: Colors.indigo,
    borderRadius: 4.0,
    onPressed: onPressed,
  );
}
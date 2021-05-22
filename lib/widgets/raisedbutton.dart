import 'package:flutter/material.dart';

class customeRaisedButton extends StatelessWidget {

  customeRaisedButton({
    this.child,
    this.color,
    this.height:40.0,
    this.borderRadius:4.0,
    this.onPressed,
});

  final Widget child;
  final Color color;
  final double height;
  final double borderRadius;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox(
        height: height,
        child: RaisedButton(
            color: color,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(borderRadius),
                )
            ),
            child: child,
            onPressed: onPressed,),
      ),
    );
  }
}

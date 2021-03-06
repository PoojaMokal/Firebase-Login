import 'package:firebase/app/sigin_app/signin_button.dart';
import 'package:firebase/app/sigin_app/social_signin_button.dart';
import 'package:firebase/services/auth.dart';
import 'package:firebase/widgets/platform_exception_alertdialog.dart';
import 'package:firebase/widgets/raisedbutton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'email_signin_page.dart';

void _showSignInError(BuildContext context,PlatformException exception){
  PlatformExceptionAlertDialog(
    title: 'Sign in failed',
    exception: exception,
  ).show(context);
}

class SignInPage extends StatefulWidget {


  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _isLoading = false;

  Future<void> _signInAnonymously(BuildContext context) async{
    try {
      setState(() => _isLoading =true);
      final auth = Provider.of<AuthBase>(context,listen: false);
      User user = await auth.signInAnonymously();
    }on PlatformException catch(e){
     _showSignInError(context, e);
    }finally{
      setState(() => _isLoading =false);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async{
    try {
      setState(() => _isLoading =true);
      final auth = Provider.of<AuthBase>(context,listen: false);
      User user = await auth.signInWithGoogle();
    }on PlatformException catch(e){
      if(e.code!= 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
      }
    }finally{
      setState(() => _isLoading =false);
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async{
    try {
      setState(() => _isLoading =true);
      final auth = Provider.of<AuthBase>(context,listen: false);
      User user = await auth.signInWithFaceBook();
    }on PlatformException catch(e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
      }
    }finally{
      setState(() => _isLoading =false);
    }
  }

  void _signInWithEmail(BuildContext context){

    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder:(context)=>EmailSignInPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Time Tracker"),
        elevation: 2.0,
      ),
      body: _buildContent(context),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 50.0,
              child: _buildHeader()
          ),


          SizedBox(
            height: 50.0,
          ),
          SocialSignInButton(
            assetname: "images/google-logo1.png",
            text: "Sign In with Google",
            color: Colors.white,
            textColor: Colors.black87,
            onPressed: _isLoading?null:() => _signInWithGoogle(context),
          ),
          SizedBox(
            height: 8.0,
          ),
          SocialSignInButton(
            assetname: "images/facebook-logo.png",
            text: "Sign In with FaceBook",
            color: Color(0xFF334D92),
            textColor: Colors.white,
            onPressed: _isLoading?null:() => _signInWithFacebook(context),
          ),
          SizedBox(
            height: 8.0,
          ),
          SignInButton(
            text: "Sign In with Email",
            color: Colors.pink[400],
            textColor: Colors.white,
            onPressed: _isLoading?null:() => _signInWithEmail(context),
          ),
          SizedBox(
            height: 8.0,
          ),
          Text(
            "or",
            style: TextStyle(
              color: Colors.black87,
              fontSize: 14.0,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8,),
          SignInButton(
            text: "Go anonymous",
            color: Colors.lime,
            textColor: Colors.white,
            onPressed: _isLoading?null:() => _signInAnonymously(context),
          ),
          SizedBox(height: 8,),


        ],
      ),
    );
  }
    Widget _buildHeader(){
      if (_isLoading){
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      return Text(
        "Sign In",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 32.0,
          fontWeight: FontWeight.bold,
        ),
      );

    }
  }


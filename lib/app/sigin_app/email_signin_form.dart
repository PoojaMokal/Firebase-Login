import 'dart:io';

import 'package:firebase/app/sigin_app/email_signin_page.dart';
import 'package:firebase/app/sigin_app/validators.dart';
import 'package:firebase/services/auth.dart';
import 'package:firebase/widgets/form_submit_button.dart';
import 'package:firebase/widgets/platform_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

enum EmailSignInFormType{signIn,register}

class EmailSignInForm extends StatefulWidget with EmailAndPasswordValidators {

  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  String get _email => _emailController.text;
  String get _password => _passwordController.text;
  EmailSignInFormType _formType = EmailSignInFormType.signIn;
  bool _submitted = false;
  bool _isLoading = false;

  void _submit() async{
    print("submit Called");
    setState(() {
      _submitted =true;
      _isLoading =true;
    });
    try {
      final auth = Provider.of<AuthBase>(context,listen: false);
      await Future.delayed(Duration(seconds: 3));
      if (_formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(_email, _password);
      } else {
        await auth.createUserWithEmailAndPassword(_email, _password);
      }
      Navigator.of(context).pop();
    }catch(e){
     PlatformAlertDialog(
       title:  'Sign in Failed',
       content: e.toString(),
       defaultActionText: 'OK',
     ).show(context);
    } finally{
      setState(() {
        _isLoading =false;
      });
    }
  }

  void _emailEditingComplete(){
    final newFocus = widget.emailValidator.isValid(_email)
    ?_passwordFocusNode:_emailFocusNode;
    FocusScope.of(context).requestFocus(_passwordFocusNode);
  }

  void _toogleFormType(){
    setState(() {
      _submitted=false;
      _formType = _formType == EmailSignInFormType.signIn ?
          EmailSignInFormType.register : EmailSignInFormType.signIn;
    });
    _emailController.clear();
    _passwordController.clear();
  }
  List<Widget> _buildChildren() {
    final primaryText = _formType == EmailSignInFormType.signIn ?
        'Sign in' :'Create an account';
    final secondaryText = _formType ==EmailSignInFormType.signIn ?
        'Need an account? Register' : 'Have an account? sign in';
    
    bool submitEnable = widget.emailValidator.isValid(_email) &&
            widget.passwordValidator.isValid(_password) && !_isLoading;

    return [
      _buildEmailTextField(),
      SizedBox(height: 8.0,),
      _buildPasswordTextField(),
      SizedBox(height: 8.0,),
      FormSubmitButton(
        text: primaryText,
        onPressed: submitEnable?_submit:null,
      ),
      SizedBox(height: 8.0,),
      FlatButton(
        child: Text(secondaryText),
          onPressed: !_isLoading? _toogleFormType : null,
      ),
    ];
  }

  TextField _buildPasswordTextField() {
    bool ShowErrorText =_submitted && !widget.passwordValidator.isValid(_password);
    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: ShowErrorText?widget.invalidPasswordErrorText:null,
        enabled: _isLoading == false,
      ),
      obscureText: true,
      textInputAction: TextInputAction.done,
      onChanged: (passsword)=>_updateState(),
      onEditingComplete: _submit,
    );
  }

  TextField _buildEmailTextField() {
    bool ShowErrorText =_submitted && !widget.emailValidator.isValid(_email);
    return TextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'test123@gmail.com',
        errorText: ShowErrorText?widget.invalidEmailErrorText:null,
        enabled: _isLoading == false,
      ),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onChanged: (email) => _updateState(),
      onEditingComplete: _emailEditingComplete,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: _buildChildren(),
      ),
    );
  }

  void _updateState() {
    print('email : $_email, password : $_password');
    setState(() {

    });
  }
}

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class User{
  User({@required this.uid});
  final String uid;
}

abstract class AuthBase{
  Stream<User> get onAuthStateChanged;
  Future<User> currentUser();
  Future<User> signInWithEmailAndPassword(String email, String password);
  Future<User> createUserWithEmailAndPassword(String email, String password);
  Future<User> signInAnonymously();
  Future<User> signInWithGoogle();
  Future<User> signInWithFaceBook();
  Future<void> SignOut();
}

class Auth implements AuthBase{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

    User _userFromFirebase(FirebaseUser user){
      if(user==null){
        return null;
  }
    return User(uid:user.uid);
    }

    Stream<User> get onAuthStateChanged{
      return _firebaseAuth.onAuthStateChanged.map(_userFromFirebase);
    }

    Future<User> currentUser() async{
      FirebaseUser user = await _firebaseAuth.currentUser();
      return _userFromFirebase(user);
    }

    Future<User> signInAnonymously() async{
      FirebaseUser user = await _firebaseAuth.signInAnonymously();
      return _userFromFirebase(user);
    }

    Future<User> signInWithEmailAndPassword(String email, String password) async{
      FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return _userFromFirebase(user);
    }
    Future<User> createUserWithEmailAndPassword(String email, String password) async{
      print("checkfirebaseauthinstance ${_firebaseAuth==null}");
      FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return _userFromFirebase(user);
    }

    //Google auth
    Future<User> signInWithGoogle() async{
      GoogleSignIn googleSignIn = GoogleSignIn();
      GoogleSignInAccount googleUser = await googleSignIn.signIn();

      if(googleUser!=null){
        GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        if (googleAuth.idToken != null && googleAuth.accessToken!=null) {
          FirebaseUser user = await _firebaseAuth.signInWithCredential(
            GoogleAuthProvider.getCredential(
              idToken: googleAuth.idToken,
              accessToken: googleAuth.accessToken
            )
          );
          return _userFromFirebase(user);
        }else {
          throw StateError('Missing Google Auth Token');
        }
      }else{
        throw StateError("Google Sign in aborted");
      }
    }

    Future<User> signInWithFaceBook() async{
      final facebookLogin = FacebookLogin();
      FacebookLoginResult result = await facebookLogin.logInWithReadPermissions(
        ["public_profile"],
      );
      print("checkstatus ${result.errorMessage} ${result.status}");
      if (result.accessToken!=null){
        FirebaseUser user = await _firebaseAuth.signInWithCredential(
          FacebookAuthProvider.getCredential(
          accessToken:result.accessToken.token,
          )
        );
        return _userFromFirebase(user);
      }else{
        throw StateError('Missing Facebook access token');
      }
    }

    Future<void> SignOut() async{
      final googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();

      final facebookLogin = FacebookLogin();
      await facebookLogin.logOut();
      return await _firebaseAuth.signOut();
    }
}
import 'package:firebase/app/sigin_app/sigin_page.dart';
import 'package:firebase/services/auth.dart';
import 'package:flutter/material.dart';
import 'app/landing_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      create: (context) => Auth(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(

          primarySwatch: Colors.indigo,
        ),
        home: LandingPage(
        ),
      ),
    );
  }
}


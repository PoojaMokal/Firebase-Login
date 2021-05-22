import 'package:firebase/services/auth.dart';
import 'package:firebase/widgets/platform_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {

  Future<void> _signOut(BuildContext context) async{
    try {

      final auth = Provider.of<AuthBase>(context,listen: false);
    await auth.SignOut();

    }catch(e){
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context)async {
    final didRequestSignOut = await PlatformAlertDialog(
      title: 'Logout',
      content: 'Are you sure that you want to logout ?',
      cancelActionText: 'cancel',
      defaultActionText: 'logout',
    ).show(context);
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        actions: [
          FlatButton(
            child: Icon(Icons.logout,color: Colors.white,),
            onPressed:() => _confirmSignOut(context),
          )
        ],
      ),
    );
  }
}

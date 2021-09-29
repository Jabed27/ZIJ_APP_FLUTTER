import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zij/Homescreen/home.dart';
import 'package:zij/authenication/SignIn.dart';
import 'package:zij/authenication/ToggleAuthenticationForm.dart';
import 'package:zij/model/user.dart';
import 'package:zij/sharedCode/Nav.dart';

class afterSplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //provider will be ack ed by stream if user is signed out or signed in
    final user = Provider.of<User>(context);
    print('hey $user');
    //whether the user logged in or not
    if (user == null) {
      return ToggleAuthentication();
    } else {
      return Nav();
    }
  }
}

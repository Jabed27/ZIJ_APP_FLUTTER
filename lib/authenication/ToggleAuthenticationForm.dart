import 'package:flutter/material.dart';
import 'package:zij/authenication/SignIn.dart';
import 'package:zij/authenication/register.dart';

class ToggleAuthentication extends StatefulWidget {
  @override
  _ToggleAuthenticationState createState() => _ToggleAuthenticationState();
}

class _ToggleAuthenticationState extends State<ToggleAuthentication> {
  bool showSignIn = true;

  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn == true) {
      return SignIn(toggleView: toggleView);
    } else {
      return Register(toggleView: toggleView);
    }
  }
}

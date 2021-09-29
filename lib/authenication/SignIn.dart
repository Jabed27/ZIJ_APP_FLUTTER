import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zij/Homescreen/home.dart';
import 'package:zij/authenication/register.dart';
import 'package:zij/services/auth.dart';
import 'package:zij/sharedCode/constants.dart';
import 'package:zij/sharedCode/loading.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final Authservices _auth = Authservices();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  //state of the textfield widget
  String email = '';
  String password = '';
  String error = '';
  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.brown[100],
            appBar: AppBar(
              backgroundColor: Colors.brown[400],
              elevation: 0.0,
              title: Text('Sign in to ZIJ'),
              actions: <Widget>[
                FlatButton.icon(
                  icon: Icon(Icons.person),
                  label: Text('Register'),
                  onPressed: () {
                    widget.toggleView();
                  },
                )
              ],
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        decoration:
                            textInputDecorator.copyWith(hintText: 'Email'),
                        validator: (val) =>
                            val.isEmpty ? 'Enter your email' : null,
                        onChanged: (val) {
                          setState(() => email = val);
                        },
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        obscureText: true,
                        decoration:
                            textInputDecorator.copyWith(hintText: 'Password'),
                        validator: (val) =>
                            val.length < 6 ? 'Enter 6+ long pass' : null,
                        onChanged: (val) {
                          setState(() => password = val);
                        },
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      RaisedButton(
                        color: Colors.black,
                        child: Text(
                          'Sign In',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          /*print(email);
                    print(password);*/
                          if (_formKey.currentState.validate()) {
                            print(email);
                            print(password);
                            setState(() {
                              loading = true;
                            });
                            dynamic result =
                                await _auth.SignInWithEmailAndPassword(
                                    email.trim(), password.trim());
                            if (result == null) {
                              setState(() {
                                error =
                                    'Could not sign in with those credentials';
                                loading = false;
                              });
                            }
                          }
                        },
                      ),
                      SizedBox(
                        height: 12.0,
                      ),
                      Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 14.0),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        alignment: Alignment.center,
                        child: FlatButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Register()),
                            );
                          },
                          child: Text(
                            "Don't have an account? Create One",
                            style:
                                TextStyle(color: Colors.brown.withOpacity(0.5)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}

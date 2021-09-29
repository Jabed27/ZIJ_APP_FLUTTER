import 'package:flutter/material.dart';
import 'package:zij/services/auth.dart';
import 'package:zij/userInfo/profileView.dart';

class Home extends StatelessWidget {
  //instance
  final Authservices _auth = Authservices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: Text('ZIJ'),
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        actions: [
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('Logout'),
            onPressed: () async {
              await _auth.signout();
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "See ur map",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Card(
              child: Center(
                child: Column(
                  children: [
                    Container(
                      child: Image.asset('assets/map.png'),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Chat with friends",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Card(
              child: Center(
                child: Column(
                  children: [
                    Container(
                      child: Image.asset('assets/chat.png'),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Check ur todolist",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Card(
              child: Center(
                child: Column(
                  children: [
                    Container(
                      child: Image.asset('assets/todolist.png'),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "See ur profile",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Card(
              child: Center(
                child: Column(
                  children: [
                    Container(
                      child: Image.asset('assets/profile.png'),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

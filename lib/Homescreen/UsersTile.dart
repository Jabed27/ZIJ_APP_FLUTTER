import 'package:flutter/material.dart';
import 'package:zij/model/user.dart';
import 'package:zij/model/usersModel.dart';
import 'package:zij/sharedCode/loading.dart';

class UsersTile extends StatelessWidget {
  final usersModel user;
  UsersTile({this.user});

  @override
  Widget build(BuildContext context) {
    return user == null
        ? Loading()
        : Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Card(
              margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
              child: ListTile(
                leading: //Image.asset(user.Image),
                    CircleAvatar(
                  radius: 25.0,
                  backgroundColor: Colors.brown[50],
                  backgroundImage: NetworkImage(user.image),
                ),
                title: Text(user.username),
                subtitle: Text(user.email),
              ),
            ),
          );
  }
}

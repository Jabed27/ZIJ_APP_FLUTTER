import 'package:flutter/material.dart';
import 'package:zij/Homescreen/userList.dart';
import 'package:zij/model/usersModel.dart';
import 'package:zij/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class AllUserList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<usersModel>>.value(
      value: DatabaseService()
          .users, //stream provider function called to get all users
      child: Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: Text('Friends'),
        ),
        body: UserList(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zij/model/usersModel.dart';

import 'UsersTile.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    final users = Provider.of<List<usersModel>>(context);

    return ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return UsersTile(user: users[index]);
        });
  }
}

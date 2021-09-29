//import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zij/model/SharedPreferenceHelper.dart';
import 'package:zij/model/user.dart';
import 'package:zij/services/auth.dart';
import 'package:zij/services/database.dart';
import 'package:zij/sharedCode/loading.dart';

class Todo extends StatefulWidget {
  @override
  _TodoState createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  final Authservices _auth = Authservices();
  List todos = List();
  String input = " ";
  var username;
  var uid;
  dynamic user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      user = _auth.getCurrentUser();
      print(user);
    });

    SharedPreferenceHelper.readfromlocalstorage().then((user) {
      setState(() {
        uid = user.getuid();
        username = user.getusername();
        print(uid);
        //DatabaseService(uid: uid).readTodoDataFromFIrebase();
      });
    });

    SharedPreferenceHelper.getTodoFromSharedPreference().then((user) {
      setState(() {
        if (user.getTodoList() != null) {
          todos = user.getTodoList();
        }
      });
    });

    print("printing from initstate $todos");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        title: Text("Todo List for $username"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Colors.brown,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                title: Text("Add Todolist"),
                content: TextField(
                  onChanged: (String value) {
                    input = value;
                  },
                ),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () {
                        setState(() {
                          todos.add(input);
                          print("list after addition $todos");
                          print("$input");
                          DatabaseService(uid: uid)
                              .todolistStoring(input, todos);
                        });
                        Navigator.of(context).pop();
                      },
                      child: Text("Add"))
                ],
              );
            },
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.brown,
        ),
      ),
      body: ListView.builder(
          itemCount: todos.length,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              key: Key(todos[index]),
              child: Card(
                elevation: 4,
                margin: EdgeInsets.all(8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: ListTile(
                  title: Text(todos[index]),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.brown,
                    ),
                    onPressed: () {
                      setState(() {
                        print("element:");
                        print(todos.elementAt(index));
                        DatabaseService(uid: uid)
                            .DeleteTodofromFirebase(todos.elementAt(index));
                        todos.removeAt(index);
                        print("list after deletion $todos");

                        // print("deleted item was: ${todos[index]}");
                      });
                    },
                  ),
                ),
              ),
            );
          }),
    );
  }
}

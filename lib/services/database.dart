import 'dart:convert';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zij/model/SharedPreferenceHelper.dart';
import 'package:zij/model/usersModel.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});
  //this function set/overwrites the user data corresponding to the uid
  Future setUserData(String email, String username, String phone, String image,
      String address) async {
    final CollectionReference userCollection =
        Firestore.instance.collection('Users');

    return await userCollection.document(uid).setData({
      'email': email,
      'username': username,
      'Phone': phone,
      'image': image,
      'address': address
    });
  }

  //getting data of user from firebase

  Future getUserData() async {
    var query = Firestore.instance.collection("Users").document(uid);
    query.get().then((snapshot) {
      if (snapshot.exists) {
        SharedPreferenceHelper.setLocalData(
          snapshot.data['email'],
          snapshot.data['Phone'],
          snapshot.data['username'],
          uid,
          snapshot.data['image'],
          snapshot.data['address'],
        );
        //print("email from getuserdata function" + snapshot.data['email']);
      } else {
        print('No such user');
      }
    });
  }

  Future<List<usersModel>> getAllUserData() async {
    List dataList = [];
    SharedPreferences pref = await SharedPreferences.getInstance();
    var query = await Firestore.instance.collection("Users").getDocuments();

    query.documents.forEach((doc) {
      //print(doc.data);
      String json = jsonEncode(doc.data);
      //print("json is stored..${json}");
      dataList.add(json);
    });
    print("dataList is asjskdskjssadlkasd${dataList}");
    pref.setString("key", jsonEncode(dataList));
  }

  Future readfromJson() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    String json = pref.getString("key");
    print("Loaded json data${json}");
  }

  //List from snapshot (converting it to usersModel)
  List<usersModel> _userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return usersModel(
          image: doc.data['image'] ?? '',
          username: doc.data['username'] ?? '',
          email: doc.data['email'] ?? '',
          Phone: doc.data['Phone'] ?? '',
          address: doc.data['address'] ?? '');
    }).toList();
  }

  // this provider will notify if there is any change in firestore user document
  Stream<List<usersModel>> get users {
    return Firestore.instance
        .collection('Users')
        .snapshots()
        .map(_userListFromSnapshot);
  }

  //we can initialize that document with uid so that we can update there. That we have done in todolistStoring(function)
  //todolistStoringInitializer this will be called when a user register
  Future<void> todolistStoringInitializer() async {
    var list = [];
    //print("printing from database todolistStoring $list");
    final CollectionReference todosCollection =
        Firestore.instance.collection('UserTodos');
    todosCollection.document(uid).setData({
      'title': FieldValue.arrayUnion(list),
    });
  }

  //var list = new List<Map<String, dynamic>>();
  var list = [];
  //add todolist in firebase
  Future<void> todolistStoring(String todo, List todoslist) async {
    /* Map<String, dynamic> data = new Map();
    data['Title'] = todo;*/

    list.add(todo);

    //SharedPreferenceHelper.getTodoFromSharedPreference();
    //print("printing from database todolistStoring $list");
    final CollectionReference todosCollection =
        Firestore.instance.collection('UserTodos');
    todosCollection.document(uid).updateData({
      'title': FieldValue.arrayUnion(list),
    });
    SharedPreferenceHelper.setTodoinLocalStorage(todoslist);
  }

  Future DeleteTodofromFirebase(dynamic item) async {
    var val = [];
    /*Map<String, dynamic> data = new Map();
    data['Title'] = item;*/

    //print("which value ${data['Title']}");
    val.add(item);
    print("val list $val");
    Firestore.instance.collection('UserTodos').document(uid).updateData({
      'title': FieldValue.arrayRemove(val),
      //print("deletion done in firebase!!");
    });

    print("deletion done in firebase!!");
    readTodoDataFromFIrebase();
  }

//get todolist in firebase
  //List<Offset> pointList ;
  Future<void> readTodoDataFromFIrebase() async {
    print("readTodoDataFromFIrebase called");

    var documents =
        (await Firestore.instance.collection('UserTodos').getDocuments())
            .documents;
    print('uid : $uid');
    for (var j = 0; j < documents.length; j++) {
      if (documents[j].documentID == uid) {
        print('hghgj$uid');
        print(documents[j].data['title']);
        print(documents[j].data);
        SharedPreferenceHelper.setTodoinLocalStorage(
            documents[j].data['title']);
      }
    }
    var list = SharedPreferenceHelper.getTodoFromSharedPreference();
    //print('list printing from readTodoDataFromFIrebase $list');
  }
}

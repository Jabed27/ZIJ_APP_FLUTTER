import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zij/userInfo/UserTodoDetails.dart';
import 'package:zij/userInfo/userProfileDetails.dart';

class SharedPreferenceHelper {
  //setLocalData function will store all the info of particular user data
  static setLocalData(String email, String phone, String username, String uid,
      String image, String address) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("setlocalData called");
    prefs.setString('email', email);
    prefs.setString('phone', phone);
    prefs.setString('username', username);
    prefs.setString('uid', uid);
    prefs.setBool('session', true);
    prefs.setString('image', image);
    prefs.setString('address', address);
    print("uid: " +
        uid +
        ", username: " +
        username +
        ", phone: " +
        phone +
        ",Email: " +
        email +
        ",address" +
        address);
  }

  //deleting localdata while logout
  static deletinglocaldata() async {
    print("deletinglocaldata called");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', '');
    prefs.setString('phone', '');
    prefs.setString('username', '');
    prefs.setString('uid', '');
    prefs.setBool('session', false);
    prefs.setString('image', '');
    prefs.setString('address', '');
  }

  //todolist storing in shared pref
  static List arr;
  static setTodoinLocalStorage(List todo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("settodoinlocalstorage called");
    //arr.add(todo);
    // List<String> convertedList = todo.map((item) => json.encode(item.toMap())).toList();
    List<String> convertedList = todo.map((e) => e.toString()).toList();
    print("converted list : $convertedList");
    prefs.setStringList("stringList", convertedList);
    print("from array $todo");
  }

  //deleting localtododata while logout
  static deleteTodoLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("deleteTodoLocalData called");
    List<String> emptylist;
    prefs.remove("stringList");
  }

  static Future<userTodo> getTodoFromSharedPreference() async {
    print("getTodoFromSharedPreference called");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedStrList = prefs.getStringList('stringList');
    print("savedStrList $savedStrList");
    userTodo tododetails = new userTodo(
      todolist: savedStrList,
    );
    print('to see tododetails $tododetails');
    return tododetails;
  }

  static Future<UserProfileDetails> readfromlocalstorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var image = prefs.getString('image') ?? '';
    var phone = prefs.getString('phone') ?? '';
    var username = prefs.getString('username') ?? '';
    var session = prefs.getBool('session') ?? false;
    var uid = prefs.getString('uid') ?? '';
    var email = prefs.getString('email') ?? '';
    var address = prefs.getString('address') ?? '';
    UserProfileDetails userProfile = new UserProfileDetails(
        phone: phone,
        email: email,
        username: username,
        uid: uid,
        session: session,
        image: image,
        address: address);
    return userProfile;
  }
}

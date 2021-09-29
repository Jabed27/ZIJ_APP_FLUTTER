import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class userTodo {
  List todolist;
  userTodo({this.todolist});

  getTodoList() {
    return todolist;
  }
}

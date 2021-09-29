import 'package:flutter/material.dart';
import 'package:zij/Homescreen/NewsScreen.dart';
import 'package:zij/Homescreen/home.dart';
import 'package:zij/services/auth.dart';
import 'package:zij/userInfo/AllUserList.dart';
import 'package:zij/userInfo/GoogleMapScreen.dart';
import 'package:zij/userInfo/TodoList.dart';
import 'package:zij/userInfo/profileView.dart';

class Nav extends StatefulWidget {
  @override
  _NavState createState() => _NavState();
}

class _NavState extends State<Nav> {
  int _selectedIndex = 0;
  List<Widget> _widgetOption = <Widget>[
    Home(),
    GoogleMapScreen(),
    Todo(),
    ProfileView(),
    AllUserList(),
    NewsScreen(),
  ];
  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final Authservices _auth = Authservices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOption.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.brown[400],
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("Home"),
            backgroundColor: Colors.brown[400],
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            title: Text("Location"),
            backgroundColor: Colors.brown[400],
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note),
            title: Text("Todo"),
            backgroundColor: Colors.brown[400],
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text("Profile"),
            backgroundColor: Colors.brown[400],
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            title: Text("Chat"),
            backgroundColor: Colors.brown[400],
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description),
            title: Text("Newspaper"),
            backgroundColor: Colors.brown[400],
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTap,
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zij/model/SharedPreferenceHelper.dart';
import 'package:zij/services/auth.dart';
import 'package:zij/sharedCode/loading.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String username = " ";
  String phone = " ";
  String email = " ";
  String userDp = " ";
  String uid = " ";
  String address = " ";
  Authservices _auth = Authservices();
  dynamic user;
  void initState() {
    super.initState();
    setState(() {
      user = _auth.getCurrentUser();
    });

    //SharedPreferenceHelper
    SharedPreferenceHelper.readfromlocalstorage().then((user) {
      setState(() {
        uid = user.getuid();
        userDp = user.getImage();
        username = user.getusername();
        email = user.getemail();
        phone = user.getphone();
        address = user.getaddress();
        print("uid: " +
            uid +
            ", username: " +
            username +
            ", phone: " +
            phone +
            ",Email: " +
            email +
            ", image: " +
            user.getImage() +
            ", address: " +
            address);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: username == null || email == null || userDp == null
            ? Loading()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    "See ur profile",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Center(
                    child: Column(
                      children: [
                        Container(
                          child: Image.asset('assets/profile.png'),
                        ),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    /*child: ClipOval(
                child: Image.network(userDp),
              ),*/
                    radius: 100,
                    backgroundColor: Colors.brown[100],
                    backgroundImage: NetworkImage(userDp),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      username,
                      style: TextStyle(fontSize: 20, color: Colors.brown),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Email: " + email,
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "phone: " + phone,
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "address: " + address,
                      style: TextStyle(fontSize: 12),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}

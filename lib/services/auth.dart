import 'package:firebase_auth/firebase_auth.dart';
import 'package:zij/model/SharedPreferenceHelper.dart';
import 'package:zij/model/user.dart';
import 'package:zij/services/database.dart';

class Authservices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //create user obj based on Firebase user
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  //Auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  // Get current User
  Future getCurrentUser() async {
    return await _auth.currentUser();
  }

  //register with email and pass
  Future RegisterWithEmailAndPassword(String username, String email,
      String password, String phone, String image, String address) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      //storing in shared prefrence
      SharedPreferenceHelper.setLocalData(
          email, phone, username, user.uid, image, address);

      //initilizing the toliststoring in database
      //we can initialize that document with uid so that we can update there
      await DatabaseService(uid: user.uid).todolistStoringInitializer();
      //creating a new user document for that user uid
      await DatabaseService(uid: user.uid).setUserData(
          email.trim(), username.trim(), phone.trim(), image, address.trim());
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign in with email and pass
  Future SignInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      DatabaseService(uid: user.uid).getUserData();
      DatabaseService(uid: user.uid).getAllUserData();
      DatabaseService(uid: user.uid).readfromJson();
      DatabaseService(uid: user.uid).readTodoDataFromFIrebase();
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signout() async {
    try {
      SharedPreferenceHelper.deleteTodoLocalData();
      SharedPreferenceHelper.deletinglocaldata();
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}

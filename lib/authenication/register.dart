import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zij/authenication/SignIn.dart';
import 'package:zij/services/auth.dart';
import 'package:zij/sharedCode/constants.dart';
import 'package:zij/sharedCode/loading.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:location/location.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final Authservices _auth = Authservices();
  final _formKey = GlobalKey<FormState>();

  String imageLink;
  File _image;
  bool loading = false;
  //state of the textfield widget
  String email = '';
  String password = '';
  String username = '';
  String phone = '';
  String address = '';
  String error = '';
  final _addressEditingController = TextEditingController();
  LatLng _initialcameraposition = LatLng(20.5937, 78.9629);
  GoogleMapController _controller;
  Location _location = Location();
  geolocator.Position _position;
  StreamSubscription<geolocator.Position> _streamSubscription;
  Address _address;
  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
    _location.onLocationChanged.listen((l) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude, l.longitude), zoom: 15),
        ),
      );
    });
  }

  getUserLocation() {
    var locationOption = geolocator.LocationOptions(
        accuracy: geolocator.LocationAccuracy.best, distanceFilter: 10);
    _streamSubscription = geolocator.Geolocator()
        .getPositionStream(locationOption)
        .listen((geolocator.Position position) {
      setState(() {
        print(position);
        _position = position;
        final cordinates =
            new Coordinates(position.latitude, position.longitude);
        convertCordinatesToAddress(cordinates)
            .then((value) => _address = value);
        print("Address $_address");
        _addressEditingController.text = _address?.addressLine ?? 'please wait';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.brown[100],
            appBar: AppBar(
              backgroundColor: Colors.brown[400],
              elevation: 0.0,
              title: Text('Register in to ZIJ'),
              actions: <Widget>[
                FlatButton.icon(
                  icon: Icon(Icons.person),
                  label: Text('Sign in'),
                  onPressed: () {
                    widget.toggleView();
                  },
                )
              ],
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 20.0,
                      ),
                      imageLink != null
                          ? CircleAvatar(
                              //child: Image.network(imageLink),
                              backgroundImage: NetworkImage(imageLink),
                              radius: 100,
                            )
                          : CircleAvatar(
                              /*child: Icon(
                                Icons.person,
                                size: 100,
                              ),*/
                              child: Icon(
                                Icons.person,
                                size: 100,
                              ),
                              radius: 100,
                            ),
                      SizedBox(
                        height: 10.0,
                      ),
                      FlatButton(
                        onPressed: () async {
                          PickedFile pickFile = await ImagePicker().getImage(
                            source: ImageSource.gallery,
                          );
                          setState(() {
                            _image = File(pickFile.path);
                            print("Imagesadfsadf $_image");
                            //final bytes = Io.File(_image).readAsBytesSync();
                            //final bytes = I
                            // String img64 = base64Encode(bytes);
                          });
                          FirebaseStorage fs = FirebaseStorage.instance;
                          StorageReference rootReference = fs.ref();
                          StorageReference pctureFolderref =
                              rootReference.child("pictures").child("$_image");
                          pctureFolderref
                              .putFile(_image)
                              .onComplete
                              .then((storageTask) async {
                            String link =
                                await storageTask.ref.getDownloadURL();
                            setState(() {
                              imageLink = link;
                              print("image link $imageLink");
                            });
                          });
                        },
                        child: Text(
                          'Pick Image',
                          style: TextStyle(backgroundColor: Colors.brown[100]),
                        ),
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: Colors.brown,
                                width: 1,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(50)),
                      ),
                      Container(
                        width: double.infinity,
                        height: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black.withOpacity(0.5),
                          boxShadow: [
                            BoxShadow(color: Colors.black, spreadRadius: 3),
                          ],
                        ),
                        child: GoogleMap(
                          initialCameraPosition:
                              CameraPosition(target: _initialcameraposition),
                          mapType: MapType.normal,
                          onMapCreated: _onMapCreated,
                          myLocationEnabled: true,
                        ),
                      ),
                      RaisedButton(
                          color: Colors.brown[100],
                          child: Text("Track Yourself"),
                          onPressed: getUserLocation),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        decoration:
                            textInputDecorator.copyWith(hintText: "address"),
                        controller: _addressEditingController,
                        validator: (val) =>
                            val.isEmpty ? "Track yourself" : null,
                        onChanged: (val) {
                          setState(() => address = val);
                        },
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        decoration:
                            textInputDecorator.copyWith(hintText: 'Username'),
                        validator: (val) =>
                            val.isEmpty ? 'Enter username' : null,
                        onChanged: (val) {
                          setState(() => username = val);
                        },
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        decoration:
                            textInputDecorator.copyWith(hintText: 'Email'),
                        validator: (val) =>
                            val.isEmpty ? 'Enter your email' : null,
                        onChanged: (val) {
                          setState(() => email = val);
                        },
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        decoration:
                            textInputDecorator.copyWith(hintText: 'Password'),
                        validator: (val) =>
                            val.length < 6 ? 'Enter 6+ long pass' : null,
                        obscureText: true,
                        onChanged: (val) {
                          setState(() => password = val);
                        },
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        decoration:
                            textInputDecorator.copyWith(hintText: 'Phone'),
                        validator: (val) =>
                            val.length < 11 ? 'Enter phone number' : null,
                        onChanged: (val) {
                          setState(() => phone = val);
                        },
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      RaisedButton(
                        color: Colors.black,
                        child: Text(
                          'Register',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              loading = true;
                            });
                            print(email);
                            print(password);
                            print(address);
                            print("_address: $_address");
                            print("controller: $_addressEditingController");
                            if (imageLink == null) {
                              setState(() {
                                error = "Please select an image";
                              });
                            }
                            dynamic result =
                                await _auth.RegisterWithEmailAndPassword(
                                    username,
                                    email,
                                    password,
                                    phone,
                                    imageLink,
                                    _addressEditingController.text);
                            if (result == null) {
                              setState(() {
                                error = 'Enter a valid email';
                                loading = false;
                              });
                            }
                          }
                        },
                      ),
                      SizedBox(
                        height: 12.0,
                      ),
                      Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 14.0),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription.cancel();
  }

  Future<Address> convertCordinatesToAddress(Coordinates coordinates) async {
    var address =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    print("${address.first}");
    return address.first;
  }
}

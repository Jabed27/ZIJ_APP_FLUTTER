import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:geolocator/geolocator.dart' as geolocator;

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:zij/services/auth.dart';

class GoogleMapScreen extends StatefulWidget {
  @override
  _GoogleMapScreenState createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  //instance
  final Authservices _auth = Authservices();
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
        accuracy: geolocator.LocationAccuracy.high, distanceFilter: 10);
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
        _addressEditingController.text = _address?.addressLine ?? '-';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*child: GoogleMap(
        initialCameraPosition:
            CameraPosition(target: LatLng(20.5937, 78.9629), zoom: 15),
      ),*/
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: Text('Location'),
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        actions: [
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('Logout'),
            onPressed: () async {
              await _auth.signout();
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text(
              "Find your self",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Center(
              child: Column(
                children: [
                  Container(
                    child: Image.asset('assets/map.png'),
                  ),
                ],
              ),
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
                color: Colors.brown[400],
                child: Text("Track Yourself"),
                onPressed: getUserLocation),
            SizedBox(
              height: 10.0,
            ),
            Text("${_address?.addressLine ?? 'please wait'}"),
            Container(
              padding: EdgeInsets.only(left: 17, right: 17),
              //color: Colors.grey.withOpacity(0.5),
              child: Card(
                child: TextFormField(
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(color: Colors.grey[200])),
                      icon: Icon(
                        Icons.home,
                        color: Colors.brown,
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(color: Colors.grey[300])),
                      filled: true,
                      fillColor: Colors.grey[100],
                      hintText: "address"),
                  controller: _addressEditingController,
                ),
              ),
            ),
          ],
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
    return address.first;
  }
}

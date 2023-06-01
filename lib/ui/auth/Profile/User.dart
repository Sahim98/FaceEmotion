import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facecam/ui/auth/Profile/address.dart';
import 'package:facecam/ui/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

var Current_User = 'null';
var age = "null";

class user extends StatefulWidget {
  const user({super.key});
  @override
  State<user> createState() => _userState();
}

class _userState extends State<user> {
  bool show = true;
  File? _image;
  final picker = ImagePicker();
  String _user = FirebaseAuth.instance.currentUser!.email.toString();

  String Address = 'none';

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> GetAddressFromLatLong(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    Placemark place = placemarks[0];

    Address =
        await '${placemarks[3].name.toString()},${place.administrativeArea}, ${place.country}';
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.fromLTRB(30, 40, 30, 0),
          child: Container(
            child: SingleChildScrollView(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Users')
                      .where('email', isEqualTo: _user)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError || (!snapshot.hasData)) {
                      return SizedBox(
                          child: Container(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 30),
                            Text(
                              "Loading...",
                              style: TextStyle(
                                  fontFamily: 'OpenSans',
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ));
                    }
                    Current_User = snapshot.data!.docs[0]['name'];
                    age = snapshot.data!.docs[0]['age'];
                    String address = snapshot.data!.docs[0]['address'];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Center(
                          child: CircleAvatar(
                            // backgroundImage: AssetImage('user.jpeg'),
                            radius: 40,
                          ),
                        ),
                        Divider(
                          height: 60,
                          color: Colors.grey[800],
                        ),
                        Text(
                          'Name',
                          style:
                              TextStyle(color: Colors.grey, letterSpacing: 2),
                        ),
                        SizedBox(height: 10),
                        Text(
                          Current_User,
                          style: TextStyle(
                              color: Colors.amberAccent[200],
                              letterSpacing: 2,
                              fontSize: 28,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Level',
                          style:
                              TextStyle(color: Colors.grey, letterSpacing: 2),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '8',
                          style: TextStyle(
                              color: Colors.amberAccent[200],
                              letterSpacing: 2,
                              fontSize: 28,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Icon(
                              Icons.email,
                              color: Colors.grey[400],
                            ),
                            Text(
                              ' E-mail',
                              style: TextStyle(
                                  color: Colors.grey, letterSpacing: 2),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            SizedBox(
                              width: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _user,
                                style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 18,
                                    letterSpacing: 1),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.email,
                              color: Colors.grey[400],
                            ),
                            Text(
                              ' Birthdate',
                              style: TextStyle(
                                  color: Colors.grey, letterSpacing: 2),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            SizedBox(
                              width: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                age,
                                style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 18,
                                    letterSpacing: 1),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.location_city,
                              color: Colors.grey[400],
                            ),
                            Text(
                              ' Address',
                              style: TextStyle(
                                  color: Colors.grey, letterSpacing: 2),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            address,
                            style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 18,
                                letterSpacing: 1),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: 30,
                                width: 105,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orangeAccent,
                                    primary: Colors.blue,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DropdownScreen()));
                                  },
                                  icon: Icon(Icons.update),
                                  label: Text('Update'),
                                ),
                              ),
                            ),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.black54),
                                onPressed: () async {
                                  Position position =
                                      await _getGeoLocationPosition();

                                  setState(() async {
                                    await GetAddressFromLatLong(position);
                                  });
                                  print(Address);

                                  // QuerySnapshot<Map<String, dynamic>> snapshot =
                                  //     await FirebaseFirestore.instance
                                  //         .collection('Users')
                                  //         .where('email',
                                  //             isEqualTo: FirebaseAuth
                                  //                 .instance.currentUser!.email
                                  //                 .toString())
                                  //         .get();

                                  // if (snapshot.docs.isNotEmpty) {
                                  //   String documentId = snapshot.docs[0].id;
                                  //   await FirebaseFirestore.instance
                                  //       .collection('Users')
                                  //       .doc(documentId)
                                  //       .update({'address': Address});
                                  //   print(Address);
                                  //   Utils().toastMessage(
                                  //       'Address updated successfully!');
                                  // } else {
                                  //   Utils().toastMessage('Failed to update.');
                                  // }
                                },
                                child: Icon(
                                  Icons.location_on,
                                  color: Colors.green[300],
                                ))
                          ],
                        )
                      ],
                    );
                  }),
            ),
          ),
        ),
      ),
    );
  }
}

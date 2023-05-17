import 'dart:async';
import 'dart:convert' as convert;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facecam/ui/auth/Profile/User.dart';
import 'package:facecam/ui/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:profile/profile.dart';

class DropdownScreen extends StatefulWidget {
  @override
  State<DropdownScreen> createState() => _DropdownScreenState();
}

class _DropdownScreenState extends State<DropdownScreen> {
  String url =
      "https://raw.githubusercontent.com/Sahim98/FaceEmotion/main/lib/country.json";

  var _countries = [];
  var _states = [];
  var _cities = [];

// these will be the values after selection of the item
  String? country;
  String? city;
  String? state;
  final client = http.Client();

// this will help to show the widget after
  bool isCountrySelected = false;
  bool isStateSelected = false;

  //http get request to get data from the link
  Future getWorldData() async {
    var response = await client.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);

      setState(() {
        _countries = jsonResponse;
      });
    }
  }

  @override
  void initState() {
    getWorldData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white.withOpacity(.5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Update",
          style: TextStyle(color: Colors.grey),
        ),
        leading: IconButton(
            color: Colors.grey,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //========================Country

            if (_countries.isEmpty)
              SizedBox(
                  child: Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text(
                      "Loading....",
                      style: TextStyle(
                          fontFamily: 'OpenSans',
                          color: Colors.grey,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Please keep patience.",
                      style: TextStyle(
                          fontFamily: 'OpenSans',
                          color: Colors.grey,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ))
            else
              Card(
                color: Color.fromARGB(255, 180, 165, 183).withOpacity(0.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: DropdownButton<String>(
                      underline: Container(),
                      hint: Text("Select Country"),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      isDense: true,
                      isExpanded: true,
                      items: _countries.map((ctry) {
                        return DropdownMenuItem<String>(
                            value: ctry["name"], child: Text(ctry["name"]));
                      }).toList(),
                      value: country,
                      onChanged: (value) {
                        setState(() {
                          _states = [];
                          country = value!;
                          for (int i = 0; i < _countries.length; i++) {
                            if (_countries[i]["name"] == value) {
                              _states = _countries[i]["states"];
                            }
                          }
                          isCountrySelected = true;
                        });
                      }),
                ),
              ),

//======================================= State
            if (isCountrySelected)
              Card(
                color: Color.fromARGB(255, 167, 161, 168).withOpacity(0.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: Container(
                  padding: const EdgeInsets.all(15.0),
                  child: DropdownButton<String>(
                      underline: Container(),
                      hint: Text("Select State"),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      isDense: true,
                      isExpanded: true,
                      items: _states.map((st) {
                        return DropdownMenuItem<String>(
                            value: st["name"], child: Text(st["name"]));
                      }).toList(),
                      value: state,
                      onChanged: (value) {
                        setState(() {
                          isStateSelected = true;
                          _cities = [];
                          state = value!;
                          for (int i = 0; i < _states.length; i++) {
                            if (_states[i]["name"] == value) {
                              _cities = _states[i]["cities"];
                            }
                          }
                        });
                      }),
                ),
              )
            else
              Container(),

            //=============================== City
            if (isStateSelected)
              Card(
                color: Color.fromARGB(255, 192, 182, 194).withOpacity(0.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: Container(
                  padding: EdgeInsets.all(15),
                  child: DropdownButton<String>(
                      underline: Container(),
                      hint: Text("Select City"),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      isDense: true,
                      isExpanded: true,
                      items: _cities.map((ct) {
                        return DropdownMenuItem<String>(
                            value: ct["name"], child: Text(ct["name"]));
                      }).toList(),
                      value: city,
                      onChanged: (value) {
                        setState(() {
                          city = value!;
                        });
                      }),
                ),
              )
            else
              Container(),
            ElevatedButton(
                onPressed: () async {
                  print("states "+ isStateSelected.toString());
                  String currentAddr = "Country: " +
                      country.toString() +
                      "\n" +
                      "State: " +
                      state.toString() +
                      "\n" +
                      "City: " +
                      (city == null ? "none" : city.toString());

                  QuerySnapshot<Map<String, dynamic>> snapshot =
                      await FirebaseFirestore.instance
                          .collection('Users')
                          .where('email',
                              isEqualTo: FirebaseAuth
                                  .instance.currentUser!.email
                                  .toString())
                          .get();

                  if (snapshot.docs.isNotEmpty) {
                    String documentId = snapshot.docs[0].id;
                    await FirebaseFirestore.instance
                        .collection('Users')
                        .doc(documentId)
                        .update({'address': currentAddr});
                    Utils().toastMessage('Address updated successfully!');

                   if(country != null || state != null) Timer(
                      const Duration(seconds: 2),
                      () {
                        Navigator.pop(context);
                      },
                    );
                  } else {
                    Utils().toastMessage('Failed to update.');
                  }
                },
                child: Text("Update"))
          ],
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facecam/ui/auth/Profile/address.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
                          const Text(
                            'Name',
                            style:
                                TextStyle(color: Colors.grey, letterSpacing: 2),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            Current_User,
                            style: TextStyle(
                                color: Colors.amberAccent[200],
                                letterSpacing: 2,
                                fontSize: 28,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Level',
                            style:
                                TextStyle(color: Colors.grey, letterSpacing: 2),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '8',
                            style: TextStyle(
                                color: Colors.amberAccent[200],
                                letterSpacing: 2,
                                fontSize: 28,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Icon(
                                Icons.email,
                                color: Colors.grey[400],
                              ),
                              const Text(
                                ' E-mail',
                                style: TextStyle(
                                    color: Colors.grey, letterSpacing: 2),
                              ),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              const SizedBox(
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
                          const SizedBox(
                            height: 20,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.email,
                                color: Colors.grey[400],
                              ),
                              const Text(
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
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DropdownScreen(),
                                          ));
                                    },
                                    icon: Icon(Icons.update),
                                    label: Text('Update'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            color: Colors.grey,
                            height:
                                400, // Provide a fixed height or adjust it according to your layout
                            child: InAppWebView(
                              initialUrlRequest: URLRequest(
                                  url: Uri.parse('https://maps.google.com')),
                              androidOnGeolocationPermissionsShowPrompt:
                                  (InAppWebViewController controller,
                                      String origin) async {
                                return GeolocationPermissionShowPromptResponse(
                                  origin: origin,
                                  allow: true,
                                  retain: true,
                                );
                              },
                            ),
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

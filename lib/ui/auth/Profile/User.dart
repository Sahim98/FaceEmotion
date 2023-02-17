import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

String? Current_User = '';

class user extends StatefulWidget {
  const user({super.key});
  @override
  State<user> createState() => _userState();
}

class _userState extends State<user> {
  File? _image;
  int? age;
  final picker = ImagePicker();
  String _user = FirebaseAuth.instance.currentUser!.email.toString();

  @override
  void initState() {
   FirebaseFirestore.instance
        .collection("Users")
        .where("email", isEqualTo: _user).get().then((value) => print(value.docChanges));

    super.initState();
  }

  Future getImg() async {
    var picked = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (picked != null) {
        _image = File(picked.path);
      } else {
        Text('No image selected');
      }
    });
    FirebaseFirestore data = FirebaseFirestore.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      body: Padding(
        padding: EdgeInsets.fromLTRB(30, 40, 30, 0),
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: CircleAvatar(
                      // backgroundImage: AssetImage('user.jpeg'),
                      // radius: 40,
                      ),
                ),
                Divider(
                  height: 60,
                  color: Colors.grey[800],
                ),
                Text(
                  'Name',
                  style: TextStyle(color: Colors.grey, letterSpacing: 2),
                ),
                SizedBox(height: 10),
                Text(
                  'Sahim Salem',
                  style: TextStyle(
                      color: Colors.amberAccent[200],
                      letterSpacing: 2,
                      fontSize: 28,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text(
                  'Level',
                  style: TextStyle(color: Colors.grey, letterSpacing: 2),
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
                      style: TextStyle(color: Colors.grey, letterSpacing: 2),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      _user,
                      style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 18,
                          letterSpacing: 1),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Birthdate',
                  style: TextStyle(color: Colors.grey, letterSpacing: 2),
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.date_range,
                      color: Colors.grey[400],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      '20/10/1998',
                      style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 18,
                          letterSpacing: 1),
                    ),
                  ],
                ),
                Center(
                  child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: TextButton(
                                onPressed: () {
                                  print(_image.toString());
                                  getImg();
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.image,
                                      size: 30,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Upload image',
                                      style: TextStyle(
                                          fontFamily: 'OpenSans',
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                )),
                          ),
                        ),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

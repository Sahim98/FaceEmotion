import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facecam/auth/Profile/address.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
String? Current_User;
var age = "null";

class User extends StatefulWidget {
  const User({super.key});
  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> {
  bool show = true;

  final String _user = FirebaseAuth.instance.currentUser!.email.toString();

  // ignore: non_constant_identifier_names
  String Address = 'none';

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
          padding: const EdgeInsets.fromLTRB(30, 40, 30, 0),
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
                        children: const [
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
                      const Center(
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
                        style: TextStyle(color: Colors.grey, letterSpacing: 2),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        Current_User!,
                        style: TextStyle(
                            color: Colors.amberAccent[200],
                            letterSpacing: 2,
                            fontSize: 28,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Level',
                        style: TextStyle(color: Colors.grey, letterSpacing: 2),
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
                            style:
                                TextStyle(color: Colors.grey, letterSpacing: 2),
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
                            style:
                                TextStyle(color: Colors.grey, letterSpacing: 2),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          const SizedBox(
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
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.location_city,
                            color: Colors.grey[400],
                          ),
                          const Text(
                            ' Address',
                            style:
                                TextStyle(color: Colors.grey, letterSpacing: 2),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const DropdownScreen(),
                                  ));
                            },
                            icon: const Icon(Icons.update),
                            label: const Text('Update'),
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
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }
}

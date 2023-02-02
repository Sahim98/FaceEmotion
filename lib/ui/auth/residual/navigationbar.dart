import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:facecam/ui/auth/About/About.dart';
import 'package:facecam/ui/auth/Profile/User.dart';
import 'package:facecam/ui/auth/Home/home.dart';
import 'package:facecam/ui/auth/Predict/tensorflow.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;
  List ls = [Home(), user(), Tensorflow(), CommentDialog()];
  final _auth = FirebaseAuth.instance;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: ls[_selectedIndex],
        bottomNavigationBar: BottomNavyBar(
          items: <BottomNavyBarItem>[
            BottomNavyBarItem(
                icon: const Icon(Icons.home),
                title: const Text('Home'),
                activeColor: Colors.blueAccent,
                inactiveColor: Colors.purpleAccent),
            BottomNavyBarItem(
                icon: const Icon(Icons.person),
                title: const Text('Profile'),
                activeColor: Colors.blueAccent,
                inactiveColor: Colors.blue),
            BottomNavyBarItem(
                icon: const Icon(Icons.camera),
                title: const Text('Predict'),
                activeColor: Colors.blueAccent,
                inactiveColor: Colors.amberAccent),
            BottomNavyBarItem(
                icon: const Icon(Icons.help),
                title: const Text('About'),
                activeColor: Colors.blueAccent,
                inactiveColor: Colors.orangeAccent),
          ],
          selectedIndex: _selectedIndex,
          onItemSelected: (value) {
            setState(() {
              _selectedIndex = value;
            });
          },
        ),
      ),
    );
  }
}

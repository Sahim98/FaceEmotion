import 'dart:io';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:facecam/auth/About/About.dart';
import 'package:facecam/auth/Profile/User.dart';
import 'package:facecam/auth/Home/home.dart';
import 'package:facecam/auth/Predict/tensorflow.dart';
import 'package:facecam/auth/video/YouTubeVideoScreen.dart';
import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;
  List ls = [
    const Home(),
    const User(),
    const Tensorflow(),
    const YouTubeVideoScreen(),
    const CommentDialog()
  ];


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> onWillPop() async {
      return (await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Are you sure?'),
              content: const Text('Do you want to exit the App'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () => exit(0),
                  child: const Text('Yes'),
                ),
              ],
            ),
          )) ??
          false;
    }

    return WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
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
                  icon: const Icon(Icons.video_collection),
                  title: const Text('Videos'),
                  activeColor: Colors.blueAccent,
                  inactiveColor: Colors.orangeAccent),
              BottomNavyBarItem(
                  icon: const Icon(Icons.help),
                  title: const Text('About'),
                  activeColor: Colors.blueAccent,
                  inactiveColor: Colors.orangeAccent)
            ],
            selectedIndex: _selectedIndex,
            onItemSelected: (value) {
              setState(() {
                _selectedIndex = value;
              });
            },
          ),
        ));
  }
}

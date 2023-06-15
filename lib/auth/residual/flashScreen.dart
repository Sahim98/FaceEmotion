import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:facecam/auth/SignUp/login.dart';
import 'package:facecam/auth/residual/navigationbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: camel_case_types
class flashScreen extends StatefulWidget {
  const flashScreen({super.key});

  @override
  State<flashScreen> createState() => _flashScreenState();
}

class _flashScreenState extends State<flashScreen> {
  final style =
      // ignore: prefer_const_constructors
      TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 36);

  @override
  void initState() {
    isLogin();
    super.initState();
  }

  void isLogin() async {
    final _auth = FirebaseAuth.instance;
    final user = _auth.currentUser;
    SharedPreferences localData = await SharedPreferences.getInstance();

    // ignore: prefer_interpolation_to_compose_strings
    print('remember value in flashscreen: ' +
        localData.getBool('remember').toString());

    if (user != null && localData.containsKey('remember') == true) {
      Timer(
        const Duration(seconds: 2),
        () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return FirebaseAuth.instance.currentUser!.emailVerified
                  ? MyApp()
                  // ignore: prefer_const_constructors
                  : Login();
            },
          ));
        },
      );
    } else {
      Timer(
        const Duration(seconds: 2),
        () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return Login();
            },
          ));
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    isLogin();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              child: Center(
            child: AnimatedTextKit(
              animatedTexts: [
                WavyAnimatedText('Loading...',
                    textStyle: GoogleFonts.dancingScript(textStyle: style)),
              ],
              isRepeatingAnimation: true,
            ),
          )),
        ],
      )),
    );
  }
}

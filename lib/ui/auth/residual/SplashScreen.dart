import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:facecam/ui/auth/SignUp/login.dart';
import 'package:facecam/ui/auth/residual/navigationbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class flashScreen extends StatefulWidget {
  const flashScreen({super.key});

  @override
  State<flashScreen> createState() => _flashScreenState();
}

class _flashScreenState extends State<flashScreen> {
  final style =
      TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 36);
 

  @override
  void initState() {
    isLogin();
    super.initState();
  }

  void isLogin() {
    final _auth = FirebaseAuth.instance;
    final user = _auth.currentUser;

    if (user != null) {
      Timer(
        const Duration(seconds: 2),
        () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return FirebaseAuth.instance.currentUser!.emailVerified
                  ? MyApp()
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



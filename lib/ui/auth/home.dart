import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:facecam/ui/auth/login.dart';
import 'package:facecam/ui/auth/tensorflow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isAuth = false;
  final style = TextStyle(
      fontWeight: FontWeight.bold, fontSize: 40, color: Colors.purple);

  Widget buildAuthScreen() {
    return Text('Authinticated');
  }

  Widget buildUnauthSchreen(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
              // Colors.redAccent,
              Colors.yellowAccent,
              Colors.redAccent
            ])),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 250.0,
              child: DefaultTextStyle(
                style: GoogleFonts.aladin(
                  textStyle: style,
                ),
                child: AnimatedTextKit(
                  repeatForever: true,
                  animatedTexts: [
                    ScaleAnimatedText('Emotion detection'),
                    ScaleAnimatedText('😡😃😥😮')
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SignInButton(
              Buttons.GoogleDark,
              padding: EdgeInsets.all(5),
              text: "Sign in with Google",
              onPressed: () {},
              elevation: 5,
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return Login();
                  },
                ));
              },
              child: Text('Sign in'),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: buildUnauthSchreen(context),
      ),
    );
  }
}

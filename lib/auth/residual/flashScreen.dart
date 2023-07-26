import 'dart:async';
import 'package:facecam/auth/SignUp/login.dart';
import 'package:facecam/auth/residual/navigationbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: camel_case_types
class FlashScreen extends StatefulWidget {
  const FlashScreen({super.key});

  @override
  State<FlashScreen> createState() => _FlashScreenState();
}

class _FlashScreenState extends State<FlashScreen> {
  final style =
      // ignore: prefer_const_constructors
      TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 36);

  @override
  void initState() {
    isLogin();
    super.initState();
  }

  void isLogin() async {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    SharedPreferences localData = await SharedPreferences.getInstance();

    // ignore: prefer_interpolation_to_compose_strings

    if (user != null && localData.containsKey('remember') == true) {
      Timer(
        const Duration(seconds: 5),
        () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return FirebaseAuth.instance.currentUser!.emailVerified
                  ? const MyApp()
                  // ignore: prefer_const_constructors
                  : Login();
            },
          ));
        },
      );
    } else {
      Timer(
        const Duration(seconds: 5),
        () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return const Login();
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
          body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                height: 300,
                width: 300,
                child: Lottie.network(
                  'https://lottie.host/cf705ad5-184e-4afe-acf1-0ff28c40ebc7/TcC65RZaUt.json',
                  repeat: true,
                ),
              ),
              Container(
                alignment: Alignment.center,
                height: 200,
                width: 300,
                child: Lottie.network(
                  'https://lottie.host/fb5e9c6c-88fa-49c9-8a39-1940b667419b/8dtdGB8AC0.json',
                  repeat: true,
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}

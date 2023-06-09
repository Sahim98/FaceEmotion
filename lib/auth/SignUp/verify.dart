import 'dart:async';
import 'package:facecam/auth/SignUp/login.dart';
import 'package:facecam/auth/SignUp/signup.dart';
import 'package:facecam/auth/residual/SplashScreen.dart';
import 'package:facecam/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  //--------variable initialization
  final auth = FirebaseAuth.instance;
  User? user;
  Timer? timer;

  String? message;

  //-------------

  @override
  void initState() {
    user = auth.currentUser;
    user?.sendEmailVerification();
    message = "An email has been sent to ${user!.email} Please verify.";
    Utils().toastMessage("Verify email to login");

    Timer(Duration(seconds: 2), () {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Login()
      ));
    });
    checkEmailVerified();
    super.initState();
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            message!,
            style: TextStyle(
                fontFamily: 'OpenSans', fontSize: 20, color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Future<void> checkEmailVerified() async {
    user = auth.currentUser;
    await user?.reload();
    if (user!.emailVerified) {
      timer!.cancel();
    }
  }
}

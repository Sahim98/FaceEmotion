import 'dart:async';
import 'package:facecam/ui/launch.dart';
import 'package:facecam/ui/home.dart';
import 'package:facecam/ui/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class splashServices {
  void isLogin(BuildContext context) {
    Timer(
      const Duration(seconds: 7),
      () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return Home();
          },
        ));
      },
    );
  }
}

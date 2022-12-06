import 'dart:async';
import 'package:facecam/ui/auth/tensorflow.dart';
import 'package:facecam/ui/launch.dart';

import 'package:facecam/ui/auth/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class splashServices {
  void isLogin(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    final user = _auth.currentUser;

    if(user != null)
    {
       Timer(
      const Duration(seconds: 4),
      () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return Tensorflow();
          },
        ));
      },
    );
      

    }

    else{
       Timer(
      const Duration(seconds: 4),
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
}

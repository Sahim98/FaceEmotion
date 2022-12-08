import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:facecam/ui/auth/design.dart';
import 'package:facecam/ui/auth/login.dart';
import 'package:facecam/ui/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String name = '';
  bool _rememberMe = false;
  bool loading = false;
  final style = TextStyle(fontWeight: FontWeight.bold, color: Colors.white);
  final _formfield = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final _usrcontroller = TextEditingController();
  final datab =
      FirebaseDatabase.instance.ref('Username'); //creating table of Username

  final ref = FirebaseDatabase.instance.ref('Username');

  FirebaseAuth _auth = FirebaseAuth.instance;

  void load_data() {
    datab.ref.child(DateTime.now().microsecondsSinceEpoch.toString()).set({
      'name': _usrcontroller.text.toString(),
    }).then((value) {
      Utils().toastMessage('Post added');
      setState(() {
        loading = false;
      });
    }).onError((error, stackTrace) {
      Utils().toastMessage(error.toString());
      setState(() {
        loading = false;
      });
    });
  }


  

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.amber,
                Colors.orange,
              ],
            ),
          ),
          child: Center(
            child: ListView(
              padding: EdgeInsets.all(25),
              children: [
                Container(
                  height: 53,
                  child: DefaultTextStyle(
                    style: GoogleFonts.aladin(
                      textStyle: TextStyle(fontSize: 35, color: Colors.purple),
                    ),
                    child: Center(
                      child: AnimatedTextKit(
                        repeatForever: true,
                        animatedTexts: [
                          TyperAnimatedText('Emotion detection'),
                          ScaleAnimatedText('😡😃😥😮')
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text('Sign Up',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.aladin(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                ),
                SizedBox(
                  height: 35,
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    'Hi ' + name,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                        fontFamily: 'OpenSans'),
                  ),
                ),
                Form(
                  key: _formfield,
                  child: Column(
                    children: [
                      TextFormField(
                        onChanged: (value) {
                          setState(() {
                            name = value;
                          });

                        },
                        validator: (value) {
                          if (value!.isEmpty)
                            return 'UserName shouldn\'t be empty';
                          else
                            return null;
                        },
                        controller: _usrcontroller,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.person_outline_rounded,
                            color: Colors.white,
                          ),
                          labelText: 'Username',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          filled: true,
                          fillColor: Color.fromARGB(255, 246, 191, 135),
                        ),
                        keyboardType: TextInputType.text,
                        maxLength: 30,
                        autocorrect: true,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty)
                            return 'E-mail is required';
                          else
                            return null;
                        },
                        controller: emailController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.white,
                          ),
                          labelText: 'E-mail',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          filled: true,
                          fillColor: Color.fromARGB(255, 246, 191, 135),
                        ),
                        keyboardType: TextInputType.text,
                        maxLength: 20,
                        autocorrect: true,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty)
                            return 'Password is required';
                          else
                            return null;
                        },
                        obscureText: true,
                        obscuringCharacter: '*',
                        controller: passController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.security,
                            color: Colors.white,
                          ),
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          filled: true,
                          fillColor: Color.fromARGB(255, 246, 191, 135),
                        ),
                        keyboardType: TextInputType.text,
                        maxLength: 10,
                        autocorrect: true,
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 20.0,
                  child: Row(
                    children: <Widget>[
                      Theme(
                        data: ThemeData(unselectedWidgetColor: Colors.white),
                        child: Checkbox(
                          value: _rememberMe,
                          checkColor: Colors.white,
                          activeColor: Colors.green,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value!;
                            });
                          },
                        ),
                      ),
                      Text(
                        'Remember me',
                        style: kLabelStyle,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 25.0),
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.orange[700],
                      elevation: 6,
                      padding: EdgeInsets.all(15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    onPressed: () {
                      if (_formfield.currentState!.validate() ) {
                        _auth
                            .createUserWithEmailAndPassword(
                          email: emailController.text.toString(),
                          password: passController.text.toString(),
                        )
                            .then((value) {
                          setState(() {
                            loading = true;
                            load_data();
                          });
                        }).onError((error, stackTrace) {
                          Utils().toastMessage(
                              ErrorSummary(error.toString()).toString());
                          setState(() {
                            loading = false;
                          });
                        });
                      }
                    },
                    child: loading
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.done,
                                size: 40,
                                color: Colors.green,
                              ),
                              Text('  Signed Up!!')
                            ],
                          )
                        : Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 1.5,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'OpenSans',
                            ),
                          ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: style,
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return Login();
                            },
                          ));
                        },
                        child: Text('Login'))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

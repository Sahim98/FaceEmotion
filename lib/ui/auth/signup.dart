import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:facecam/ui/auth/login.dart';
import 'package:facecam/ui/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final style = TextStyle(fontWeight: FontWeight.bold, color: Colors.grey);
  final _formfield = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  bool loading = false;

  FirebaseAuth _auth = FirebaseAuth.instance;

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
        resizeToAvoidBottomInset : false,
        appBar: AppBar(
          backgroundColor: Colors.amber,
          title: DefaultTextStyle(
            style: GoogleFonts.abel(
                textStyle: style, fontSize: 30, color: Colors.red[300]),
            child: AnimatedTextKit(
              repeatForever: true,
              animatedTexts: [
                ScaleAnimatedText('Sign up'),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Form(
                    key: _formfield,
                    child: Column(
                      children: [
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty)
                              return 'E-mail is required';
                            else
                              return null;
                          },
                          controller: emailController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.email),
                            labelText: 'E-mail',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                            ),
                            filled: true,
                            fillColor: Color.fromARGB(255, 211, 208, 208),
                          ),
                          keyboardType: TextInputType.text,
                          maxLength: 30,
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
                            prefixIcon: Icon(Icons.security),
                            labelText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            filled: true,
                            fillColor: Color.fromARGB(255, 211, 208, 208),
                          ),
                          keyboardType: TextInputType.text,
                          maxLength: 10,
                          autocorrect: true,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.amber, // background
                        onPrimary: Colors.white, // foreground
                      ),
                      onPressed: () {
                        if (_formfield.currentState!.validate()) {
                         
                          _auth
                              .createUserWithEmailAndPassword(
                            email: emailController.text.toString(),
                            password: passController.text.toString(),
                          )
                              .then((value) {
                            setState(() {
                              loading = true;
                            });
                          }).onError((error, stackTrace) {
                            Utils().toastMessage(error.toString());
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
                          : Text('Sign up')),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
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
      ),
    );
  }
}

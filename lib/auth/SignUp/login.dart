// ignore_for_file: prefer_const_constructors

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:facecam/auth/residual/FlashScreen.dart';
import 'package:facecam/auth/residual/design.dart';
import 'package:facecam/auth/SignUp/signup.dart';
import 'package:facecam/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _rememberMe = false, verified = false, loading = false;
  final style = const TextStyle(
      fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white);
  final _formfield = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passController = TextEditingController();

  User? user = FirebaseAuth.instance.currentUser;

  Future<void> login() async {
    setState(() {
      loading = true;
    });
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: emailController.text,
            password: passController.text.toString())
        .then((value) {
      if (FirebaseAuth.instance.currentUser!.emailVerified) {
        setState(() {
          loading = false;
        });
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => FlashScreen()));
      } else {
        Utils().toastMessage('Verify email');
      }
    }).onError((error, stackTrace) {
      Utils().toastMessage(error.toString());
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
      home: WillPopScope(
        onWillPop: () async {
          SystemNavigator.pop();
          return true;
        },
        child: SafeArea(
          child: Scaffold(
            // resizeToAvoidBottomInset: false,
            body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
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
                    SizedBox(
                      height: 53,
                      child: DefaultTextStyle(
                        style: GoogleFonts.aladin(
                          textStyle:
                              TextStyle(fontSize: 35, color: Colors.purple),
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
                      child: Text('Sign In',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.aladin(
                            textStyle: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'OpenSans',
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                    ),
                    Form(
                      key: _formfield,
                      child: Column(
                        children: [
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'E-mail is required';
                              } else if (!FirebaseAuth
                                  .instance.currentUser!.emailVerified) {
                                return "email isn't varified!!";
                              } else {
                                return null;
                              }
                            },
                            controller: emailController,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.email,
                                color: Colors.white,
                              ),
                              labelText: 'E-mail',
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              filled: true,
                              fillColor: Color.fromARGB(255, 246, 191, 135),
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
                              if (value!.isEmpty) {
                                return 'Password is required';
                              } else {
                                return null;
                              }
                            },
                            obscureText: true,
                            obscuringCharacter: '*',
                            controller: passController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.security,
                                color: Colors.white,
                              ),
                              labelText: 'Password',
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
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
                    // ignore: sized_box_for_whitespace
                    Container(
                      height: 20.0,
                      child: Row(
                        children: <Widget>[
                          Theme(
                            data:
                                ThemeData(unselectedWidgetColor: Colors.white),
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
                          // ignore: deprecated_member_use
                          primary: Colors.orange[700],
                          elevation: 6,
                          padding: EdgeInsets.all(15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                        ),
                        onPressed: () async {
                          final SharedPreferences sharedPref =
                              await SharedPreferences.getInstance();
                          sharedPref.setBool('remember', _rememberMe);

                          await login();
                        },
                        child:loading?CircularProgressIndicator(
                          strokeWidth: 5,
                        ): Text(
                          'Login',
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
                    const SizedBox(
                      height: 10,
                    ),

                    if (FirebaseAuth.instance.currentUser != null)
                      ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              verified = true;
                            });
                            FirebaseAuth.instance.currentUser!
                                .sendEmailVerification();
                            Utils().toastMessage('Email has been sent');
                            setState(() {
                              verified = false;
                            });
                          },
                          icon: Icon(Icons.mail),
                          label: verified
                              ? const SizedBox(
                                  height: 12,
                                  width: 12,
                                  child: CircularProgressIndicator())
                              : Text('Resend verification?')),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: style,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return SignUp();
                              },
                            ));
                          },
                          child: const Text('Sign up',
                              style: TextStyle(fontSize: 20)),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                      width: MediaQuery.of(context).size.width,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

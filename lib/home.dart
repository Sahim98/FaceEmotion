import 'package:facecam/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(Home());
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isAuth = false;
  final style =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 40, color: Colors.white);

  Widget buildAuthScreen() {
    return Text('Authinticated');
  }

  Widget buildUnauthSchreen() {
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
            Text(
              'Emotion Detection',
              style: GoogleFonts.aladin(textStyle: style, color: Colors.purple),
            ),
            SizedBox(
              height: 10,
            ),
            SignInButton(
              Buttons.GoogleDark,
              text: "Sign in with Google",
              onPressed: () {},
              elevation: 5,
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AboutDialog(
                      children: [
                        TextField(
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            hintText: 'Enter Name',
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            filled: true,
                            fillColor: Color.fromARGB(255, 211, 208, 208),
                          ),
                          keyboardType: TextInputType.text,
                          maxLength: 40,
                          autocorrect: true,
                          cursorColor: Colors.blue,
                          cursorWidth: 3,
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Sign Up'),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: buildUnauthSchreen(),
      ),
    );
  }
}

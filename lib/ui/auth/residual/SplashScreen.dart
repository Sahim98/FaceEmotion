import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:facecam/firebase%20services/splash%20services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

class flashScreen extends StatefulWidget {
  const flashScreen({super.key});

  @override
  State<flashScreen> createState() => _flashScreenState();
}

class _flashScreenState extends State<flashScreen> {
  final style =
      TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 36);
  splashServices splsc = splashServices();

  @override
  void initState() {
    super.initState();
    splsc.isLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
         
          child: Center(
            child: AnimatedTextKit(
              animatedTexts: [
                WavyAnimatedText('Loading...',
                    textStyle: GoogleFonts.dancingScript(textStyle: style)),
              ],
              isRepeatingAnimation: true,
            ),
          )),
    );
  }
}

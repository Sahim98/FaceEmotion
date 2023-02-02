import 'package:facecam/ui/auth/residual/SplashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(fb());
}

class fb extends StatefulWidget {
  const fb({super.key});

  @override
  State<fb> createState() => _fbState();
}

class _fbState extends State<fb> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: flashScreen()),
    );
  }
}

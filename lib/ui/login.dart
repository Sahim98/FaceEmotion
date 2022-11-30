import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
        labelText: 'Name',
        hintText: 'Enter Name',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        filled: true,
        fillColor: Color.fromARGB(255, 211, 208, 208),
      ),
      keyboardType: TextInputType.text,
      maxLength: 40,
      autocorrect: true,
      cursorColor: Colors.blue,
      cursorWidth: 3,
    );
  }
}

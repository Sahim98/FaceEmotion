import 'package:facecam/ui/auth/custom%20user.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class usr extends StatefulWidget {
  const usr({super.key});

  @override
  State<usr> createState() => _usrState();
}

class _usrState extends State<usr> {
  final auth = FirebaseDatabase.instance;
  final database = FirebaseDatabase.instance.ref('Username');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        leading: IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return MyApp();
              }));
            },
            icon: Icon(Icons.arrow_back_ios)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: FirebaseAnimatedList(
                defaultChild: Text('Loading'),
                query: database,
                itemBuilder: (context, snapshot, animation, index) {
                  return ListTile(
                    title: Text(snapshot.child('name').value.toString()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

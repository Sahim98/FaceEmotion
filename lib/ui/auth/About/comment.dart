import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facecam/ui/auth/About/About.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

final ref = FirebaseDatabase.instance.reference().child('ratings');

class cmnt extends StatefulWidget {
  const cmnt({super.key});

  @override
  State<cmnt> createState() => _cmntState();
}

class _cmntState extends State<cmnt> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: Scaffold(
        body: Center(
            child: StreamBuilder(
          stream: FirebaseDatabase.instance
              .reference()
              .child("Rating")
              .onValue
              .map((event) => event.snapshot),
          builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();
            Map<dynamic, dynamic> ratings =
                snapshot.data?.value as Map<dynamic, dynamic>;
            return ListView.builder(
              itemCount: ratings.values.toList().length,
              itemBuilder: (context, index) {
                var rating;
                if (ratings != null) {
                   rating = ratings[index];
                }

                return ListTile(
                  title: Text(rating['name']),
                  subtitle: Text(rating['comment']),
                  trailing: Text(rating['rating'].toString()),
                );
              },
            );
          },
        )),
      ),
    );
  }
}

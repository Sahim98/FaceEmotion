import 'package:facecam/ui/auth/Profile/User.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Post extends StatefulWidget {
  const Post({super.key});

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  final ref = FirebaseDatabase.instance.ref('Post');
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: StreamBuilder(
          builder: (context, snapshot) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Current_User,
                  style: TextStyle(fontFamily: 'OpenSans', fontSize: 20),
                ),
                Row(
                  children: [
                    Icon(Icons.thumb_up),
                    Icon(Icons.thumb_down),
                  ],
                )
              ],
            );
          },
        ))
      ],
    );
  }
}

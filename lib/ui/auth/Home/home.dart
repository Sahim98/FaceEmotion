// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/src/widgets/framework.dart';

// class Home extends StatefulWidget {
//   const Home({super.key});
//   @override
//   State<Home> createState() => _HomeState();
// }

// Future storeComment(String blogId, String comment) async {
//   final databaseReference = FirebaseDatabase.instance.reference();
//   String? commentId = databaseReference.child('comments').push().key;

//   // Create a new comment object
//   Comment comment = Comment(id: commentId, content: 'comment');

//   // Save the comment to the database
//   databaseReference
//       .child('blogs')
//       .child(blogId)
//       .child('comments')
//       .child('commentId')
//       .set(comment.toJson());

//   //retriving comment

// //        databaseReference.child('blogs').child(blogId).child('comments').onChildAdded.listen((Event event) {
// //   Comment comment = Comment.fromJson(event.snapshot.value);
// //   // Add the comment to a list of comments
// // });
// }

// class Comment {
//   String? id;
//   String? content;

//   Comment({required this.id, required this.content});

//   factory Comment.fromJson(Map<String, dynamic> json) => Comment(
//         id: json['id'],
//         content: json['content'],
//       );

//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'content': content,
//       };
// }

// class _HomeState extends State<Home> {
//   Color thumb_up = Colors.grey;
//   int likes = FirebaseDatabase.instance
//       .reference()
//       .child('Image')
//       .child('blog_id')
//       .child('likes')
//       .key as int;
//   int comment = FirebaseDatabase.instance
//       .reference()
//       .child('Image')
//       .child('blog_id')
//       .child('comment')
//       .key as int;

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         body: SafeArea(
//             child: Card(
//           child: Column(
//             children: [
//               Text("Blog title"),
//               Text("Blog content"),
//               Row(
//                 children: [
//                   IconButton(
//                     icon: Icon(Icons.thumb_up),
//                     onPressed: () {
//                       FirebaseDatabase.instance
//                           .reference()
//                           .child('Image')
//                           .child('blog_id')
//                           .child('likes')
//                           .set(likes + 1);
//                     },
//                   ),
//                   Text("Like count"),
//                   IconButton(
//                     icon: Icon(Icons.comment),
//                     onPressed: () {
//                       // Increment the comment count in the database
//                       FirebaseDatabase.instance
//                           .reference()
//                           .child('blogs')
//                           .child('blog_id')
//                           .child('comments')
//                           .set(comment + 1);
//                     },
//                   ),
//                   Text("Comment count"),
//                 ],
//               ),
//             ],
//           ),
//         )),
//       ),
//     );
//   }
// }


import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
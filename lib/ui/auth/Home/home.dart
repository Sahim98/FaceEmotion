import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String user = 'Sahim';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: SafeArea(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Images')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return SizedBox(
                          child: Container(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 20),
                            Text(
                              "Loading...",
                              style: TextStyle(
                                  fontFamily: 'OpenSans',
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ));
                    }
                    return SizedBox(
                      child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot docum = snapshot.data!.docs[index];
                          String img = docum['image'];
                          int like = docum['like'];
                          int dislike = docum['dislike'];
                          bool give_like = false,
                              give_dislike = true,
                              switched1 = false,
                              switched2 = false;

                          return ListTile(
                              title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(user),
                                    ),
                                    Image.network(img)
                                  ]),
                              subtitle: Row(children: [
                                Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          setState(() {
                                            switched1 = true;
                                          });
                                          setState(() {
                                            give_like = !give_like;
                                            if (give_like) give_dislike = false;
                                          });
                                          if (give_like)
                                            docum.reference
                                                .update({'like': like + 1});
                                          else if (switched1)
                                            docum.reference
                                                .update({'like': like - 1});

                                          print(give_like);
                                          print(give_dislike);
                                        },
                                        icon: Icon(Icons.thumb_up,
                                            color: (give_like
                                                ? Colors.blue
                                                : Colors.grey))),
                                    Text('${like}')
                                  ],
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          print(FirebaseAuth
                                              .instance.currentUser);
                                          setState(() {
                                            switched2 = false;
                                          });
                                          setState(() {
                                            give_dislike = !give_dislike;
                                            if (give_dislike) give_like = false;
                                          });
                                          if (give_dislike)
                                            docum.reference.update(
                                                {'dislike': dislike + 1});
                                          else if (switched2)
                                            docum.reference.update(
                                                {'dislike': dislike - 1});
                                        },
                                        icon: Icon(Icons.thumb_down,
                                            color: (give_dislike
                                                ? Color.fromARGB(
                                                    255, 231, 81, 71)
                                                : Colors.grey))),
                                    Text('${dislike}')
                                  ],
                                ),
                              ]));
                        },
                      ),
                    );
                  }))),
    );
  }
}

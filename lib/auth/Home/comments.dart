import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facecam/auth/Profile/User.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Comments extends StatefulWidget {
  const Comments({super.key, required this.id});
  final String id;

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  final _controller = TextEditingController();

  @override
  void initState() {
    FindUserName();
    super.initState();
  }

  // ignore: non_constant_identifier_names
  FindUserName() async {
    final QuerySnapshot<Map<String, dynamic>> db = await FirebaseFirestore
        .instance
        .collection('Users')
        .where('email',
            isEqualTo: FirebaseAuth.instance.currentUser!.email.toString())
        .limit(1)
        .get();

    final document = db.docs[0];
    final name = document.data();
    final data = name['name'];

    setState(() {
      Current_User = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Comments')
              .orderBy('time')
              .where('pid', isEqualTo: widget.id.toString())
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                    Text(
                      'Loading..',
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'OpenSans',
                          color: Colors.grey),
                    )
                  ],
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot document = snapshot.data!.docs[index];
                        String name = document['name'];
                        String comment = document['comment'];
                        String time = document['time'];

                        // print('document id : ${document['pid']}');
                        // print('post id : ${widget.id}');
                        // print('itemcount : ${snapshot.data!.docs.length}');

                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: ListTile(
                                        title: Row(
                                          children: [
                                            Text(
                                              name,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: 'OpenSans',
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black87),
                                            )
                                          ],
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              comment,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: 'OpenSans',
                                                  color: Colors.blueGrey),
                                            ),
                                            Text(
                                              'at $time',
                                              style:
                                                  const TextStyle(fontSize: 10),
                                            ),
                                          ],
                                        ),
                                        trailing: (name == Current_User)
                                            ? IconButton(
                                                icon: const Icon(
                                                  Icons.delete_outline,
                                                  color: Colors.redAccent,
                                                ),
                                                onPressed: () async {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('Comments')
                                                      .doc(document.id)
                                                      .delete();
                                                },
                                              )
                                            : const SizedBox(
                                                height: 10,
                                                width: 10,
                                              ),
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Form(
                    child: TextFormField(
                      controller: _controller,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () async {
                                String comment = _controller.text.toString();
                                _controller.clear();
                                await FirebaseFirestore.instance
                                    .collection('Comments')
                                    .add({
                                  'comment': comment,
                                  'time': DateFormat('MMM d, h:mm a')
                                      .format(DateTime.now())
                                      .toString(),
                                  'name': Current_User,
                                  'pid': widget.id.toString()
                                });
                              },
                              icon: const Icon(Icons.send)),
                          // ignore: prefer_const_constructors
                          contentPadding: EdgeInsets.all(30),
                          labelText: 'Leave a comment...',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7))),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      )),
    );
  }
}

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facecam/ui/auth/Home/addPost.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

final firestore = FirebaseFirestore.instance;

class _HomeState extends State<Home> {
  String _user = FirebaseAuth.instance.currentUser!.email.toString();

// ---------------add user
  Future<void> addToArrayField(
      String id, String fieldName, List<dynamic> values) async {
    await firestore.collection("Post").doc(id).update({
      fieldName: FieldValue.arrayUnion(values),
    });
  }

  // ---------------remove user
  Future<void> RemoveArrVal(
      String fieldName, String id, List<dynamic> values) async {
    await firestore.collection("Post").doc(id).update({
      fieldName: FieldValue.arrayRemove(values),
    });
  }

// ---------------update user
  Future<void> findInArrayField(
      String fieldName, String id, List<dynamic> values) async {
    DocumentSnapshot doc = await firestore.collection("Post").doc(id).get();
    List<dynamic> fieldValues = doc.get(fieldName);
    if (fieldValues.contains(_user)) {
      await firestore.collection("Post").doc(id).update({
        fieldName: FieldValue.arrayRemove(values),
      });
    } else {
      if (fieldName == 'like')
        RemoveArrVal('dislike', id, values);
      else
        RemoveArrVal('like', id, values);

      await firestore.collection("Post").doc(id).update({
        fieldName: FieldValue.arrayUnion(values),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => AddPost(),
              ));
            },
            backgroundColor: Colors.amber,
            child: Icon(
              Icons.add,
            ),
          ),
          body: SafeArea(
              child: StreamBuilder<QuerySnapshot>(
                  stream:
                      FirebaseFirestore.instance.collection("Post").snapshots(),
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

                          var like = docum['like'];
                          var dislike = docum['dislike'];
                          Color likeColor =
                              like.contains(_user) ? Colors.blue : Colors.grey;
                          Color dislikeColor = dislike.contains(_user)
                              ? Colors.redAccent
                              : Colors.grey;

                          return Card(
                            elevation: 20,
                            margin: EdgeInsets.all(15),
                            child: ListTile(
                                title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          docum['username'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'OpenSans'),
                                        ),
                                      ),
                                      Image.network(img)
                                    ]),
                                subtitle: Row(children: [
                                  Row(
                                    children: [
                                      IconButton(
                                          onPressed: () async {
                                            await findInArrayField(
                                                'like', docum.id, [_user]);
                                          },
                                          icon: Icon(Icons.thumb_up,
                                              color: likeColor)),
                                      Text('${like.length}')
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                          onPressed: () async {
                                            await findInArrayField(
                                                'dislike', docum.id, [_user]);
                                          },
                                          icon: Icon(Icons.thumb_down,
                                              color: dislikeColor)),
                                      Text('${dislike.length}')
                                    ],
                                  ),
                                ])),
                          );
                        },
                      ),
                    );
                  }))),
    );
  }
}

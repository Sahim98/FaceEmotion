import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facecam/ui/auth/About/About.dart';
import 'package:facecam/ui/auth/Home/addPost.dart';
import 'package:facecam/ui/auth/SignUp/login.dart';
import 'package:facecam/ui/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

final firestore = FirebaseFirestore.instance;

class _HomeState extends State<Home> {
  late Stream<QuerySnapshot> dataStream =
      FirebaseFirestore.instance.collection('Post').limit(3).snapshots();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  String _user = FirebaseAuth.instance.currentUser!.email.toString();

// -----------------add user
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
     _loadMoreData(QueryDocumentSnapshot lastDocument) {
      setState(() {
        dataStream = FirebaseFirestore.instance
            .collection('Post')
            .startAfterDocument(lastDocument)
            .limit(3)
            .snapshots();
      });
    }

     _loadPrevData(QueryDocumentSnapshot lastDocument) {
      setState(() {
        dataStream = FirebaseFirestore.instance
            .collection('Post')
            .endBeforeDocument(lastDocument)
            .limitToLast(3)
            .snapshots();
      });
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            elevation: 0,
            leading: Icon(
              Icons.flutter_dash,
              color: Colors.amber,
            ),
            backgroundColor: Colors.white,
            title: Text(
              'Emotion Detection',
              style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 23),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut().then((value) {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return Login();
                        },
                      ));
                    }).onError((error, stackTrace) {
                      Utils().toastMessage("Failed to logout.");
                    });
                  },
                  icon: Icon(
                    Icons.logout,
                    color: Colors.black54,
                  ))
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddPost(),
                  ));
            },
            backgroundColor: Colors.amber,
            child: Icon(
              Icons.add,
            ),
          ),
          body: SafeArea(
              //--------------------------------main section
              child: StreamBuilder<QuerySnapshot>(
                  stream: dataStream,
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

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text('Loading...');
                    }

                    // Process the data here
                    final documents = snapshot.data!.docs;

                    return SizedBox(
                      child: ListView.builder(
                        itemCount: documents.length + 1,
                        itemBuilder: (context, index) {
                          print("index: " + index.toString());

                          if (index == documents.length) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  child: Text('Prev page'),
                                  onPressed: () {
                                    final lastDoc = documents[0];
                                    if (lastDoc != null) _loadPrevData(lastDoc);
                                  },
                                ),
                                TextButton(
                                  child: Text('Next page'),
                                  onPressed: () {
                                    final lastDoc = documents[index - 1];
                                    if (lastDoc != null) _loadMoreData(lastDoc);
                                  },
                                ),
                              ],
                            );
                          }

                          DocumentSnapshot docum = snapshot.data!.docs[index];
                          String img = docum['image'];
                          var like = docum['like'];
                          var dislike = docum['dislike'];
                          Color likeColor =
                              like.contains(_user) ? Colors.blue : Colors.grey;
                          Color dislikeColor = dislike.contains(_user)
                              ? Colors.red
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

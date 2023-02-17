import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

final firestore = FirebaseFirestore.instance;
String _user = FirebaseAuth.instance.currentUser!.email.toString();

Future<void> addToArrayField(
    String documentId, String fieldName, List<dynamic> values) async {
  await firestore.collection('Post').doc(documentId).update({
    fieldName: FieldValue.arrayUnion(values),
  });
}

Future<void> RemoveArrVal(String fieldName, String id) async {
  await firestore.collection("Post").doc(id).update({
    fieldName: FieldValue.arrayRemove([_user])
  });
}

Future<void> findInArrayField(String fieldName, String id) async {
  bool f = false;
 
  await firestore
      .collection("Post")
      .where(fieldName, arrayContains: _user)
      .get()
      .then((querySnapshot) {
    if (querySnapshot.docs.isNotEmpty) {
      f = true;
    }
  });

  if (f == false) {
    await addToArrayField(id, fieldName, [_user]);
  } else {
   await RemoveArrVal(fieldName, id);
  }
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              AlertDialog(
                actions: [],
              );
            },
            backgroundColor: Colors.amber,
            child: Icon(
              Icons.add,
            ),
          ),
          body: SafeArea(
              child: StreamBuilder<QuerySnapshot>(
                  stream:
                      FirebaseFirestore.instance.collection('Post').snapshots(),
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
                          Color color = Colors.grey;

                          return ListTile(
                              title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(_user),
                                    ),
                                    Image.network(img)
                                  ]),
                              subtitle: Row(children: [
                                Row(
                                  children: [
                                    IconButton(
                                        onPressed: () async {
                                          await findInArrayField(
                                              'like', docum.id);
                                        },
                                        icon:
                                            Icon(Icons.thumb_up, color: color)),
                                    Text('${like.length - 1}')
                                  ],
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                        onPressed: () async {
                                          await findInArrayField(
                                              'dislike', docum.id);
                                        },
                                        icon: Icon(Icons.thumb_down,
                                            color: color)),
                                    Text('${dislike.length - 1}')
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

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:facecam/auth/Home/AddPost.dart';
import 'package:facecam/auth/Home/comments.dart';
import 'package:facecam/auth/SignUp/login.dart';
import 'package:facecam/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

final firestore = FirebaseFirestore.instance;

class _HomeState extends State<Home> {
  int page = 1;
  Stream<QuerySnapshot> dataStream = FirebaseFirestore.instance
      .collection('Post')
      .orderBy('username')
      .limit(3)
      .snapshots();

  void handleRemember() async {
    SharedPreferences localData = await SharedPreferences.getInstance();
    bool? reset = localData.getBool('remember');
    if (reset == false) {
      localData.clear();
    }
  }

  @override
  void initState() {
    page = 1;

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

// Future<String> uploadImageToImageBB(String imagePath) async {
//   final apiUrl = Uri.parse('https://api.imgbb.com/1/upload');
//   final apiKey = 'YOUR_API_KEY'; // Replace with your ImageBB API key

//   final response = await http.post(apiUrl, body: {
//     'key': apiKey,
//     'image': base64Encode(await imagePath.readAsBytes()),
//   });

//   if (response.statusCode == 200) {
//     final data = jsonDecode(response.body);
//     final imageUrl = data['data']['url'];
//     return imageUrl;
//   } else {
//     throw Exception('Image upload failed');
//   }
// }

  final String _user = FirebaseAuth.instance.currentUser!.email.toString();

// -----------------add user
  Future<void> addToArrayField(
      String id, String fieldName, List<dynamic> values) async {
    await firestore.collection("Post").doc(id).update({
      fieldName: FieldValue.arrayUnion(values),
    });
  }

  // ---------------remove user
  // ignore: non_constant_identifier_names
  RemoveArrVal(String fieldName, String id, List<dynamic> values) async {
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
      if (fieldName == 'like') {
        RemoveArrVal('dislike', id, values);
      } else {
        RemoveArrVal('like', id, values);
      }

      await firestore.collection("Post").doc(id).update({
        fieldName: FieldValue.arrayUnion(values),
      });
    }
  }

  void _loadMoreData(QueryDocumentSnapshot lastDocument) {
    setState(() {
      dataStream = FirebaseFirestore.instance
          .collection('Post')
          .orderBy('username')
          .startAfterDocument(lastDocument)
          .limit(3)
          .snapshots();
      page++;
    });
  }

  void _loadPrevData(QueryDocumentSnapshot lastDocument) {
    setState(() {
      dataStream = FirebaseFirestore.instance
          .collection('Post')
          .orderBy('username')
          .endBeforeDocument(lastDocument)
          .limitToLast(3)
          .snapshots();
      page--;
    });
  }

  @override
  Widget build(BuildContext context) {
    handleRemember();
    return Scaffold(
      // ignore: duplicate_ignore
      appBar: AppBar(
        titleSpacing: 50,
        elevation: 0,
        leading: const Icon(
          Icons.flutter_dash,
          color: Colors.amber,
        ),
        backgroundColor: Colors.white,
        title: const Text(
          'Home',
          style: TextStyle(
              color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 23),
        ),
        actions: [
          TextButton(
              onPressed: () async {
                SharedPreferences localData =
                    await SharedPreferences.getInstance();
                localData.clear();
                FirebaseAuth.instance.signOut().then((value) {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return const Login();
                    },
                  ));
                }).onError((error, stackTrace) {
                  Utils().toastMessage("Failed to logout.");
                });
              },
              child: const Icon(
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
                builder: (context) => const AddPost(),
              ));
        },
        backgroundColor: Colors.orange,
        child: const Icon(
          Icons.file_upload_rounded,
        ),
      ),
      body: SafeArea(
          //--------------------------------main section
          child: StreamBuilder<QuerySnapshot>(
              stream: dataStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 450,
                          child: Lottie.asset('assets/skeliton.json',
                              repeat: true),
                        ),
                      ],
                    ),
                  );
                }

                final documents = snapshot.data!.docs;
                return SizedBox(
                  child: ListView.builder(
                    itemCount: documents.length + 1,
                    itemBuilder: (context, index) {
                      if (index == documents.length) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () async {
                                  QuerySnapshot<Map<String, dynamic>> snap =
                                      await FirebaseFirestore.instance
                                          .collection('Post')
                                          .orderBy('username')
                                          .endBeforeDocument(documents.first)
                                          .limitToLast(3)
                                          .get();
                                  if (snap.docs.isNotEmpty) {
                                    _loadPrevData(documents.first);
                                  }
                                },
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.blue,
                                )),
                            Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(100)),
                                ),
                                alignment: Alignment.center,
                                height: 45,
                                width: 45,
                                child: Text(
                                  page.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                )),
                            TextButton(
                                onPressed: () async {
                                  QuerySnapshot<Map<String, dynamic>> snap =
                                      await FirebaseFirestore.instance
                                          .collection('Post')
                                          .orderBy('username')
                                          .startAfterDocument(documents.last)
                                          .limit(3)
                                          .get();
                                  if (snap.docs.isNotEmpty) {
                                    _loadMoreData(documents.last);
                                  }
                                },
                                child: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.blue,
                                )),
                          ],
                        );
                      }
                      DocumentSnapshot docum = snapshot.data!.docs[index];
                      String img = docum['image'];
                      var like = docum['like'];
                      var dislike = docum['dislike'];

                      Color likeColor =
                          like.contains(_user) ? Colors.blue : Colors.grey;
                      Color dislikeColor =
                          dislike.contains(_user) ? Colors.red : Colors.grey;

                      return Card(
                        elevation: 8,
                        margin: const EdgeInsets.all(8),
                        child: ListTile(
                            title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextButton(
                                        onPressed: () {},
                                        child: Text(
                                          "@${docum['username']}",
                                          style: const TextStyle(
                                              fontSize: 17,
                                              color: Colors.orange,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'OpenSans'),
                                        )),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    height: 280,
                                    child: Image.network(
                                      img,
                                      filterQuality: FilterQuality.medium,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          // The image has been loaded successfully.
                                          return child;
                                        } else if (loadingProgress
                                                .cumulativeBytesLoaded ==
                                            loadingProgress
                                                .expectedTotalBytes) {
                                          // The image failed to load.
                                          return Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.grey[300],
                                            ),
                                            height: 30,
                                            width: 150,
                                            child:
                                                const Text('Failed to load!!'),
                                          );
                                        } else {
                                          // The image is still loading.
                                          return Column(
                                            children: [
                                              Expanded(
                                                  flex: 1,
                                                  child: Lottie.asset(
                                                      'assets/progressBar.json',
                                                      reverse: true)),
                                              Expanded(
                                                  flex: 3,
                                                  child: Lottie.network(
                                                      'https://lottie.host/a2c7b6fe-1363-4562-95e7-1375d3568f92/zmqqT186Ei.json')),
                                            ],
                                          );
                                        }
                                      },
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        // Error occurred while loading the image.
                                        return Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.grey[300],
                                          ),
                                          height: 30,
                                          width: 150,
                                          child: const Text('Failed to load!!'),
                                        );
                                      },
                                    ),
                                  )
                                ]),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(children: [
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
                                  )
                                ]),
                                Row(
                                  children: [
                                    IconButton(
                                        onPressed: () async {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Comments(
                                                  id: docum.id.toString(),
                                                ),
                                              ));
                                        },
                                        icon: const Icon(
                                            Icons.mode_comment_outlined,
                                            color: Colors.grey)),
                                  ],
                                )
                              ],
                            )),
                      );
                    },
                  ),
                );
              })),
    );
  }
}

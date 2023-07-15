import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facecam/auth/Profile/address.dart';
import 'package:facecam/auth/Profile/sass.dart';
import 'package:facecam/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// ignore: non_constant_identifier_names
String? Current_User;
var age = "null";

class User extends StatefulWidget {
  const User({super.key});
  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> {
  bool show = true;

  final String _user = FirebaseAuth.instance.currentUser!.email.toString();

  // ignore: non_constant_identifier_names
  String Address = 'none';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 40, 30, 0),
          child: SingleChildScrollView(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Users')
                    .where('email', isEqualTo: _user)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError || (!snapshot.hasData)) {
                    return SizedBox(
                        child: Container(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CircularProgressIndicator(),
                          SizedBox(height: 30),
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
                  Current_User = snapshot.data!.docs[0]['name'];
                  age = snapshot.data!.docs[0]['age'];
                  String address = snapshot.data!.docs[0]['address'];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Center(
                        child: CircleAvatar(
                          // backgroundImage: AssetImage('user.jpeg'),
                          radius: 40,
                        ),
                      ),
                      Divider(
                        height: 60,
                        color: Colors.grey[800],
                      ),
                      const Text(
                        'Name',
                        style: TextStyle(color: Colors.grey, letterSpacing: 2),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        Current_User!,
                        style: TextStyle(
                            color: Colors.amberAccent[200],
                            letterSpacing: 2,
                            fontSize: 28,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Level',
                        style: TextStyle(color: Colors.grey, letterSpacing: 2),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '8',
                        style: TextStyle(
                            color: Colors.amberAccent[200],
                            letterSpacing: 2,
                            fontSize: 28,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Icon(
                            Icons.email,
                            color: Colors.grey[400],
                          ),
                          const Text(
                            ' E-mail',
                            style:
                                TextStyle(color: Colors.grey, letterSpacing: 2),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          const SizedBox(
                            width: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              _user,
                              style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 18,
                                  letterSpacing: 1),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.email,
                            color: Colors.grey[400],
                          ),
                          const Text(
                            ' Birthdate',
                            style:
                                TextStyle(color: Colors.grey, letterSpacing: 2),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          const SizedBox(
                            width: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              age,
                              style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 18,
                                  letterSpacing: 1),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.location_city,
                            color: Colors.grey[400],
                          ),
                          const Text(
                            ' Address',
                            style:
                                TextStyle(color: Colors.grey, letterSpacing: 2),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const DropdownScreen(),
                                  ));
                            },
                            icon: const Icon(Icons.update),
                            label: const Text('Update'),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          address,
                          style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 18,
                              letterSpacing: 1),
                        ),
                      ),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16)),
                        child: SassCodeHighlight(),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 400,
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('Post')
                              .where('username', isEqualTo: Current_User)
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
                            final documents = snapshot.data!.docs;
                            return SizedBox(
                              child: ListView.builder(
                                itemCount: documents.length,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot docum =
                                      snapshot.data!.docs[index];
                                  String img = docum['image'];
                                  var like = docum['like'];
                                  var dislike = docum['dislike'];

                                  Color likeColor = like.contains(_user)
                                      ? Colors.blue
                                      : Colors.grey;
                                  Color dislikeColor = dislike.contains(_user)
                                      ? Colors.red
                                      : Colors.grey;
                                  return Card(
                                    elevation: 20,
                                    margin: const EdgeInsets.all(8),
                                    child: ListTile(
                                        title: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: TextButton(
                                                    onPressed: () {},
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "@${docum['username']}",
                                                          style: const TextStyle(
                                                              fontSize: 17,
                                                              color:
                                                                  Colors.orange,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontFamily:
                                                                  'OpenSans'),
                                                        ),
                                                        IconButton(
                                                            onPressed: () {
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'Post')
                                                                  .doc(docum.id)
                                                                  .delete()
                                                                  .then((_) => Utils()
                                                                      .toastMessage(
                                                                          'Post deleted successfully'))
                                                                  .catchError(
                                                                      (error) =>
                                                                          Utils()
                                                                              .toastMessage('Failed to delete POST'));
                                                            },
                                                            icon: const Icon(
                                                              Icons.delete,
                                                              color: Colors.red,
                                                            ))
                                                      ],
                                                    )),
                                              ),
                                              Image.network(img)
                                            ]),
                                        subtitle: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(children: [
                                              Row(
                                                children: [
                                                  IconButton(
                                                      onPressed: () async {},
                                                      icon: Icon(Icons.thumb_up,
                                                          color: likeColor)),
                                                  Text('${like.length}')
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  IconButton(
                                                      onPressed: () async {},
                                                      icon: Icon(
                                                          Icons.thumb_down,
                                                          color: dislikeColor)),
                                                  Text('${dislike.length}')
                                                ],
                                              )
                                            ]),
                                          ],
                                        )),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

// Initialize the Realtime Database
final data = FirebaseFirestore.instance.collection('Ratings').orderBy('time');

void submitRating(double rating, String name, String comment) {
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('yyyy-MM-dd  kk:mm').format(now);
  FirebaseFirestore.instance.collection('Ratings').add({
    'rating': rating,
    'name': name,
    'comment': comment,
    'time': formattedDate
  });
}

class CommentDialog extends StatefulWidget {
  @override
  _CommentDialogState createState() => _CommentDialogState();
}

class _CommentDialogState extends State<CommentDialog> {
  final _formKey = GlobalKey<FormState>();
  final cont = TextEditingController();
  double rate = 0.0, average = 0.0;
  int totalUsers = 0;
  // ignore: non_constant_identifier_names
  bool Loading = true;
  String email = FirebaseAuth.instance.currentUser!.email.toString(),
      // ignore: non_constant_identifier_names
      Current_User = "Anynomus";

  @override
  void initState() {
    calculateAverageRating();
    getRating();
    FindUserName();

    super.initState();
  }

  // ignore: non_constant_identifier_names
  FindUserName() async {
    final QuerySnapshot<Map<String, dynamic>> db = await FirebaseFirestore
        .instance
        .collection('Users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    final document = db.docs[0];
    final name = document.data();
    final data = name['name'];

    setState(() {
      Current_User = data;
    });
  }

  getRating() async {
    final db = FirebaseFirestore.instance.collection('Rate');
    final snapshotSz = await db.get();

    setState(() {
      totalUsers = snapshotSz.size;
    });
    final snapshot = await db
        .where('name',
            isEqualTo: FirebaseAuth.instance.currentUser!.email.toString())
        .get();

    if (snapshot.docs.isNotEmpty) {
      setState(() {
        rate = snapshot.docs.first.data()['rating'] as double;
      });
    }
    setState(() {
      Loading = false;
    });
  }

  calculateAverageRating() async {
    double totalRating = 0;
    int totalDocuments = 0;
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('Rate').get();
    snapshot.docs.forEach((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
      if (doc.exists && doc.data().containsKey('rating')) {
        totalRating += doc.data()['rating'] as double;
        totalDocuments++;
      }
    });

    if (totalDocuments > 0) {
      setState(() {
        average = totalRating / totalDocuments;
      });
    } else {
      setState(() {
        average = 0.0;
      });
    }
    // print("Documents: " + totalDocuments.toString());
    // print("TotalRting: " + totalRating.toString());
    print("Average: $average");
  }

  addOrUpdateRating(double rating) async {
    final db = FirebaseFirestore.instance.collection('Rate');

    final snapshot = await db
        .where('name',
            isEqualTo: FirebaseAuth.instance.currentUser!.email.toString())
        .get();

    if (snapshot.docs.isEmpty) {
      await db.add({
        'name': FirebaseAuth.instance.currentUser!.email.toString(),
        'rating': rating
      });
    } else {
      final docId = snapshot.docs.first.id;
      await db.doc(docId).update({'rating': rating});
    }
    setState(() {
      rate = rating;
    });
    setState(() async {
      await calculateAverageRating();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SafeArea(
        child: Loading
            ? Center(
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
              )
            : Column(
                children: [
                  Text(
                    // ignore: prefer_interpolation_to_compose_strings, unnecessary_brace_in_string_interps
                    "${totalUsers} users rated: " + average.toStringAsFixed(1),
                    style: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                  ),
                  RatingBar.builder(
                    initialRating: rate,
                    minRating: 0,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) async {
                      setState(() async {
                        await addOrUpdateRating(rating);
                      });
                      setState(() async {
                        await calculateAverageRating();
                      });
                    },
                    updateOnDrag: true,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Form(
                    child: TextFormField(
                      maxLines: 5, // <-- SEE HERE
                      minLines: 1,
                      controller: cont,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () async {
                                submitRating(rate, Current_User, cont.text);
                                cont.clear();
                              },
                              icon: const Icon(Icons.send)),
                          // ignore: prefer_const_constructors
                          contentPadding: EdgeInsets.symmetric(vertical: 40),
                          labelText: '    Leave a comment...',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7))),
                    ),
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Text(
                        'Comments:',
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.bold,
                            color: Colors.black87),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                          stream: data.snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Container(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
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
                              ));
                            }
                            return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot document =
                                    snapshot.data!.docs[index];
                                double rating = document['rating'];
                                String name = document['name'];
                                String comment = document['comment'],
                                    time = document['time'].toString();

                                return Padding(
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
                                                  fontSize: 18,
                                                  fontFamily: 'OpenSans',
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black87),
                                            ),
                                            RatingBarIndicator(
                                              rating: rating,
                                              itemBuilder: (context, index) =>
                                                  const Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              itemCount: 5,
                                              itemSize: 12.0,
                                              direction: Axis.horizontal,
                                            ),
                                          ],
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              comment,
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontFamily: 'OpenSans',
                                                  color: Colors.blueGrey),
                                            ),
                                            Text(
                                              'at $time',
                                              style:
                                                  const TextStyle(fontSize: 10),
                                            ),
                                          ],
                                        )),
                                  ),
                                );
                              },
                            );
                          })),
                ],
              ),
      ),
    );
  }
}

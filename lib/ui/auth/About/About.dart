import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facecam/ui/auth/Profile/User.dart';
import 'package:facecam/ui/auth/SignUp/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

// Initialize the Realtime Database
final data = FirebaseFirestore.instance.collection('Ratings');

String User = Current_User;

void submitRating(double rating, String name, String comment) {
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('yyyy-MM-dd - kk:mm').format(now);
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
  double rate = 1.0;

  @override
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SafeArea(
        child: Column(
          children: [
            Text(
              "Rate app",
              style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ),
            RatingBar.builder(
              initialRating: 1,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  rate = rating;
                });
              },
            ),
            SizedBox(
              height: 20,
            ),
            Form(
              child: TextFormField(
                controller: cont,
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () {
                          submitRating(rate, User, cont.text);
                          cont.clear();
                        },
                        icon: Icon(Icons.send)),
                    labelText: 'Leave a comment...',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5))),
              ),
            ),
            SizedBox(
              height: 22,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Comments:',
                  style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey),
                ),
              ],
            ),
            SizedBox(height: 15),
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: data.snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container(
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

                          return Card(
                            elevation: 2,
                            child: ListTile(
                                title: Row(
                                  children: [
                                    Text(
                                      name,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'OpenSans',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueGrey),
                                    ),
                                    RatingBarIndicator(
                                      rating: rating,
                                      itemBuilder: (context, index) => Icon(
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      comment,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'OpenSans',
                                          color: Colors.blueGrey),
                                    ),
                                    Text(
                                      'at ' + time,
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  ],
                                )),
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

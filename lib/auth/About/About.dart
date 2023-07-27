import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

// Initialize the Realtime Database
final data = FirebaseFirestore.instance.collection('FeedBack').orderBy('time');

void submitRating(double rating, String name, String comment) {
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('MMM d, h:mm a').format(now);
  FirebaseFirestore.instance.collection('FeedBack').add({
    'rating': rating,
    'name': name,
    'comment': comment,
    'time': formattedDate
  });
}

class CommentDialog extends StatefulWidget {
  const CommentDialog({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CommentDialogState createState() => _CommentDialogState();
}

class _CommentDialogState extends State<CommentDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation,
      _delay,
      _delay2,
      _delay3,
      transform_animate,
      animation;

  final cont = TextEditingController();
  double rate = 0.0, average = 0.0;
  int totalUsers = 0;

  String email = FirebaseAuth.instance.currentUser!.email.toString();

  @override
  void initState() {
    getRating();
    calculateAverageRating();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1170),
    );
    double initial = -500, ending = 0;

    _animation = Tween<double>(
      begin: initial,
      end: ending,
    ).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.bounceIn));

    _delay = Tween<double>(
      begin: initial,
      end: ending,
    ).animate(CurvedAnimation(
        parent: _animationController,
        curve: const Interval(.5, 1, curve: Curves.bounceIn)));

    _delay2 = Tween<double>(
      begin: initial,
      end: ending,
    ).animate(CurvedAnimation(
        parent: _animationController,
        curve: const Interval(.7, 1, curve: Curves.bounceIn)));

    _delay3 = Tween<double>(
      begin: initial,
      end: ending,
    ).animate(CurvedAnimation(
        parent: _animationController,
        curve: const Interval(.9, 1, curve: Curves.easeIn)));

    animation = Tween(begin: 20.0, end: 100.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.ease),
    );

    transform_animate = BorderRadiusTween(
            begin: BorderRadius.circular(300.0),
            end: BorderRadius.circular(10.0))
        .animate(
            CurvedAnimation(parent: _animationController, curve: Curves.ease));

    _animationController.forward();

    super.initState();
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
  }

  calculateAverageRating() async {
    double totalRating = 0;
    int totalDocuments = 0;
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('Rate').get();
    for (var doc in snapshot.docs) {
      if (doc.exists && doc.data().containsKey('rating')) {
        totalRating += doc.data()['rating'] as double;
        totalDocuments++;
      }
    }

    if (totalDocuments > 0) {
      setState(() {
        average = totalRating / totalDocuments;
      });
    } else {
      setState(() {
        average = 0.0;
      });
    }
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
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                AnimatedBuilder(
                  animation: _animation,
                  builder: (BuildContext context, Widget? child) {
                    return Transform.translate(
                      offset: Offset(_animation.value, 0.0),
                      child: Container(
                        alignment: Alignment.center,
                        height: 50,
                        width: MediaQuery.of(context).size.width * .70,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(40),
                              bottomLeft: Radius.circular(40)),
                          color: Colors.purple,
                        ),
                        child: const Text(
                          "Give us your Rating",
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    );
                  },
                ),
                AnimatedBuilder(
                  animation: _animation,
                  builder: (BuildContext context, Widget? child) {
                    return Transform.translate(
                      offset: Offset(_delay.value, 0.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RatingBar.builder(
                          initialRating: rate,
                          minRating: 0,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 4.0),
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
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                AnimatedBuilder(
                  animation: _delay,
                  builder: (BuildContext context, Widget? child) {
                    return Transform.translate(
                      offset: Offset(_delay2.value, 0.0),
                      child: Container(
                        alignment: Alignment.center,
                        height: 50,
                        width: MediaQuery.of(context).size.width * .60,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          color: Color.fromARGB(255, 249, 192, 106),
                        ),
                        child: Text(
                          "$totalUsers users rated ${average.toStringAsFixed(1)}",
                          style: const TextStyle(
                              fontSize: 20,
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                const SizedBox(
                  height: 22,
                ),
                AnimatedBuilder(
                  animation: _delay2,
                  builder: (BuildContext context, Widget? child) {
                    return Transform.translate(
                        offset: Offset(_delay3.value, 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width * .45,
                              height: 50,
                              decoration: BoxDecoration(
                                  color: Colors.purple,
                                  borderRadius: BorderRadius.circular(30)),
                              child: const Text(
                                'Our location',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'OpenSans',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ));
                  },
                ),
                const SizedBox(height: 15),
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Stack(
                      children: [
                        Center(
                          child: Container(
                            height: animation.value * 4.5,
                            width: animation.value * 3.3,
                            alignment: Alignment.bottomCenter,
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: transform_animate.value),
                            child: InAppWebView(
                              initialUrlRequest: URLRequest(
                                url: Uri.parse(
                                    'https://www.google.com/maps/place/IT+Building/@22.4707201,91.7851549,20.52z/data=!4m6!3m5!1s0x30acd6fcf93fffff:0x12b289338778d80f!8m2!3d22.4705628!4d91.7853893!16s%2Fg%2F11bzq3hr48?entry=ttu'),
                              ),
                              androidOnGeolocationPermissionsShowPrompt:
                                  (InAppWebViewController controller,
                                      String origin) async {
                                return GeolocationPermissionShowPromptResponse(
                                  origin: origin,
                                  allow: true,
                                  retain: true,
                                );
                              },
                            ),
                          ),
                        )
                      ],
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


/*

*/
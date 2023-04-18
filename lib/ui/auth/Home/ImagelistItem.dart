import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ImageListItem extends StatefulWidget {
  final DocumentSnapshot data;

  ImageListItem(this.data);

  @override
  _ImageListItemState createState() => _ImageListItemState();
}

class _ImageListItemState extends State<ImageListItem> {
  bool _isLiked = false;
  bool _isDisliked = false;

  @override
  void initState() {
    super.initState();
    _checkIfLikedOrDisliked();
  }

  void _checkIfLikedOrDisliked() async {
    String? userId = FirebaseAuth.instance.currentUser!.email;
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('likes')
        .doc(widget.data.id)
        .get();
    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      if (data.containsKey(userId)) {
        if (data[userId] == 'like') {
          setState(() {
            _isLiked = true;
          });
        } else if (data[userId] == 'dislike') {
          setState(() {
            _isDisliked = true;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(widget.data['url']),
      title: Text(
          'Likes: ${widget.data['likes']} Dislikes: ${widget.data['dislikes']}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.thumb_up),
            onPressed: () => _likeImage(widget.data),
            color: _isLiked ? Colors.blue : null,
          ),
          IconButton(
            icon: Icon(Icons.thumb_down),
            onPressed: () => _dislikeImage(widget.data),
            color: _isDisliked ? Colors.blue : null,
          ),
        ],
      ),
    );
  }

  void _likeImage(DocumentSnapshot data) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot likesSnapshot =
        await FirebaseFirestore.instance.collection('likes').doc(data.id).get();
    bool hasLiked = likesSnapshot.exists &&
        (likesSnapshot.data() as Map<String, dynamic>).containsKey(userId) &&
        (likesSnapshot.data() as Map<String, dynamic>)[userId] == 'like';
    bool hasDisliked = likesSnapshot.exists &&
        (likesSnapshot.data() as Map<String, dynamic>).containsKey(userId) &&
        (likesSnapshot.data() as Map<String, dynamic>)[userId] == 'dislike';
    if (!hasLiked && !hasDisliked) {
      FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot freshData = await transaction.get(data.reference);
        int likes = freshData['likes'] + 1;
        transaction.update(data.reference, {'likes': likes});
        transaction.set(
          FirebaseFirestore.instance.collection('likes').doc(data.id),
          {userId: 'like'},
          SetOptions(merge: true),
        );
        setState(() {
          _isLiked = true;
        });
      });
    }
  }

  void _dislikeImage(DocumentSnapshot data) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot likesSnapshot = await FirebaseFirestore.instance
        .collection('likes')
        .doc(data.id)
        .get();
    bool hasLiked = likesSnapshot.exists &&
        (likesSnapshot.data() as Map<String, dynamic>).containsKey(userId) &&
        (likesSnapshot.data() as Map<String, dynamic>)[userId] == 'like';
    bool hasDisliked = likesSnapshot.exists &&
        (likesSnapshot.data() as Map<String, dynamic>).containsKey(userId) &&
        (likesSnapshot.data() as Map<String, dynamic>)[userId] == 'dislike';
    if (!hasLiked && !hasDisliked) {
      FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot freshData = await transaction.get(data.reference);
        int dislikes = freshData['dislikes'] + 1;
        transaction.update(data.reference, {'dislikes': dislikes});
        transaction.set(
          FirebaseFirestore.instance.collection('likes').doc(data.id),
          {userId: 'dislike'},
          SetOptions(merge: true),
        );
        setState(() {
          _isDisliked = true;
        });
      });
    }
  }

}

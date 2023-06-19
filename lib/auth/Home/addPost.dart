import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  @override
  void initState() {
    FindUserName();

    super.initState();
  }

//----------variable
  bool isLoading = false;
  ImagePicker imagePicker = ImagePicker();
  String? imageUrl, Current_User;
  File? _image;
  final imgPicker = ImagePicker();
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

//---------------->Image picker
  void pickimage() async {
    var imgGallery = await imgPicker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(imgGallery!.path);
    });
  }

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
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Text(
              "Add post",
              style: TextStyle(color: Colors.grey),
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios),
              color: Colors.grey,
            ),
          ),
          body: Center(
            child: Column(
              children: [
                if (_image == null)
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      'Upload image',
                      style: TextStyle(
                          fontSize: 25,
                          fontFamily: 'OpenSans',
                          color: Colors.grey,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                else
                  Card(
                    elevation: 45,
                    child: Image.file(_image!,
                        fit: BoxFit.cover,
                        height: MediaQuery.of(context).size.height * .5,
                        colorBlendMode: BlendMode.colorBurn),
                  ),
                if (_image == null)
                  ElevatedButton(
                      onPressed: () {
                        pickimage();
                      },
                      child: const Text("Select"))
                else
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      firebase_storage.Reference ref =
                          firebase_storage.FirebaseStorage.instance.ref(
                              '/foldername${DateTime.now().millisecondsSinceEpoch}');
                      firebase_storage.UploadTask uploadTask =
                          ref.putFile(_image!);

                      await Future.value(uploadTask);
                      var newurl = await ref.getDownloadURL();

                      FirebaseFirestore.instance.collection('Post').add({
                        'username': Current_User,
                        'image': newurl.toString(),
                        'like': [],
                        'dislike': []
                      });
                      setState(() {
                        isLoading = false;
                      });
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                    },
                    child: isLoading
                        ? const SizedBox(
                            height: 17.0,
                            width: 17.0,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : const Text("Upload"),
                  ),
                if (isLoading)
                  const Text('Uploading...',
                      style: TextStyle(
                          fontFamily: 'OpenSans',
                          color: Colors.grey,
                          fontWeight: FontWeight.bold)),
                if (isLoading)
                  const Text('Please keep patience.',
                      style: TextStyle(
                          fontFamily: 'OpenSans',
                          color: Colors.grey,
                          fontWeight: FontWeight.bold)),
              ],
            ),
          )),
    );
  }
}

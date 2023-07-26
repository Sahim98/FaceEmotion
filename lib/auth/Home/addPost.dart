import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

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
  // ignore: non_constant_identifier_names
  String? imageUrl, Current_User;
  File? _image;
  final imgPicker = ImagePicker();
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

//---------------->Image picker
  void pickimage() async {
    // ignore: deprecated_member_use
    var imgGallery = await imgPicker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(imgGallery!.path);
    });
  }

  // ignore: non_constant_identifier_names
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
                  Column(
                    children: [
                      Container(
                        height: 300,
                        child: Lottie.network(
                            'https://lottie.host/6a8385c6-0248-42e6-9182-83df55a189a2/gZb8pRhFw2.json'),
                      ),
                      const Text('Upload image',
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'OpenSans',
                              color: Colors.grey,
                              fontWeight: FontWeight.bold)),
                    ],
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
                  Container(
                    alignment: Alignment.center,
                    height: 100,
                    width: 100,
                    child: Lottie.network(
                        'https://lottie.host/4ac94ca4-ba10-459e-a02e-840e4b732adb/YVTNIo6i6o.json',
                        repeat: false),
                  ),
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

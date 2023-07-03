import 'dart:io';
import 'package:facecam/auth/SignUp/login.dart';
import 'package:facecam/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';


class Tensorflow extends StatefulWidget {
  const Tensorflow({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TensorflowState createState() => _TensorflowState();
}

class _TensorflowState extends State<Tensorflow> {
  List? _outputs;
  File? _image;
  bool _loading = false, visible = false;
  final imgPicker = ImagePicker();
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _loading = true;

    loadModel().then((value) {
      setState(() {
        _loading = false;
      });
    });
  }

  loadModel() async {
    await Tflite.loadModel(
      labels: "assets/labels.txt",
      model: "assets/model_unquant.tflite",
      numThreads: 1,
    );
  }

  classifyImage(File? image) async {
    var output = await Tflite.runModelOnImage(
        path: image!.path,
        imageMean: 0.0,
        imageStd: 255.0,
        numResults: 2,
        threshold: 0.2,
        asynch: true);
    setState(() {
      _loading = false;
      _outputs = output;
    });
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  void pickimage() async {
    // ignore: deprecated_member_use
    var imgGallery = await imgPicker.getImage(source: ImageSource.camera);
    setState(() {
      _image = File(imgGallery!.path);
    });

    classifyImage(_image);
  }

 

 

  @override
  Widget build(BuildContext context) {
    List emoji = ["....😀", "...😡", "...😥"];
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: const Icon(
          Icons.flutter_dash,
          color: Colors.amber,
        ),
        backgroundColor: Colors.white,
        title: const Text(
          'Emotion Detection',
          style: TextStyle(
              color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 23),
        ),
        actions: [
          IconButton(
              onPressed: () {
                _auth.signOut().then((value) {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return const Login();
                    },
                  ));
                }).onError((error, stackTrace) {
                  Utils().toastMessage(error.toString());
                });
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.black54,
              ))
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _loading
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: Center(
                          child: Text(
                            'Select an image...',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[500]),
                          ),
                        ),
                      )
                    : Center(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * .8,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              _image == null
                                  ? Container()
                                  : Card(
                                      elevation: 45,
                                      child: Image.file(_image!,
                                          fit: BoxFit.cover,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .5,
                                          colorBlendMode:
                                              BlendMode.colorBurn),
                                    ),
                               const SizedBox(height: 10),
                              _image == null
                                  ? Text(
                                    'No image selected',
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[500]),
                                  )
                                  : _outputs != null
                                      ? Card(
                                          margin: const EdgeInsets.all(8),
                                          elevation: 10,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.all(8.0),
                                            child: Text(
                                              _outputs![0]["label"]
                                                      .substring(
                                                    1,
                                                  ) +
                                                  emoji[int.parse(
                                                      _outputs![0]["label"]
                                                          [0])],
                                              style:const  TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 15,
                                                  fontWeight:
                                                      FontWeight.bold),
                                            ),
                                          ),
                                        )
                                      : Container(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.amber),
                                    onPressed: pickimage,
                                    child:const Icon(
                                      Icons.add_a_photo,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                  
                                      ],
                                    )
                                 
                            ],
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
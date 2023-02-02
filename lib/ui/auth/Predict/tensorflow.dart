import 'dart:io';
import 'package:facecam/ui/auth/SignUp/login.dart';
import 'package:facecam/ui/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class Tensorflow extends StatefulWidget {
  @override
  _TensorflowState createState() => _TensorflowState();
}

class _TensorflowState extends State<Tensorflow> {
  List? _outputs;
  File? _image;
  bool _loading = false;
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
      model: "assets/grayscale_quantized.tflite",
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
    var imgGallery = await imgPicker.getImage(source: ImageSource.camera);
    setState(() {
      _image = File(imgGallery!.path);
    });

    classifyImage(_image);
  }

  @override
  Widget build(BuildContext context) {
    List emoji = ["...😡", "...😀", "...😥", "...😯"];
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: Icon(
          Icons.flutter_dash,
          color: Colors.amber,
        ),
        backgroundColor: Colors.white,
        title: Text(
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
                      return Login();
                    },
                  ));
                }).onError((error, stackTrace) {
                  Utils().toastMessage(error.toString());
                });
              },
              icon: Icon(
                Icons.logout,
                color: Colors.black54,
              ))
        ],
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _loading
                  ? Container(
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
                      child: Container(
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
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .5,
                                        colorBlendMode: BlendMode.colorBurn),
                                  ),
                            SizedBox(height: 10),
                            _image == null
                                ? Container(
                                    child: Text(
                                      'No image selected',
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[500]),
                                    ),
                                  )
                                : _outputs != null
                                    ? Card(
                                      margin: EdgeInsets.all(8),
                                      elevation: 10,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.all(8.0),
                                        child: Text(
                                          _outputs![0]["label"].substring(
                                                1,
                                              ) +
                                              emoji[int.parse(_outputs![0]
                                                  ["label"][0])],
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 15,
                                              fontWeight:
                                                  FontWeight.bold),
                                        ),
                                      ),
                                    )
                                    : Container(),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.amber),
                              onPressed: pickimage,
                              child: Icon(
                                Icons.add_a_photo,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:facecam/ui/auth/SignUp/login.dart';
import 'package:facecam/ui/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class Tensorflow extends StatefulWidget {
  @override
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

  String location = 'Null, Press Button';
  String Address = 'search';

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> GetAddressFromLatLong(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    Placemark place = placemarks[0];

    Address =
        await '${placemarks[3].name.toString()},${place.administrativeArea}, ${place.country}';
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
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .5,
                                          colorBlendMode:
                                              BlendMode.colorBurn),
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
                                              _outputs![0]["label"]
                                                      .substring(
                                                    1,
                                                  ) +
                                                  emoji[int.parse(
                                                      _outputs![0]["label"]
                                                          [0])],
                                              style: TextStyle(
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
                                        primary: Colors.amber),
                                    onPressed: pickimage,
                                    child: Icon(
                                      Icons.add_a_photo,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.black54),
                                      onPressed: () async {
                                        setState(() {
                                          visible = true;
                                        });
                                        setState(() async {
                                          Position position =
                                              await _getGeoLocationPosition();
                                          setState(() {
                                            location =
                                                'Latitude: ${position.latitude} , Longitude: ${position.longitude}';
                                          });

                                          setState(() async {
                                            await GetAddressFromLatLong(
                                                position);
                                          });
                                        });
                                      },
                                      child: Icon(
                                        Icons.location_on,
                                        color: Colors.green[300],
                                      ))
                                ],
                              ),
                              visible
                                  ? Column(
                                      children: [
                                        Text(
                                          'Coordinates Points',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontFamily: 'OpenSans',
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.all(18.0),
                                          child: Text(
                                            location,
                                            style: TextStyle(
                                                fontFamily: 'OpenSans',
                                                color: Colors.black,
                                                fontSize: 16),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          'ADDRESS',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontFamily: 'OpenSans',
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.all(18.0),
                                          child: Text(
                                            '${Address}',
                                            style: TextStyle(
                                                fontFamily: 'OpenSans'),
                                          ),
                                        ),
                                      ],
                                    )
                                  : SizedBox(
                                      height: 10,
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
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facecam/auth/Profile/address.dart';
import 'package:facecam/auth/Profile/imagebb.dart';
import 'package:facecam/auth/Profile/sass.dart';
import 'package:facecam/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:dio/dio.dart';

// ignore: non_constant_identifier_names
String? Current_User;
var age = "null", post_number = 0;

class User extends StatefulWidget {
  const User({super.key});
  @override
  State<User> createState() => _UserState();
}

_createPDF() async {
  PdfDocument document = PdfDocument();
  final page = document.pages.add();

  PdfGrid grid = PdfGrid();
  grid.style = PdfGridStyle(
      font: PdfStandardFont(PdfFontFamily.helvetica, 30),
      cellPadding: PdfPaddings(left: 5, right: 2, top: 2, bottom: 2));

  grid.columns.add(count: 4);
  grid.headers.add(1);

  PdfGridRow header = grid.headers[0];
  header.cells[0].value = 'Name';
  header.cells[1].value = 'email';
  header.cells[2].value = 'Date of Birth';
  header.cells[3].value = 'Number of Post';

  PdfGridRow row = grid.rows.add();

  row.cells[0].value = Current_User;
  row.cells[1].value = FirebaseAuth.instance.currentUser!.email.toString();
  row.cells[2].value = age;
  row.cells[3].value = "  $post_number";

  grid.draw(page: page, bounds: const Rect.fromLTWH(0, 0, 0, 0));

  List<int> bytes = document.saveSync();
  document.dispose();
  saveAndLaunchFile(bytes, 'Output.pdf');
}

Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
  final path = (await getExternalStorageDirectory())?.path;
  final file = File('$path/$fileName');
  await file.writeAsBytes(bytes, flush: true);
  OpenFile.open('$path/$fileName');
}

class _UserState extends State<User> {
  bool show = true;
  final String _user = FirebaseAuth.instance.currentUser!.email.toString();

  String Address = 'none';

  bool delay = true;
  bool loading = false;
  String txt = 'Choose Image';
  Dio dio = Dio();
  late ImgbbResponseModel imgbbResponse;

  late File img;
  final picker = ImagePicker();

  getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      img = File(pickedFile!.path);
    });
    setState(() {
      uploadImageFile(img);
    });
  }

  void uploadImageFile(File img) async {
    setState(() {
      loading = true;
    });
    ByteData bytes = await rootBundle.load(img.path);
    var buffer = bytes.buffer;
    var m = base64.encode(Uint8List.view(buffer));

    FormData formData = FormData.fromMap({"key": "imageBBkey", "image": m});

    Response response = await dio.post(
      "https://api.imgbb.com/1/upload",
      data: formData,
    );

    if (response.statusCode != 400) {
      imgbbResponse = ImgbbResponseModel.fromJson(response.data);
      Utils()
          .toastMessage("ImgbbResponse data${imgbbResponse.data.displayUrl}");
      setState(() {
        delay = false;
        loading = false;
      });
    } else {
      txt = 'Error Upload';
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            _createPDF();
          },
          child: const Icon(Icons.picture_as_pdf)),
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
                    return Center(
                      child: Container(
                          child: Lottie.network(
                              'https://lottie.host/9ec06ac0-25b4-4c55-9a71-c096d83f6921/55Ki6lm5sB.json')),
                    );
                  }
                  Current_User = snapshot.data!.docs[0]['name'];
                  age = snapshot.data!.docs[0]['age'];
                  String address = snapshot.data!.docs[0]['address'];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: InkWell(
                          onTap: () {
                            getImage();
                          },
                          child: const CircleAvatar(
                            backgroundColor: Colors.grey,
                            radius: 50,
                          ),
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
                        post_number.toString(),
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
                      Row(
                        children: [
                          Icon(
                            Icons.date_range,
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

                                  post_number = documents.length;

                                  Color likeColor = like.contains(_user)
                                      ? Colors.blue
                                      : Colors.grey;
                                  Color dislikeColor = dislike.contains(_user)
                                      ? Colors.red
                                      : Colors.grey;
                                  return Card(
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
                                                              Icons
                                                                  .delete_outline,
                                                              color: Colors.red,
                                                            ))
                                                      ],
                                                    )),
                                              ),
                                              Container(
                                                alignment: Alignment.center,
                                                height: 200,
                                                child: Image.network(
                                                  img,
                                                  filterQuality:
                                                      FilterQuality.medium,
                                                  loadingBuilder: (context,
                                                      child, loadingProgress) {
                                                    if (loadingProgress ==
                                                        null) {
                                                      // The image has been loaded successfully.
                                                      return child;
                                                    } else if (loadingProgress
                                                            .cumulativeBytesLoaded ==
                                                        loadingProgress
                                                            .expectedTotalBytes) {
                                                      // The image failed to load.
                                                      return Container(
                                                        alignment:
                                                            Alignment.center,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color:
                                                              Colors.grey[300],
                                                        ),
                                                        height: 30,
                                                        width: 150,
                                                        child: const Text(
                                                            'Failed to load!!'),
                                                      );
                                                    } else {
                                                      // The image is still loading.
                                                      return Column(
                                                        children: [
                                                          Expanded(
                                                              flex: 1,
                                                              child: Lottie.asset(
                                                                  'assets/progressBar.json',
                                                                  reverse:
                                                                      true)),
                                                          Expanded(
                                                              flex: 3,
                                                              child: Lottie.network(
                                                                  'https://lottie.host/a2c7b6fe-1363-4562-95e7-1375d3568f92/zmqqT186Ei.json')),
                                                        ],
                                                      );
                                                      ;
                                                    }
                                                  },
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    // Error occurred while loading the image.
                                                    return Container(
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Colors.grey[300],
                                                      ),
                                                      height: 30,
                                                      width: 150,
                                                      child: const Text(
                                                          'Failed to load!!'),
                                                    );
                                                  },
                                                ),
                                              )
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

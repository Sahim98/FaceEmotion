import 'package:facecam/ui/auth/show%20username.dart';
import 'package:facecam/ui/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool loading = false;
  final _usrcontroller = TextEditingController();
  final _formfield = GlobalKey<FormState>();
  final datab =
      FirebaseDatabase.instance.ref('Username'); //creating table of Username

  final ref = FirebaseDatabase.instance.ref('Username');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        leading: IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return usr();
                },
              ));
            },
            icon: Icon(Icons.arrow_back_ios)),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Form(
            key: _formfield,
            child: Column(
              children: [
                TextFormField(
                  onChanged: (value) {},
                  validator: (value) {
                    if (value!.isEmpty)
                      return 'Unique should be UserName';
                    else
                      return null;
                  },
                  controller: _usrcontroller,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.person_outline_rounded,
                      color: Colors.white,
                    ),
                    labelText: 'Username',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  maxLength: 30,
                  maxLines: 4,
                  autocorrect: true,
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      loading = true;
                    });
                    datab.ref
                        .child(DateTime.now().microsecondsSinceEpoch.toString())
                        .set({
                      'title': _usrcontroller.text.toString(),
                    }).then((value) {
                      Utils().toastMessage('Post added');
                      setState(() {
                        loading = false;
                      });
                    }).onError((error, stackTrace) {
                      Utils().toastMessage(error.toString());
                      setState(() {
                        loading = false;
                      });
                    });
                  },
                  child: loading
                      ? CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text('Sign Up'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

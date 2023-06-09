import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:facecam/auth/SignUp/verify.dart';
import 'package:facecam/auth/residual/design.dart';
import 'package:facecam/auth/SignUp/login.dart';
import 'package:facecam/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  //----------------------variable declaration
  bool loading = false, auth = false, unique_user = false, showPass = true;
  final style = TextStyle(fontWeight: FontWeight.bold, color: Colors.white);
  String name = '';

  DateTime _date = DateTime.now();
  final _formfield = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final _usrcontroller = TextEditingController();
  final _agecontroller = TextEditingController();

  //-------------------creating table of Username
  final firestore = FirebaseFirestore.instance
      .collection(
        'Username',
      )
      .snapshots();

  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addUsers() async {
    FirebaseFirestore.instance
        .collection('Username')
        .add({'name': _usrcontroller.text.toString()});

    FirebaseFirestore.instance.collection('Users').add({
      'name': _usrcontroller.text,
      'email': emailController.text,
      'age': _agecontroller.text,
      'address': "N/A"
    });
  }

  checkUsernameIsUnique(String username) async {
    QuerySnapshot querySnapshot;
    setState(() {
      loading = true;
    });
    querySnapshot = await FirebaseFirestore.instance
        .collection('Username')
        .where('name', isEqualTo: username)
        .get();

    setState(() {
      unique_user = !(querySnapshot.docs.isEmpty);
    });

    setState(() {
      loading = false;
    });
  }

//------------------Date picker
  void showDate() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2030))
        .then((value) {
      DateTime now = value!;
      String formattedDate = DateFormat('yyyy-MM-dd').format(now);
      setState(() {
        _agecontroller.text = formattedDate;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.amber,
                  Colors.orange,
                ],
              ),
            ),
            child: Center(
              child: ListView(
                padding: EdgeInsets.all(25),
                children: [
                  Container(
                    height: 53,
                    child: DefaultTextStyle(
                      style: GoogleFonts.aladin(
                        textStyle:
                            TextStyle(fontSize: 35, color: Colors.purple),
                      ),
                      child: Center(
                        child: AnimatedTextKit(
                          repeatForever: true,
                          animatedTexts: [
                            TyperAnimatedText('Emotion detection'),
                            ScaleAnimatedText('😡😃😥😮')
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text('Sign Up',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.aladin(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontFamily: 'OpenSans',
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                  ),
                  SizedBox(
                    height: 35,
                    width: MediaQuery.of(context).size.width,
                    child: Text('Hi ' + name + '!!',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.aladin(
                          textStyle: TextStyle(
                            color: Colors.purple,
                            fontFamily: 'OpenSans',
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                  ),
                  Form(
                    key: _formfield,
                    child: Column(
                      children: [
                        TextFormField(
                          onChanged: (value) async {
                            setState(() async {
                              setState(() {
                                name = value;
                              });
                              checkUsernameIsUnique(value);
                              setState(() {
                                loading = false;
                              });
                            });
                          },
                          validator: (value) {
                            if (value!.isEmpty)
                              return 'UserName shouldn\'t be empty';
                            else if (unique_user)
                              return 'UserName should be unique';
                            else if (value.length < 4)
                              return 'Username must be at least 4 characters';
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                            filled: true,
                            fillColor: Color.fromARGB(255, 246, 191, 135),
                          ),
                          keyboardType: TextInputType.text,
                          maxLength: 30,
                          autocorrect: true,
                        ),
                        (name.length == 0)
                            ? CircularProgressIndicator(
                                color: Colors.deepOrange,
                                strokeWidth: 5,
                              )
                            : (unique_user
                                ? SizedBox(
                                    child: Text(
                                      '*@' + name + ' already exists.',
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    height: 20,
                                  )
                                : SizedBox(
                                    height: 20,
                                    child: Text(
                                      '@' + name + ' is available.',
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty)
                              return 'E-mail is required';
                            else
                              return null;
                          },
                          controller: emailController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.white,
                            ),
                            labelText: 'E-mail',
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                            filled: true,
                            fillColor: Color.fromARGB(255, 246, 191, 135),
                          ),
                          keyboardType: TextInputType.text,
                          maxLength: 40,
                          autocorrect: true,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty)
                              return 'Password is required';
                            else
                              return null;
                          },
                          obscureText: !showPass,
                          obscuringCharacter: '*',
                          controller: passController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(
                              Icons.security,
                              color: Colors.white,
                            ),
                            labelText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            filled: true,
                            fillColor: Color.fromARGB(255, 246, 191, 135),
                          ),
                          keyboardType: TextInputType.text,
                          maxLength: 10,
                          autocorrect: true,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty)
                              return 'Birthdate is required';
                            else
                              return null;
                          },
                          controller: _agecontroller,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.calendar_today),
                            labelText: 'Birthdate',
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            filled: true,
                            fillColor: Color.fromARGB(255, 246, 191, 135),
                          ),
                          keyboardType: TextInputType.text,
                          maxLength: 10,
                          autocorrect: true,
                          onTap: () {
                            showDate();
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 20.0,
                    child: Row(
                      children: <Widget>[
                        Theme(
                          data: ThemeData(unselectedWidgetColor: Colors.white),
                          child: Checkbox(
                            value: showPass,
                            checkColor: Colors.white,
                            activeColor: Colors.green,
                            onChanged: (value) {
                              setState(() {
                                showPass = !showPass;
                              });
                            },
                          ),
                        ),
                        Text(
                          'show password',
                          style: kLabelStyle,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 25.0),
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.orange[700],
                          elevation: 6,
                          padding: EdgeInsets.all(15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                        ),
                        onPressed: () {
                          if (_formfield.currentState!.validate()) {
                            setState(() {
                              loading = true;
                            });
                            _auth
                                .createUserWithEmailAndPassword(
                              email: emailController.text.toString(),
                              password: passController.text.toString(),
                            )
                                .then((value) {
                              setState(() {
                                loading = false;
                                addUsers();
                              });
                              setState(() {
                                auth = true;
                              });
                              Navigator.of(context) //new screen
                                  .pushReplacement(MaterialPageRoute(
                                      builder: (context) => VerifyScreen()));
                            }).onError((error, stackTrace) {
                              Utils().toastMessage("SignUP failed");
                              setState(() {
                                loading = false;
                              });
                              setState(() {
                                auth = false;
                              });
                              setState(() {
                                unique_user = false;
                              });
                            });
                          }
                        },
                        child: loading
                            ? CircularProgressIndicator(
                                backgroundColor: Colors.white,
                                strokeWidth: 5,
                              )
                            : auth
                                ? Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.done,
                                        size: 40,
                                        color: Colors.green,
                                      ),
                                      Text('  Signed Up!!'),
                                    ],
                                  )
                                : Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 1.5,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'OpenSans',
                                    ),
                                  )),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: style,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return Login();
                            },
                          ));
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(fontSize: 20),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
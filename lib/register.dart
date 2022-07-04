import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController emailregisController = TextEditingController();
  TextEditingController passwordregisController = TextEditingController();
  TextEditingController fnameregisController = TextEditingController();
  TextEditingController lnameregisController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
       SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white, Colors.blue])),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromRGBO(245, 245, 245, 1),
                          border: Border.all(color: Colors.black, width: 2)),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.fromLTRB(0, 15, 0, 20),
                              width: 100,
                              height: 100,
                              decoration: const BoxDecoration(
                                  color: Colors.black, shape: BoxShape.circle),
                              child: const Center(
                                  child: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 75,
                              )),
                            ),
                            const Text('SIGN UP',
                                textDirection: TextDirection.ltr,
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25)),
                            Row(
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 2 - 55,
                                  margin: const EdgeInsets.fromLTRB(20, 30, 0, 0),
                                  child: TextFormField(
                                    controller: fnameregisController,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      border: OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black)),
                                      prefixIcon: Icon(
                                        Icons.person,
                                        size: 40,
                                        color: Colors.black,
                                      ),
                                      hintText: "First Name",
                                      hintStyle: TextStyle(color: Colors.black),
                                      labelText: "First Name",
                                      labelStyle: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 2 - 55,
                                  margin:
                                      const EdgeInsets.fromLTRB(10, 30, 20, 0),
                                  child: TextFormField(
                                    controller: lnameregisController,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      border: OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black)),
                                      prefixIcon: Icon(
                                        Icons.person,
                                        size: 40,
                                        color: Colors.black,
                                      ),
                                      hintText: "Last Name",
                                      hintStyle: TextStyle(color: Colors.black),
                                      labelText: "Last Name",
                                      labelStyle: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                              child: TextFormField(
                                controller: emailregisController,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black)),
                                  prefixIcon: Icon(
                                    Icons.email_rounded,
                                    size: 40,
                                    color: Colors.black,
                                  ),
                                  hintText: "Email",
                                  hintStyle: TextStyle(color: Colors.black),
                                  labelText: "Email",
                                  labelStyle: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                              child: TextFormField(
                                controller: passwordregisController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black)),
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    size: 35,
                                    color: Colors.black,
                                  ),
                                  hintText: "Password",
                                  hintStyle: TextStyle(color: Colors.black),
                                  labelText: "Password",
                                  labelStyle: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                              child: TextFormField(
                                obscureText: true,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black)),
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    size: 35,
                                    color: Colors.black,
                                  ),
                                  hintText: "Confirm Password",
                                  hintStyle: TextStyle(color: Colors.black),
                                  labelText: "Confirm Password",
                                  labelStyle: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                            Container(
                              height: 40,
                              width: 100,
                              margin: const EdgeInsets.fromLTRB(20, 25, 20, 0),
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(20)),
                              child: TextButton(
                                style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                ),
                                onPressed: () async {
                                  if (FirebaseAuth.instance.currentUser == null) {
                                    try {
                                      await FirebaseAuth.instance
                                          .createUserWithEmailAndPassword(
                                              email: emailregisController.text,
                                              password:passwordregisController.text).then((value){
                                                FirebaseFirestore.instance
                                                .collection('userData')
                                                .doc(value.user?.uid)
                                                .set({
                                                  'fname': fnameregisController.text,
                                                  'lname': lnameregisController.text,
                                                  'email': value.user?.email,
                                                  'img': '55964ebb02710d6b9ce1c26f1d857906.jpg?alt=media&token=37eea2c1-1128-48ab-9562-574ef3850478'
                                                });
                                              });
                                              FirebaseAuth.instance
                                                      .signOut();
                                                  Navigator.pushNamed(
                                                      context, '/login');
                                      Navigator.pushNamed(context, '/login');
                                    } on FirebaseAuthException catch (e) {
                                      showNotification(context, e.message.toString());
                                    }
                                  }
                                },
                                child: const Text(
                                  'Sign Up',
                                  textDirection: TextDirection.ltr,
                                ),
                              ),
                            ),
                            Container(
                              height: 35,
                              margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/login');
                                },
                                child: const Text(
                                  "Have Account",
                                  textDirection: TextDirection.ltr,
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                          ]),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showNotification(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.orange.shade900,
        content: Text(message.toString())));
  }
}

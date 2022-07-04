import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();  

  void showNotification(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.orange.shade900,
        content: Text(message.toString())));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(30),
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.blue]
          )
        ),
        child: 
        Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 450,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromRGBO(245, 245, 245, 1),
                      border: Border.all(color: Colors.black, width: 2)
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                      margin: const EdgeInsets.fromLTRB(0, 15, 0, 20),
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle
                      ),
                      child: 
                        const Center(
                          child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 75,
                        )
                      ),
                    ),  
                    const Text('SIGN IN',
                          textDirection: TextDirection.ltr,
                          style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 25
                        )
                    ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(20, 40, 20, 5),
                        child: TextFormField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)
                            ),
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
                        margin: const EdgeInsets.fromLTRB(20, 5, 20,0),
                        child: TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            contentPadding:EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)
                            ),
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
                        height: 35,
                        alignment: Alignment.topRight,
                        margin: const EdgeInsets.fromLTRB(20, 0, 20,20),                    
                        child: TextButton(
                          onPressed: (){},
                          child: const Text(
                            "Forgot password?", 
                            textDirection: TextDirection.ltr,
                            style : TextStyle (
                              color : Colors.blue,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 40,
                        width: 100,
                        margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: TextButton(
                          style: ButtonStyle(
                            foregroundColor:MaterialStateProperty.all<Color>(Colors.white),
                          ),
                          onPressed: () async {

                            if (FirebaseAuth.instance.currentUser == null) {
                              try {
                                await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                  email: emailController.text,
                                  password:passwordController.text);

                                Navigator.pushNamed(context, '/home');                                  
                              } on FirebaseAuthException catch (e) {
                                showNotification(context, e.message.toString());
                              }
                              
                            }
                          },
                          child: const Text(
                            'LOGIN',
                            textDirection: TextDirection.ltr,
                          ),
                        ),
                      ),
                      Container(
                        height: 35,
                        margin: const EdgeInsets.fromLTRB(20, 0, 20,0),                    
                        child: TextButton(
                          onPressed: (){
                            Navigator.pushNamed(context, '/register');
                          },
                          child: const Text(
                            "Need Account?", 
                            textDirection: TextDirection.ltr,
                            style : TextStyle (
                              color : Colors.blue,
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
    );
  }
}
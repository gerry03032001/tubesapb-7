import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:tubes_app_7/home.dart';
import 'package:tubes_app_7/login.dart';
import 'package:tubes_app_7/register.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: const Login(),
          routes: {
            '/home': (BuildContext context) => const Home(),
            '/register': (BuildContext context) => const Register(),
            '/login': (BuildContext context) => const Login(),
          });
    } else {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const Home(),
        routes: {
          '/home': (BuildContext context) => const Home(),
          '/register': (BuildContext context) => const Register(),
          '/login': (BuildContext context) => const Login(),
        },
      );
    }
  }
}

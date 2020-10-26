import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:testing_book/screens/loginscreen.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:testing_book/screens/signupscreen.dart';
import 'package:testing_book/screens/welcomescreen.dart';
import 'package:testing_book/screens/splashscreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: "Testing Book App", 
    debugShowCheckedModeBanner: false,
    initialRoute: '/', routes: {
      '/': (context) => Splash(),
      '/login': (context) => LoginScreen(),
      '/signup': (context) => Signup(),
      '/welcome': (context) => Welcome(),
    });
  }
}

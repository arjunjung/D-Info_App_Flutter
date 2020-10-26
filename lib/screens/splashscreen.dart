import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:testing_book/screens/loginscreen.dart';

class Splash extends StatefulWidget {
  Splash({Key key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var size = MediaQuery.of(context).size;

    return SplashScreen(
      seconds: 5,
      navigateAfterSeconds: LoginScreen(),
      imageBackground: AssetImage('images/splash_new.jpeg'),
      backgroundColor: Colors.white,
      styleTextUnderTheLoader: TextStyle(
      ),
      loaderColor: Colors.blue[30],
      
    );
  }
}
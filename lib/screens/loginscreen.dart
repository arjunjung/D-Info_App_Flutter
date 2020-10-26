// import 'package:firebase_auth/firebase_auth.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testing_book/decoratedtextfield.dart';
import 'package:testing_book/screens/signupscreen.dart';
import 'package:testing_book/screens/welcomescreen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:testing_book/services.dart';
import 'package:testing_book/models.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({
    Key key,
  }) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // final User user = FirebaseAuth.instance.currentUser;
  bool _isSuccessMessage = false;
  String _textMessage = "";

  @override
  Widget build(BuildContext context) {
    // _logoutUser();
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: WillPopScope(
        onWillPop: _onBackPressed,
        child: _loginBody(context,ModalRoute.of(context).settings.arguments),
      )
    );
  }

  Widget _loginBody(BuildContext context, Map<String,String> arguments) {
    final userEmail = new TextEditingController();
    final userPassword = new TextEditingController();
    double height = MediaQuery.of(context).size.height;
    double weight = MediaQuery.of(context).size.width;
    // var deviceInfo;
    // getDeviceInfoFuture().then((value) => deviceInfo = value);

    return ListView(shrinkWrap: true, padding: const EdgeInsets.all(15), children: [
      Center(
        child: Column(children: [
          SizedBox(height: height * 0.10),
          arguments != null ? Container(child: Text(arguments['message']),padding: const EdgeInsets.all(8)) : SizedBox(),
          textfieldUsername("Username", userEmail),
          SizedBox(height: height * 0.05),
          textfieldPassword("Password", userPassword),
          SizedBox(height: height * 0.10),
          ElevatedButton(
              child: Text("  Login "),
              onPressed: () async {
                var responseBody = await loginUser(getLoggableUser(userEmail.text, userPassword.text));

                if (responseBody['statusCode'] == 400) {
                  setState(() {
                    _isSuccessMessage = false;
                    _textMessage = "";
                    _textMessage += "http:400 | Username or Password Invalid";
                  });
                } else if (responseBody['statusCode'] == 500) {
                  setState(() {
                    _isSuccessMessage = false;
                    _textMessage = "";
                    _textMessage += "http:500 | Internal Server Error.";
                  });
                } else if (responseBody['statusCode'] == 401) {
                  setState(() {
                    _isSuccessMessage = false;
                    _textMessage = "";
                    _textMessage += "http:401 | Unauthorized User";
                  });
                } else if (responseBody['statusCode'] == 400) {
                  setState(() {
                    _isSuccessMessage = false;
                    _textMessage = "";
                    _textMessage += "http:400 | You can't log in from different device.";
                  });
                } else if (responseBody['statusCode'] == 200) {
                  setState(() {
                    _isSuccessMessage = true;
                    _textMessage = "";
                    _textMessage += "http:200 | User Successfully Logged In";
                  });
                  Navigator.pushNamed(context, '/welcome', arguments: <String, String>{
                    "user": responseBody['user'],
                  });
                } else {
                  setState(() {
                    _isSuccessMessage = false;
                    _textMessage = "";
                    _textMessage += "http: ${responseBody['statusCode']} | Unknown Error";
                  });
                }
              }),
          SizedBox(height: height * 0.05),
          Text("Don't have any account? Create Here"),
          SizedBox(height: height * 0.05),
          ElevatedButton(
              child: Text("  Signup  "),
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              }),
          SizedBox(height: height * 0.05),
          Text(
            _textMessage,
            style: _isSuccessMessage ? TextStyle(color: Colors.green) : TextStyle(color: Colors.red),
          ),
        ]),
      ),
    ]);
  }


  // Future<bool> _checkingCredentials(String userEmail, String password) async {
  //   try {
  //     UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
  //       email: userEmail,
  //       password: password,
  //     );
  //   } on FirebaseAuthException catch (e) {
  //     print(e.message.toString());
  //     return Future<bool>.value(false);
  //   } catch (e) {
  //     print(e.message.toString());
  //     return Future<bool>.value(false);
  //   }
  //   return Future<bool>.value(true);
  // }

  Future<Widget> customAlert(String title, String content) {
    return showDialog(
        builder: (context) => AlertDialog(
              title: Text(title),
              content: Text(content),
              elevation: 12,
              actions: [
                FlatButton(
                  autofocus: true,
                  child: Text("Close Me"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }

  // void _logoutUser() {
  //   FirebaseAuth.instance.signOut();
  // }

  LoginUser getLoggableUser(String username, String password) {
    return LoginUser(username: username, password: password);
  }

   Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are you sure?'),
            content: Text('You are going to exit the application!!'),
            actions: <Widget>[
              FlatButton(
                child: Text('NO'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: Text('YES'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        });
  }

  // String _readDataFromSharedPref(String key) {
  //   return sharedPreferences.getString(key);
  // }
}

//Previous Login Code Firebase
//  onPressed: () => Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => (_checkingCredentials(userEmail.text.toString(), userPassword.text.toString()) == Future<bool>.value(true)
//                           ? Welcome()
//                           : Text("Unauthorized User ", style: TextStyle(color: Colors.red)))))),

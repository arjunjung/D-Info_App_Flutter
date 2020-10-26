import 'package:flutter/material.dart';
import 'package:testing_book/screens/loginscreen.dart';
import 'package:testing_book/screens/verifyscreen.dart';
import '../decoratedtextfield.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:testing_book/constants.dart';
import 'package:testing_book/services.dart' as S;
import 'package:testing_book/models.dart' as U;
import 'package:device_info/device_info.dart';

class Signup extends StatefulWidget {
  Signup({Key key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  // final FirebaseAuth auth = FirebaseAuth.instance;
  String _textMessage = "";
  bool _isSuccessMessage = false;
  BuildContext context;
  Map<String, dynamic> _fullDeviceInfo;

  @override
  Widget build(BuildContext context) {
    this.context = context;

    return Scaffold(
      appBar: AppBar(title: Text("Signup")),
      body: _bodySignup(context),
    );
  }

  Widget _bodySignup(BuildContext context) {
    final userEmail = new TextEditingController();
    final userPassword = new TextEditingController();
    double height = MediaQuery.of(context).size.height;
    double weight = MediaQuery.of(context).size.width;
    //Map<String,dynamic>

    return ListView(shrinkWrap: true, padding: const EdgeInsets.all(15), children: [
      Center(
          child: Column(
        children: [
          SizedBox(height: height * 0.10),
          textfieldUsername("Username", userEmail),
          SizedBox(height: height * 0.05),
          textfieldPassword("Password", userPassword),
          SizedBox(height: height * 0.01),
          Text("Password should contain numbers and letters only."),
          SizedBox(height: height * 0.10),
          ElevatedButton(
            child: Text("  Signup  "),
            onPressed: () async {
              print("SIGNUP NEWS:");
              var responseBody = await S.registerUser(getPreUser(userEmail.text, userPassword.text));

              print("SignUp news: $responseBody");
              // responseBody.values.forEach((v) {
              //   setState(() {
              //     _textMessage += v.toString();
              //   });
              // });

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
                  _textMessage += "http:401 | Bad Credentials";
                });
              } else if (responseBody['statusCode'] == 201) {
                setState(() {
                  _isSuccessMessage = true;
                  _textMessage = "";
                  _textMessage += "http:201 | User Successfully Created";
                });
                var resDeviceInfo = await S.deviceInfo(getDeviceInfo(responseBody['user_id']));

                if (resDeviceInfo['statusCode'] != 201) {
                  var resDelete = await S.deleteUser(responseBody['user_id']);
                }
                print("REsDeviceInfo: $resDeviceInfo");

                deviceInfoValidation(resDeviceInfo, _fullDeviceInfo['androidId'], _fullDeviceInfo['model'], _fullDeviceInfo['manufacturer']);
              } else {
                setState(() {
                  _isSuccessMessage = false;
                  _textMessage = "";
                  _textMessage += "http: ${responseBody['statusCode']} | Unknown Error";
                });
              }
            },
          ),
          SizedBox(height: height * 0.05),
          Text("Already have an account? Login Here"),
          SizedBox(height: height * 0.05),
          ElevatedButton(
            child: Text("  Login  "),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/login',
              );
            },
          ),
          SizedBox(height: height * 0.05),
          Text(
            _textMessage,
            style: _isSuccessMessage ? TextStyle(color: Colors.green) : TextStyle(color: Colors.red),
          ),
        ],
      )),
    ]);
  }

  // Future<String> _registerUser(String email, String password) async {
  //   try {
  //     print("Signup: data sent");
  //     return S.registerUser(getPreUser(email, password));
  //   }
  //   on FirebaseAuthException catch (e) {
  //     if (e.code == 'weak-password') {
  //       print("Week password");
  //       final snackbarError = SnackBar(
  //         content: Text("Weak password."),
  //         action: SnackBarAction(
  //           label: 'Error',
  //           onPressed: () {
  //           },
  //         ),
  //       );
  //       Scaffold.of(context).showSnackBar(snackbarError);
  //     } else if (e.code == 'email-already-in-use') {
  //       print("The account already exists for that email");
  //     }
  //   }
  //   catch (e) {
  //     print(e);
  //   } finally {
  //     print("User successfully created.");
  //     Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => VerifiyEmail(),
  //         ));
  //   }
  // }

  @override
  Future<void> initState() {
    // TODO: implement initState
    super.initState();
    getAndroidinfo();
  }

  Future<void> getAndroidinfo() async {
    DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    _fullDeviceInfo = S.getDeviceInfoFuture(await deviceInfoPlugin.androidInfo);
  }

  U.User getPreUser(String username, String password) {
    U.User user = new U.User(username: username, email: "test@gmail.com", password: password, is_staff: false);
    return user;
  }

  U.DeviceInfo getDeviceInfo(int userId) {
    return U.DeviceInfo(
        name: _fullDeviceInfo['model'],
        android_uuid: _fullDeviceInfo['androidId'],
        // manufacturer: _fullDeviceInfo['manufacturer'],
        user: userId);
  }

  void deviceInfoValidation(var responseBody, String androidId, String model, String manufacturer) {
    if (responseBody['statusCode'] == 400) {
      setState(() {
        _isSuccessMessage = false;
        _textMessage = "";
        _textMessage +=
            "[ *Device Model: $manufacturer - $model *Android_Id: $androidId  ] <<<<=======>>> Registration blocked! Device model with this android id already exists.";
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
        _textMessage += "http:401 | Bad Credentials";
      });
    } else if (responseBody['statusCode'] == 201) {
      setState(() {
        _isSuccessMessage = true;
        _textMessage = "";
        _textMessage += "http:200 | [ *Device Model: $manufacturer - $model *Android_Id: $androidId  ] Successfully device registered.";
      });
      Navigator.pop(context);
      Navigator.pushNamed(
        context,
        '/login',
      );
    } else {
      setState(() {
        _isSuccessMessage = false;
        _textMessage = "";
        _textMessage += "http: ${responseBody['statusCode']} | Unknown Error";
      });
    }
  }
}
